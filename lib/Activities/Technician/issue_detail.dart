import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:http/http.dart' as http;
class IssueDetails extends StatefulWidget {
  const IssueDetails({super.key});

  @override
  State<IssueDetails> createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetails  > {
  double? width;
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  List<Map> jobs = [];
  List<int>? timers; 
  List<List<Map>> listOfTasks=[];
  String timestamp()
  {
      DateTime now = DateTime.now();
      String formattedDateTime = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";
      return formattedDateTime;
  }
  String _twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  }
  return "0$n";
}
  String formatTime(int totalSeconds) {
  int hours = totalSeconds ~/ 3600;
  int remainingSeconds = totalSeconds % 3600;
  int minutes = remainingSeconds ~/ 60;
  int seconds = remainingSeconds % 60;
  String formattedTime = '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  return formattedTime;
}

    Timer? timer;
       List<List<Map>> l=[];
        bool isStart=true;

  void bottomSheet(String taskId,int time) {
    TextEditingController? reasonController = TextEditingController();
    bool isKeyboardOpened = true;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (BuildContext context) {
          final node1 = FocusNode();
          
          if (isKeyboardOpened) {
            FocusScope.of(context).requestFocus(node1);
            isKeyboardOpened = false;
          }
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 250,
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Center(
                      child: CustomTitleText(
                    title: 'On Paused',
                    size: 24,
                    color: Color(0XFF282828),
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      CustomTitleText(
                        title: 'Reason',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    node1: node1,
                     onSubmitted: () {
                        String reason= reasonController.text;
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        setTransaction(taskId,'Pause',time, reason, '');
                      },
                    usernameController: reasonController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Write down the reason...',
                    obscureText: false,
                    suffixWidget: const Text(''),
                    width: width!,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                
                 
                  const SizedBox(
                    height: 16,
                  ),
                  CustomSubmitButton(onPressed: () {
                    String reason = reasonController.text;    
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                        setTransaction(taskId,'Pause',time, reason, '');
                    Navigator.of(context).pop();
                        
                  }), 
                ],
              ),
            ),
          );
        });
  }
  int diff(d1,d2)
  {
     DateTime timestamp1 = DateTime.parse(d1);
  DateTime timestamp2 = DateTime.parse(d2);

  // Calculate time difference
  Duration timeDifference = timestamp2.difference(timestamp1);

  // Print the result
  
  return timeDifference.inSeconds;
  
  }
  void setTransaction(String taskId,String status,int time,String reason,String comment)async{
      String url = '${urlHead}insertDataForTransaction.php';
           http.post(Uri.parse(url), body: {
              'time': time.toString(),
              'reason': reason,
              'comment': comment,
              'task_id': taskId,
              'work_status': status,
              'timestamp': timestamp(),
            });
  }
  void bottomSheetOnStop() {
      
  }
    void getJobs() async
    { 
          List<Map> list = [];
          String url = '${urlHead}queryDataForJobs.php';
          final response = await http.get(Uri.parse(url));
          var j = json.decode(response.body);
         
          for (var n in j) {
            list.add(n);

            String url = '${urlHead}queryDataForTasks.php';
            final response = await http.post(Uri.parse(url), body: {
              'job_id': n['job_id'].toString(),
            });
            
            List<Map> tasksList=[];
            var j = json.decode(response.body); 
                
            for (var n in j) {
           
             String url = '${urlHead}queryDataForTransactions.php';
            final res = await http.post(Uri.parse(url), body: {
              'task_id': n['task_id'].toString(),
            });
            List k = json.decode(res.body); 
            int sum=0;
            if(k.isNotEmpty)
            {

                for(int o=0;o<k.length-1;o++)
                {  
                  int diff=int.parse(k[o+1]['total_time']) - int.parse(k[o]['total_time']) ;
                    sum+=diff;
                }  
            }
             var m={
              'time': sum,
              'isStart':true,
            };
             Map<String, dynamic> concatenatedMap = {}..addAll(n)..addAll(m);
             tasksList.add(concatenatedMap);
             listOfTasks.add(tasksList);
           } 
          }
             

           setState(() {
             jobs=list;
       
           });
    }
     
