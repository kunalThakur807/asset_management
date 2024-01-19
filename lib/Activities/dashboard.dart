import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled/Authentication/LoginPage.dart';
import 'package:untitled/Authentication/register.dart';
import 'package:untitled/Customs/mydrawer.dart';

import 'package:untitled/Data/listmodel.dart';

import 'dart:convert';
import '../Customs/mygridview.dart';
import '../Data/data.dart';

Color color = Colors.blue.shade900;

class DashBoard extends StatefulWidget {
  final String? userType;
  const DashBoard({super.key, required this.userType});
  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  late List<ListObject> listObjects = [];
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';

  List<Map> groupCompany = [
    {'id': '1', 'group_company_name': 'Select Group Company'}
  ];
  int timerValue = 60;
  List<String> selectCompany = ['Select Company'];
  
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getgroupCompanyList();
    getData("ADMIN");
      
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              // Prevent the dialog from being dismissed by pressing back
              onWillPop: () async {
                return false;
              },
              child: const MyAlertDialog(),
            );
          },
        );
        break;
      default:
    }
  }

  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_email');
    prefs.remove('user_type');
  }

  void getgroupCompanyList() async {
    var d = {'id': '1', 'group_company_name': 'Select Group Company'};
    List<Map> list = [d];
    String url = '${urlHead}viewData.php';
    final response = await http.get(Uri.parse(url));
    var j = json.decode(response.body);
    for (var n in j) {
      d = {'id': n['id'], 'group_company_name': n['group_company_name']};
      list.add(d);
    }
    setState(() {
      groupCompany = list;
    });
  }

  void getselectCompanyList(String id) async {
    List<String> list = ['Select Company'];
    String url = '${urlHead}queryData.php';

    final response = await http.post(Uri.parse(url), body: {
      'id': id,
    });

    var j = json.decode(response.body);
    for (var n in j) {
      list.add(n['name']);
    }
    setState(() {
      selectCompany = list;
    });
  }

  List<Map<String, dynamic>> listOfTickets = [
    {
      "num": "0",
      "title": "#Total Tickets",
    },
    {
      "num": "0",
      "title": "#Open Tickets",
    },
    {
      "num": "0",
      "title": "#Closed Tickets",
    },
    {
      "num": "0",
      "title": "#Pending with Requestor",
    },
  ];
  List<Map<String, dynamic>> listOfConsumables = [
    {
      "num": "0",
      "title": "#Consumables Stock Value",
    },
    {
      "num": "0",
      "title": "#Consumables Types",
    },
    {
      "num": "0",
      "title": "#Consumables < Min Qty",
    },
  ];
  List<Map<String, dynamic>> listOfAssets = [
    {
      "num": "0",
      "title": "#Assets Count",
    },
    {
      "num": "0",
      "title": "#Assets Value (Gross)",
    },
    {
      "num": "0",
      "title": "#Assets Value (WDV)",
    },
    {
      "num": "0",
      "title": "#Current Year Depreciation",
    },
    {
      "num": "0",
      "title": "#Current Year Depreciation",
    },
    {
      "num": "0",
      "title": "#Expired Assets",
    },
  ];

  String selectedGroupCompany = 'Select Group Company';

  String selectedCompany = 'Select Company';

  List<String> selectFinancialYear = ['Select Financial Year', '2023-2024'];
  String? selectedFinancialYear = 'Select Financial Year';
  int id = 0;
  double sizeOfDrawer = 0.0;
  double size = 0.0;

  bool openedDashboard = false;
  bool openQRScanner = false;
  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;

    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;
      
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: color,
          actions: [
            IconButton(
              onPressed: () {
                deleteData();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
            )
          ],
          leading: DrawerButton(
            onPressed: () {
               
                if (listObjects.isEmpty) {
                  setState(() {
                  listObjects = getList();
                  });
                }

                if (openedDashboard) {
                  setState(() {
                  openedDashboard = false;
                  });
                } else {
                  setState(() {
                  openedDashboard = true;
                  });
                }
               
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: Row(
            children: [
              openedDashboard
                  ? MyDrawer(
                      sizeOfDrawer: sizeOfDrawer,
                      list: listObjects,
                    )
                  : Container(),
              SizedBox(
                width: openedDashboard ? size : fullSize,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Group Company : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: openedDashboard ? size / 20 : 18,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          // Your content goes here
                          DropdownButton<String>(
                            value: selectedGroupCompany,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGroupCompany = newValue!;
                              });
                              for (var v in groupCompany) {
                                if (v['group_company_name'] == newValue) {
                                  getselectCompanyList(v['id']);
                                }
                              }
                            },
                            items: groupCompany.map((Map language) {
                              return DropdownMenuItem<String>(
                                value: language['group_company_name'],
                                child: Text(language['group_company_name'],
                                    style: TextStyle(
                                        fontSize:
                                            openedDashboard ? size / 24 : 18)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Company : ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: openedDashboard ? size / 20 : 18,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          // Your content goes here
                          DropdownButton<String>(
                            value: selectedCompany,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCompany = newValue!;
                              });
                            },
                            items: selectCompany.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language,
                                    style: TextStyle(
                                        fontSize:
                                            openedDashboard ? size / 24 : 18)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Financial Year : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: openedDashboard ? size / 24 : 18)),
                          const SizedBox(width: 8),
                          // Your content goes here
                          DropdownButton<String>(
                            value: selectedFinancialYear,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedFinancialYear = newValue!;
                              });
                            },
                            items: selectFinancialYear.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language,
                                    style: TextStyle(
                                        fontSize:
                                            openedDashboard ? size / 20 : 18)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const Text(
                        'Assets ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      MyGridView(
                          items: listOfAssets,
                          bgColor: const Color.fromARGB(255, 57, 204, 204),
                          fontSize: openedDashboard ? size / 25 : 18),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Consumables ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      MyGridView(
                          items: listOfConsumables,
                          bgColor: const Color.fromARGB(255, 0, 166, 90),
                          fontSize: openedDashboard ? size / 25 : 18),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tickets ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      MyGridView(
                        items: listOfTickets,
                        bgColor: const Color.fromARGB(255, 243, 156, 18),
                        fontSize: openedDashboard ? size / 25 : 18,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Inventory Report ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const TableDemo(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class TableDemo extends StatelessWidget {
  const TableDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Table(
            border: TableBorder.all(), // Add a border around the table
            children: const <TableRow>[
              // Create the first row with three columns
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Text(' Inventory Category',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(' Inventory Type',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(' Inventory Value',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(' Inventory Qty',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(' Issued Qty',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  TableCell(
                    child: Text(' Reserved Qty',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              // Create the second row with data
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 1'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 2'),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text('Data 3'),
                    ),
                  ),
                ],
              ),

              // You can add more rows as needed
            ],
          )
        ],
      ),
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  const MyAlertDialog({super.key});
  @override
  MyAlertDialogState createState() => MyAlertDialogState();
}

class MyAlertDialogState extends State<MyAlertDialog> {
  int _secondsRemaining = 10; // Change this to set the initial countdown time.
  late Timer _timer;
  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_email');
    prefs.remove('user_type');
  }

  void logout() {
    deleteData();

    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ));
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();

    // Start a timer that runs every second.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          logout();
          // Stop the timer when the countdown reaches 0.
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Session Timeout Alert'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Text('Your session will expire in $_secondsRemaining seconds'),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: color,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'Keep me logged in',
                    style: TextStyle(color: color),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Cancel the timer when the dialog is disposed to prevent memory leaks.
    super.dispose();
  }
}
