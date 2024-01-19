 

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled/Customs/mydrawer.dart';
import 'package:untitled/Data/data.dart';
import 'package:untitled/Data/listmodel.dart';
import 'package:http/http.dart' as http;

class AddPermission extends StatefulWidget {
  const AddPermission({super.key});

  @override
  State<AddPermission> createState() => _AddPermissionState();
}

class _AddPermissionState extends State<AddPermission> {
    TextEditingController? permissionNameController;
          String urlHead='http://192.168.1.108/dashboard/sf11/';

Color color=Colors.blue.shade900;
@override
  void initState() {
   
    super.initState();
     listOfUserRoles=[];
    permissionNameController= TextEditingController();
  }
    bool isClickedOnBox=false;
     late List<String> listOfUserRoles;
          List<String> selectCompany=[ 'ADMIN','INPUTER','APPROVER'];
tap(String s)
          {

            addDynamic(s);
            
            removeDropdownItem(s);
            setState(() {
              isClickedOnBox=false;
            });
          }
          addDynamic(String s)
          {
            setState(() {

              listOfUserRoles.add(
                  s
              );
            });
          }
          void removeDropdownItem(String itemToRemove) {

            setState(() {
              selectCompany.remove(itemToRemove);
              // if (selectedUserType == itemToRemove) {
              //   selectedUserType = selectUserType.isNotEmpty ? selectUserType[0] : null;
              // }
            });
          }
           void addPermission() async
          {
            String s='';
            if(listOfUserRoles.length>1)
            {
                 for(String i in listOfUserRoles)
                {

                   s='$s$i,';
                }
            }
             else{
              s=listOfUserRoles[0];
             }
           

            String url='${urlHead}insertDataForPermission.php';
            var data={
              'permission_name':permissionNameController?.text,
              'assign_to':s
            };

            final response= await http.post(Uri.parse(url), body: data);
            EasyLoading.showToast( response.body,toastPosition: EasyLoadingToastPosition.bottom);
            
          }
  double sizeOfDrawer=0.0;
  double size=0.0;
   late List<ListObject> listObjects=[];
  bool openedDashboard=false;
  @override
  Widget build(BuildContext context) {
     double fullSize=MediaQuery.of(context).size.width;

    size=fullSize/1.5;
    sizeOfDrawer=fullSize-size;
    return   Scaffold(
      appBar: AppBar(
        title: const Text('Add Permissions'),
         backgroundColor: color,
         leading:  DrawerButton(

              onPressed:  () {

                setState(() {
                  if(listObjects.isEmpty) {
                    listObjects=getList();
                  }
                  if(openedDashboard)
                  {
                    openedDashboard=false;

                  }
                  else
                  {
                    openedDashboard=true;

                  }


                });

              },
            ),
      ),
      body:  Row(
            children: [

              openedDashboard?   MyDrawer(sizeOfDrawer: sizeOfDrawer,list: listObjects,):
              Container(),
              Container(
                padding: const EdgeInsets.fromLTRB(5, 18, 5, 0),
                width: openedDashboard?size: fullSize,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Container(
                     decoration: BoxDecoration(
                         border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                     ),
                     child: TextField(
                       controller: permissionNameController,
                       decoration: const InputDecoration(
                         hintText: "Permission Name",
                         hintStyle: TextStyle(color: Colors.grey),
                         border: InputBorder.none,

                       ),
                     ),
                   ),
                   const SizedBox(
                     height: 25,
                   ),
                   const Text(
                     'User Role : ',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                       color: Colors.grey
                     ),
                   ),
                   const SizedBox(
                     height: 18,
                   ),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         isClickedOnBox=true;
                       });
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width,


                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         border: Border.all(
                           color: Colors.grey.shade300,

                         ),

                       ),

                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           SizedBox(
                             height: 50,
                             child: ListView.builder(
                               shrinkWrap: true,
                               scrollDirection: Axis.horizontal,
                               itemBuilder: (_,index){
                                 return  Container(
                                   margin: const EdgeInsets.all(10),

                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       color: Colors.blue[900]
                                   ),
                                   child: Center(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text(' ${listOfUserRoles[index]} ',style: const TextStyle(
                                           color: Colors.white,
                                           fontSize: 12,
                                         ),),
                                         IconButton(
                                           onPressed: (){
                                             setState(() {
                                               selectCompany.add(listOfUserRoles[index]);

                                               listOfUserRoles.removeAt(index);
                                             });
                                           },
                                           icon:const Icon(Icons.close,color: Colors.white,size: 16) ,
                                         ),

                                       ],
                                     ),
                                   ),
                                 );
                               },itemCount: listOfUserRoles.length,),
                           ),
                           isClickedOnBox? SizedBox(
                             // Fixed height for the vertical list
                               height: 150,
                               child: ListView.builder(itemBuilder: (_,index){
                                 return
                                   ListTile(

                                     title: Text(selectCompany[index]),
                                     onTap: (){

                                       tap(selectCompany[index]);
                                     },
                                   );

                               },itemCount:selectCompany.length )

                           ):Container(),
                         ],
                       ),
                     ),
                   ),
                   const SizedBox(
                     height: 25,
                   ),
                  Center(
                    child: ElevatedButton(onPressed: addPermission, child: const Text(
                      'Add Permissions',
                    )),
                  )
                  ],
                ),
              ),
              
            ],
          ),
    );
  }
}