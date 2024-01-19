import 'package:flutter/material.dart';
import 'package:untitled/Customs/mydrawer.dart';
import 'package:untitled/Data/data.dart';
import 'package:untitled/Data/listmodel.dart';

class Workers extends StatefulWidget {
  const Workers({super.key, required this.taskId});
  final String taskId;
  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  late List<ListObject> listObjects = [];
  late List<Map> listOfWorkers = [];
  String url = 'http://192.168.1.108/dashboard/sf11/queryDataForWorkers.php';
  bool openedDashboard = false;
  double sizeOfDrawer = 0.0;
  double size = 0.0;
  @override
  void initState() {
    super.initState();
  }

// void getDataOfWorkers() async{
//        final response=await http.get(Uri.parse(url));
//     var j=json.decode(response.body);
//       //  for(var n in j)
//       //  {
//       //   // print(n);
//       //  }
// }
  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;
    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workers'),
        leading: DrawerButton(
          onPressed: () {
            setState(() {
              if (listObjects.isEmpty) {
                listObjects = getList();
              }

              if (openedDashboard) {
                openedDashboard = false;
              } else {
                openedDashboard = true;
              }
            });
          },
        ),
      ),
      body: Row(
        children: [
          openedDashboard
              ? MyDrawer(
                  sizeOfDrawer: sizeOfDrawer,
                  list: listObjects,
                )
              : Container(),
          Container(
            width: openedDashboard ? size : fullSize,
            padding: const EdgeInsets.all(10),
            // child: ListView.builder(
            //   itemCount: issues.length, // The total number of items in your list.
            //   itemBuilder: (BuildContext context, int index) {
            //     // Return a widget for each item at the specified index.
            //     return Container(
            //       margin: EdgeInsets.fromLTRB(0,0,0,2.5),
            //       color: issues[index].color,
            //       child: ListTile(
            //         title:Text(issues[index].asset_tag!, style: TextStyle(
            //           color: Colors.white,
            //         ),),
            //         leading: Text(issues[index].id.toString(),style: TextStyle(
            //           color: Colors.white,
            //         ),),
            //         subtitle: Text(issues[index].asset_issue!,style: TextStyle(
            //           color: Colors.white,
            //         ),),
            //         trailing: Text(issues[index].issue_status!,style: TextStyle(
            //           color: Colors.white,
            //         ),),
            //       ),
            //     );
            //   },
            // ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Customs/MyDrawer.dart';
// import 'Issues.dart';
// import 'package:untitled/Data/data.dart';
// class TrackReport extends StatefulWidget {
//   const TrackReport({super.key});

//   @override
//   State<TrackReport> createState() => _TrackReportState();
// }

// class _TrackReportState extends State<TrackReport> {
 
 
//   bool openedDashboard=false;
//   double sizeOfDrawer=0.0;
//   double size=0.0;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getList();
//   }
  
//   void getList ()async
//   {

//     List<Issue> list=[Issue('Report Id', 'Asset Tag', '', 'Report Status','')];
//     String url=urlHead+'queryDataForIssues.php';
//     final response=await http.get(Uri.parse(url));
//     var j=json.decode(response.body);
//     for(var n in j)
//     {

//         Issue issue=new Issue(n['report_id'], n['asset_tag'], n['asset_issue'], n['issue_status'], n['level_of_urgency']);
//         list.add(issue);
//     }
//     setState(() {
//       issues=list;
//     });

//   }
//   @override
//   Widget build(BuildContext context) {
//     double fullSize=MediaQuery.of(context).size.width;

//     size=fullSize/1.5;
//     sizeOfDrawer=fullSize-size;
//     return Scaffold(

//       appBar: AppBar(
//         title: Text('Track Report'),
//         leading:  DrawerButton(
//           onPressed:  () {


//             setState(() {
//               if(openedDashboard)
//               {
//                 openedDashboard=false;
//               }
//               else
//               {
//                 openedDashboard=true;
//               }


//             });

//           },
//         ),
//       ),

//       body:
//     );
//   }
// }