import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Data/data.dart';
import 'package:untitled/Data/listmodel.dart';

import '../Customs/mydrawer.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  late TextEditingController _usernameController;
  Color color = Colors.blue.shade900;

  late TextEditingController _passwordController;
  List<String> selectUserType = [
    'Select User Type',
    'ADMIN',
    'INPUTER',
    'APPROVER',
    'HELP DESK'
  ];
  String? selectedUserType = 'Select User Type';
  double sizeOfDrawer = 0.0;
  double size = 0.0;
  late List<ListObject> listObjects = [];
  bool openedDashboard = false;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void createUser() async {
    const urlHead = 'http://192.168.1.108/dashboard/sf11/';
    const url = '${urlHead}insertDataForUser.php';
    var data = {
      'user_email': _usernameController.text,
      'user_password': _passwordController.text,
      'user_type': selectedUserType,
    };

    http.post(Uri.parse(url), body: data).then((response) {
      if (response.statusCode == 200) {
        // Data successfully addedprint
        EasyLoading.showToast("Inserted Successfully",
            toastPosition: EasyLoadingToastPosition.bottom);
      } else {
        // Error occurred
        EasyLoading.showToast("Error!",
            toastPosition: EasyLoadingToastPosition.bottom);
      }
    }).catchError((error) {
      EasyLoading.showToast("Error!",
          toastPosition: EasyLoadingToastPosition.bottom);
    });
  }

  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;
    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
        backgroundColor: color,
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
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200))),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200))),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'User Type : ',
                      ),
                      DropdownButton<String>(
                        value: selectedUserType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUserType = newValue!;
                          });
                        },
                        items: selectUserType.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language,
                                style: const TextStyle(fontSize: 18)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: createUser, child: const Text('Create User'))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