@override
  void initState() {
     
    super.initState();
    getJobs(); 
  }
  @override
  Widget build(BuildContext context) {
     width = MediaQuery.of(context).size.width;
    return   Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
         
        child: 
        jobs.isNotEmpty?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(txt: 'Issue'),
            const SizedBox(
              height: 16,
            ),
            const CustomTitleText(title: '  Issue Details', size: 18, color: Color(0xFF282828)),
             const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius:
                        BorderRadius.circular(10), // Radius for rounded corners
                    border: Border.all(
                      color: const Color(0xFF282828)
                          .withOpacity(0.5), // Light grey border color
                      width: 2.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.5), // Shadow color and opacity
                        spreadRadius: 5, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: const Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTitleText(title: 'Asset Tag', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title: 'ABCD_007', size: 14, color: Color(0xFF909090)),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTitleText(title: 'Issue Description', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title: 'issue in the handle\nof car', size: 14, color: Color(0xFF909090)),
                       SizedBox(
                        height: 10,
                      ),
                      CustomTitleText(title: 'Current Status', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title: 'Pending...', size: 14, color: Color(0xFF909090)),
                    ],
                  ),
                  Column(
                
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTitleText(title: 'Reported on', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title: '7 July`23', size: 14, color: Color(0xFF909090)),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTitleText(title: 'Priority', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title:'High', size: 14, color: Color(0xFF909090)),
                       SizedBox(
                        height: 10,
                      ),
                      CustomTitleText(title: 'Due on', size: 16, color: Color(0xFF282828)),
                      CustomTitleText(title: '20 July`23', size: 14, color: Color(0xFF909090)),
                    ],
                  ),
                ],
              ),
            ),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                   Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10,0),
                          width: 160 ,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: const Color(0XFF246EE9),
                              shadowColor:
                                  const Color(0XFF282828), // Text color
                            ),
                            onPressed: (){
                            
                            },
                            child: const Center(
                              child: CustomTitleText(
                                  title: "View Attachments",
                                  size: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                   
                ],
            ),
            const CustomTitleText(title: '  Jobs', size: 18, color: Color(0xFF282828)),
            const SizedBox(
              height: 8,
            ),

              Expanded(
                child: ListView.builder(
        
                   scrollDirection: Axis.vertical,
                       
                      itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      
                      return Container(
                        margin: const EdgeInsets.fromLTRB(8,4,8,4),
                        decoration:  BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius:
                        BorderRadius.circular(10), // Radius for rounded corners
                    border: Border.all(
                      color: const Color(0xFF282828)
                          .withOpacity(0.5), // Light grey border color
                      width: 2.0, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.5), // Shadow color and opacity
                        spreadRadius: 5, // Spread radius
                        blurRadius: 10, // Blur radius
                        offset: const Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                        child: ExpansionTile(
                           onExpansionChanged: (value){
                                      
                                      
                            },
                          childrenPadding: const EdgeInsets.all(8),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              Row(
                                children: [
                                  const CustomTitleText(title: 'Job Id : ', size: 16, color: Color(0xFF282828)),
                                  Text('${jobs[index]['job_id']}',style: const TextStyle(
                                    color: Color(0xFF909090),
                                    fontWeight: FontWeight.bold
                                  ),)
                                ],
                              ),
        
                              const SizedBox(
                                height: 4,
                              ),
        
                                Row(
                                children: [
                                  const CustomTitleText(title: 'Job Title : ', size: 16, color: Color(0xFF282828)),
                                  Text('${jobs[index]['job_title']}',style: const TextStyle(
                                    color: Color(0xFF909090),
                                    fontWeight: FontWeight.bold
        
                                  ),)
                                ],
                              ),
                             
        
                            ],
                          ) ,
                          
                          leading:  CircleAvatar(
                            backgroundColor:const Color(0XFF246EE9),
                            child: Text('${index+1}',style: const TextStyle(color: Colors.white),),
                          ),
                   
                          children: [
                            //Inside Job
                             
                            ListView.builder(
                               scrollDirection: Axis.vertical,
                                   shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                            itemCount: listOfTasks[index].length,
                                itemBuilder: (context, i) {
                                  return      
                                  Container(      
                                      margin: const EdgeInsets.fromLTRB(8,4,8,4),
                                    decoration:  BoxDecoration(
                                      color: Colors.white, // Background color
                                      borderRadius:
                                    BorderRadius.circular(10), // Radius for rounded corners
                                                                   border: Border.all(
                                  color: const Color(0xFF282828)
                                      .withOpacity(0.5), // Light grey border color
                                  width: 2.0, // Border width
                                 ),
                                  ),
                                    child: ExpansionTile(  
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const CustomTitleText(title: 'Task Id : ', size: 16, color: Color(0xFF282828)),
                                              Text('${listOfTasks[index][i]['task_id']}',style: const TextStyle(
                                                color: Color(0xFF909090),
                                                fontWeight: FontWeight.bold
                                              ),)
                                               ],
                                          ),              
                                          const SizedBox(
                                            height: 4,
                                          ),
                                                             
                                            Row(
                                            children: [
                                              const CustomTitleText(title: 'Task Title : ', size: 16, color: Color(0xFF282828)),
                                              Text('${listOfTasks[index][i]['task_title']}',style: const TextStyle(
                                                color: Color(0xFF909090),
                                                fontWeight: FontWeight.bold             
                                              ),)
                                            ],
                                          ),
                                         
                                                             
                                        ],
                                      ) ,
                                      
                                      leading:  CircleAvatar(
                                        backgroundColor:const Color(0XFF246EE9),
                                        child: Text('${(index+1)+(i+1)/10}',style: const TextStyle(color: Colors.white),),
                                      ),
                                     childrenPadding: const EdgeInsets.all(8),
                                    
                                      children:     [
                                                Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                               Row(
                                            children: [
                                                const CustomTitleText(title: 'Time : ', size: 14, color: Color(0xFF282828)),
                                              Text(formatTime(listOfTasks[index][i]['time']),style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF909090),
                                                fontWeight: FontWeight.bold     
                                              ),)
                                            ],
                                          ),
                                           const Row(
                                            children: [
                                              CustomTitleText(title: 'Assign to : ', size: 14, color: Color(0xFF282828)),
                                              Text('Kundan Kumar',style: TextStyle(
                                                color: Color(0xFF909090),
                                                fontSize: 14,
        
                                                fontWeight: FontWeight.bold
                                                             
                                              ),)
                                            ],
                                          ),
                                          
                                        ],),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          children: [
                                               const Spacer(),
                                           listOfTasks[index][i]['isStart']?
                                               ElevatedButton(
                                              onPressed: () {
                                                 
                                              timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
                                                   setState(() {
                                                   listOfTasks[index][i]['time']++;
                                                   });
                                                });
                                                setState(() {
                                                  listOfTasks[index][i]['isStart']=false;
                                                });
                                                
                                                setTransaction(listOfTasks[index][i]['task_id'],'Start',listOfTasks[index][i]['time'], '','');
                                              },
                                                style: ElevatedButton.styleFrom(
                                                            foregroundColor: Colors.black,
                                                            backgroundColor: const Color(0xFF019031),
                                                            shadowColor: const Color(0XFFFFFFFF), // Text color
                                                          ),
                                               child:   const Text('Start',style: TextStyle(
                                                color: Colors.white
                                               ),),
                                               ):
                                               ElevatedButton(
                                              onPressed: () {   
                                                  timer!.cancel();
                                                  bottomSheet(listOfTasks[index][i]['task_id'],listOfTasks[index][i]['time']);
                                                  setState(() {
                                                   listOfTasks[index][i]['isStart']=true; 
                                                  });
                                              },
                                                style: ElevatedButton.styleFrom(
                                                            foregroundColor: Colors.black,
                                                            backgroundColor: const Color(0XFF246EE9),
                                                            shadowColor: const Color(0XFFFFFFFF), // Text color
                                                          ),
                                               child:   const Text('Pause',style: TextStyle(
                                                color: Colors.white
                                               ),),
                                               ),
                                               const SizedBox(
                                                width: 8,
                                               ),
                                                ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                            
                                                            context: context,
                                                            isScrollControlled: true,
                                                            
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                                                            builder: (BuildContext context) {
                                                            
                                                              return const BottomSheetForStop();
                                                              
                                                            },
                                                            
                                                            );
                                              },
                                                style: ElevatedButton.styleFrom(
                                                            foregroundColor: Colors.black,
                                                            backgroundColor: const Color(0XFFBA2F16),
                                                            shadowColor: const Color(0XFFFFFFFF), // Text color
                                                          ),
                                               child:   const Text('Stop',style: TextStyle(
                                                color: Colors.white
                                               ),),
                                               ),
                                          ],
                                        ),
                                        
                                        
                                        ],
                                     
                                      
                                      ),
                                  );
                                }
                                      ),
                             
                             ],
                          
                          
                          ),
                      );
                    }
                          ),
              ),
          
          ],
        ):const Center(
          child: CircularProgressIndicator(

          ),
        ),
      
      
      ),
    );
  }
}
class BottomSheetForStop extends StatefulWidget {
  const BottomSheetForStop({super.key});

