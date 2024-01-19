import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Data/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Data/listmodel.dart';

import '../Customs/mydrawer.dart';

class Permissions extends StatefulWidget {
  const Permissions({super.key});

  @override
  State<Permissions> createState() => _PermissionsState();
}

class _PermissionsState extends State<Permissions> {
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  Color color = Colors.blue.shade900;
  bool isClickedOnBox = false;
  late List<bool> checkedItems = [];
  late List<Map> permissionsData = [];

  double sizeOfDrawer = 0.0;
  double size = 0.0;
  late List<ListObject> listObjects = [];
  bool openedDashboard = false;
  bool? hasDashboard = false;
  bool? hasQrScanner = false;
  bool? hasReport = false;
  bool? hasCreateUSer = false;
  bool? hasPermission = false;
  String? selectedUserType = 'ADMIN';
  List<String> selectUserType = [
    'Select User Type',
    'ADMIN',
    'INPUTER',
    'APPROVER',
    'HELP DESK'
  ];

  void getDataForPermissions() async {
    String url = '${urlHead}queryDataForPermissionsData.php';

    final response = await http.post(Uri.parse(url));

    var j = json.decode(response.body);
    for (var i in j) {
      var d = {
        'permission_name': i['permission_name'],
        'assign_to': i['assign_to']
      };

      permissionsData.add(d);

      if (d['assign_to'].toString().contains(selectedUserType!)) {
        checkedItems.add(true);
      } else {
        checkedItems.add(false);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataForPermissions();
  }

  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;
    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: const Text('Permissions'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          openedDashboard
              ? MyDrawer(
                  sizeOfDrawer: sizeOfDrawer,
                  list: listObjects,
                )
              : Container(),
          SingleChildScrollView(
            child: Container(
              width: openedDashboard ? size : fullSize,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Given Permissions : ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton<String>(
                    value: selectedUserType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUserType = newValue!;
                      });

                      int i = 0;
                      for (var k in permissionsData) {
                        if (k['assign_to']
                            .toString()
                            .contains(selectedUserType!)) {
                          setState(() {
                            checkedItems[i] = true;
                          });
                        } else {
                          setState(() {
                            checkedItems[i] = false;
                          });
                        }
                        i++;
                      }
                    },
                    items: selectUserType.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language,
                            style: const TextStyle(fontSize: 18)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: permissionsData.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title:
                              Text(permissionsData[index]['permission_name']),
                          value: checkedItems[index],
                          onChanged: (bool? newValue) {
                            setState(() {
                              checkedItems[index] = newValue!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can use the 'checkedItems' list to get the state of each checkbox.
          List<Map> selectedItems = [];
          String s = '';
          for (int i = 0; i < checkedItems.length; i++) {
            if (checkedItems[i]) {
              selectedItems.add(permissionsData[i]);
            }
          }
          for (var i = 0; i < selectedItems.length; i++) {
            if (!selectedItems[i]['assign_to']
                .toString()
                .contains(selectedUserType!)) {
              s = '${s + selectedItems[i]['permission_name']},';
            }
          }
          if (s.isNotEmpty) {
            s = s.substring(0, s.length - 1);

            updatePermissions(s);
          }
          // Do something with the selected items.
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  void updatePermissions(String selectedItems) async {
    String url = '${urlHead}updatePermission.php';

    http.post(Uri.parse(url), body: {
      'value': selectedItems,
      'user_role': selectedUserType,
    });
  }

  Future<void> sendListToServer(String selectedItems) async {
    final url = Uri.parse('${urlHead}updatePermission.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'list': selectedItems}),
    );

    if (response.statusCode == 200) {
      // Request was successful, you can handle the response here.
      EasyLoading.showToast('Request successful',
          toastPosition: EasyLoadingToastPosition.bottom);
    } else {
      // Handle any errors or issues with the request.
      EasyLoading.showToast('Request failed',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}