  @override
  State<BottomSheetForStop> createState() => _BottomSheetForStopState();
}

class _BottomSheetForStopState extends State<BottomSheetForStop> {
     TextEditingController? labourController = TextEditingController(),
        sparePartsController = TextEditingController(),
        consumablesController = TextEditingController(),
        commentsController = TextEditingController();
    bool isKeyboardOpened = true;
    String? selectedAction='hold';
    bool isCompleted=false;
    double? width;
    List<String> selectAction=['hold','cancel','completed'];
  @override
  Widget build(BuildContext context) {
    width=MediaQuery.of(context).size.width;
      final node1 = FocusNode();
          final node2 = FocusNode();
          final node3 = FocusNode();
          final node4 = FocusNode();
          if (isKeyboardOpened) {
            // FocusScope.of(context).requestFocus(node1);
            isKeyboardOpened = false;
          }
    return   Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height:isCompleted?400:300,
              margin: const EdgeInsets.fromLTRB(16.0,16,16,8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Center(
                      child: CustomTitleText(
                    title: 'Stop Task',
                    size: 24,
                    color: Color(0XFF282828),
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                                
                   const CustomTitleText(
                      title: 'Action',
                      size: 18,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 10),
                    // Your content goes here
                    Container(
                      width: width!/2.25,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ]),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAction,
                          onChanged: (String? newValue) {
                            setState(() {

                              selectedAction = newValue!;
                              if(newValue=='completed') {
                                isCompleted=true;
                              }
                              else{
                                isCompleted=false;
                              }
                            });
                          },
                          items: selectAction.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language,
                                  style: const TextStyle(fontSize: 18)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    
                    ],
                  ),
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTitleText(
                        title: 'Attachments',
                        size: 18,
                        color: Color(0XFF282828)),
                             
                  const SizedBox(
                    height: 10,
                  ),
                 Row(
                      children: [
                        
                        SizedBox(
                          width: 175,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0XFF246EE9),
                              shadowColor:
                                  const Color(0XFFFFFFFF), // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              // pickFile();
                            },
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTitleText(
                                    title: '+ ', size: 20, color: Colors.white),
                                CustomTitleText(
                                    title: 'Add Attachments',  
                                    size: 16,
                                    color: Colors.white),
                              ],
                            )),
                          ),
                        ),
                       
                      ],
                    ),
                        ],
                      ),
                         
                      ],
                  ),     
                  const SizedBox(
                    height: 16,
                  ),
                  isCompleted?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTitleText(
                        title: 'Labours',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                             
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                            node1: node1,
                            usernameController: labourController!,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node4),
                            keyboardType: TextInputType.streetAddress,
                            hintText: "Labours...",
                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: width!/2.25,
                            onPressed: () {}),
                        ],
                      ),
                          
                 
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                              const Row(
                    children: [
                      CustomTitleText(
                        title: 'Spare Parts',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                            node1: node2,
                            usernameController: sparePartsController!,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node4),
                            keyboardType: TextInputType.streetAddress,
                            hintText: "Spare Parts...",
                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: width!/2.25,
                            onPressed: () {}),
                    ],
                  ),
                      ],
                  ):Container(),
                 isCompleted? const SizedBox(
                    height:  16 ,
                  ):Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     isCompleted? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTitleText(
                        title: 'Consumables',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                             
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                            node1: node3,
                            usernameController: consumablesController!,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node4),
                            keyboardType: TextInputType.streetAddress,
                            hintText: "Consumables...",

                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: width!/2.25,
                            onPressed: () {}),
                        ],
                      ):Container(),
                          
                  
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                              const Row(
                    children: [
                      CustomTitleText(
                        title: 'Comments',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                            node1: node4,
                            usernameController: commentsController!,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node4),
                            keyboardType: TextInputType.streetAddress,
                            hintText: "Comments...",
                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: isCompleted?width!/2.25:width!-40,
                            onPressed: () {}),
                    ],
                  ),
                      ],
                  ),
                  
                 
                  const SizedBox(
                    height: 8,
                  ),
                  CustomSubmitButton(onPressed: () {
                    // String email = userEmailController.text;
                    // String name=userNameController.text;
                    // String mobileNum=userMobController.text;
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    // submit(email,mobileNum,name);
                  }),
                ],
              ),
            ),
          );
  }
}