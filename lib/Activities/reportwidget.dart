import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/Customs/mydrawer.dart';
import 'package:untitled/Data/listmodel.dart';
import '../Data/data.dart';

//Report Widget
class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  List<Map> groupCompany = [
    {'id': '1', 'group_company_name': 'Select Group Company'}
  ];
  late List<ListObject> listObjects = [];
  List<Map> selectCompany = [];
  List<Map> tableData = [];
  List<Map> selectCostCare = [];
  List<String> selectLocation = ['Select Location'];
  List<String> selectAssetType = ['Select Asset Type'];
  List<Map> selectAssetCategory = [];
  List<DataColumn> columnList = [];
  List<DataRow> rowList = [];

  @override
  initState() {
    super.initState();
    getgroupCompanyList();
    getAssetCategoryList();
    getDataColumnList();
  }

  void getgroupCompanyList() async {
    var d = {'id': '1', 'group_company_name': 'Select Group Company'};
    List<Map> list = [d];
    const url = 'http://192.168.1.108/dashboard/sf11/viewData.php';
    final response = await http.get(Uri.parse(url));
    var j = json.decode(response.body);
    for (var n in j) {
      var d = {'id': n['id'], 'group_company_name': n['group_company_name']};
      list.add(d);
    }
    setState(() {
      groupCompany = list;
    });
  }

  getselectCompanyList(String id) async {
    var d = {'id': 0, 'name': 'Select Company'};
    List<Map> list = [d];
    const url = 'http://192.168.1.108/dashboard/sf11/queryData.php';
    if (id.isNotEmpty) {
      final response = await http.post(Uri.parse(url), body: {
        'id': id,
      });

      var j = json.decode(response.body);
      for (var n in j) {
        d = {'id': n['id'], 'name': n['name']};
        list.add(d);
      }
      setState(() {
        selectCompany = list;
      });
    }
  }

  getselectCostCareList(String id) async {
    var d = {'id': 0, 'name': 'Select Cost Centre'};

    List<Map> list = [d];
    const url = 'http://192.168.1.108/dashboard/sf11/queryCostCareData.php';

    final response = await http.post(Uri.parse(url), body: {
      'id': id,
    });

    var j = json.decode(response.body);

    for (var n in j) {
      d = {'id': n['id'], 'name': n['name']};

      list.add(d);
    }
    setState(() {
      selectCostCare = list;
    });
  }

  getselectLocationList(String id) async {
    List<String> list = ['Select Location'];
    const url = 'http://192.168.1.108/dashboard/sf11/queryLocationData.php';

    final response = await http.post(Uri.parse(url), body: {
      'id': id,
    });

    var j = json.decode(response.body);

    for (var n in j) {
      list.add(n['location']);
    }
    setState(() {
      selectLocation = list;
    });
  }

  getAssetCategoryList() async {
    var d = {'id': 0, 'name': 'Select Asset Category'};
    List<Map> list = [d];
    const url =
        'http://192.168.1.108/dashboard/sf11/queryAssetCategoryData.php';
    final response = await http.get(Uri.parse(url));
    var j = json.decode(response.body);
    for (var n in j) {
      d = {'id': n['id'], 'name': n['name']};
      list.add(d);
    }
    setState(() {
      selectAssetCategory = list;
    });
  }

  getselectAssetTypeList(String id) async {
    List<String> list = ['Select Asset Type'];
    const url = 'http://192.168.1.108/dashboard/sf11/queryAssetTypeData.php';

    final response = await http.post(Uri.parse(url), body: {
      'id': id,
    });

    var j = json.decode(response.body);

    for (var n in j) {
      list.add(n['name']);
    }
    setState(() {
      selectAssetType = list;
    });
  }

  void setRowDataForCompany() {
    List<DataRow> dataRow = [];

    for (var r in tableData) {
      if (r['company'] == selectedCompany) {
        dataRow.add(DataRow(
          cells: <DataCell>[
            DataCell(Text(r['group_company'])),
            DataCell(Text(r['company'])),
            DataCell(Text(r['cost_centre'])),
            DataCell(Text(r['asset_location'])),
            DataCell(Text(r['asset_category'])),
            DataCell(Text(r['asset_type'])),
            DataCell(Text(r['asset_tag'])),
            DataCell(Text(r['asset_status'])),
            DataCell(Text(r['asset_quantity'].toString())),
          ],
        ));
      }
    }
    setState(() {
      rowList = dataRow;
    });
  }

  void setRowDataForCostCenter() {
    List<DataRow> dataRow = [];

    for (var r in tableData) {
      if (r['company'] == selectedCompany &&
          r['cost_centre'] == selectedCostCentre) {
        dataRow.add(DataRow(
          cells: <DataCell>[
            DataCell(Text(r['group_company'])),
            DataCell(Text(r['company'])),
            DataCell(Text(r['cost_centre'])),
            DataCell(Text(r['asset_location'])),
            DataCell(Text(r['asset_category'])),
            DataCell(Text(r['asset_type'])),
            DataCell(Text(r['asset_tag'])),
            DataCell(Text(r['asset_status'])),
            DataCell(Text(r['asset_quantity'].toString())),
          ],
        ));
      }
    }
    setState(() {
      rowList = dataRow;
    });
  }

  void setRowDataForLocation() {
    List<DataRow> dataRow = [];

    for (var r in tableData) {
      if (r['company'] == selectedCompany &&
          r['cost_centre'] == selectedCostCentre &&
          r['asset_location'] == selectedLocation) {
        dataRow.add(DataRow(
          cells: <DataCell>[
            DataCell(Text(r['group_company'])),
            DataCell(Text(r['company'])),
            DataCell(Text(r['cost_centre'])),
            DataCell(Text(r['asset_location'])),
            DataCell(Text(r['asset_category'])),
            DataCell(Text(r['asset_type'])),
            DataCell(Text(r['asset_tag'])),
            DataCell(Text(r['asset_status'])),
            DataCell(Text(r['asset_quantity'].toString())),
          ],
        ));
      }
    }
    setState(() {
      rowList = dataRow;
    });
  }

  void getRowData() async {
    List<Map> list = [];
    List<DataRow> dataRow = [];
    const url = 'http://192.168.1.108/dashboard/sf11/queryTableData.php';

    final response = await http.post(Uri.parse(url), body: {
      'company': selectedGroupCompany,
    });

    var j = jsonDecode(response.body);

    for (var r in j) {
      list.add(r);
      dataRow.add(DataRow(
        cells: <DataCell>[
          DataCell(Text(r['group_company'])),
          DataCell(Text(r['company'])),
          DataCell(Text(r['cost_centre'])),
          DataCell(Text(r['asset_location'])),
          DataCell(Text(r['asset_category'])),
          DataCell(Text(r['asset_type'])),
          DataCell(Text(r['asset_tag'])),
          DataCell(Text(r['asset_status'])),
          DataCell(Text(r['asset_quantity'])),
        ],
      ));
    }

    tableData = list;
    setState(() {
      rowList = dataRow;
    });
  }

  void getDataColumnList() {
    List<DataColumn> list = [];
    TextStyle tx = const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    DataColumn gc = DataColumn(
      label: Expanded(
          child: Text(
        'Group Company',
        style: tx,
      )),
    );
    DataColumn c = DataColumn(
      label: Expanded(
        child: Text(
          'Company',
          style: tx,
        ),
      ),
    );
    DataColumn cc = DataColumn(
      label: Expanded(
        child: Text(
          'Cost Centre',
          style: tx,
        ),
      ),
    );
    DataColumn l = DataColumn(
      label: Expanded(
        child: Text('Location', style: tx),
      ),
    );
    DataColumn as = DataColumn(
      label: Expanded(
        child: Text('Asset Category', style: tx),
      ),
    );
    DataColumn at = DataColumn(
      label: Expanded(
        child: Text('Asset Type', style: tx),
      ),
    );
    DataColumn at2 = DataColumn(
      label: Expanded(
        child: Text('Asset Tag', style: tx),
      ),
    );
    DataColumn as2 = DataColumn(
      label: Expanded(
        child: Text('Asset Status', style: tx),
      ),
    );
    DataColumn aq = DataColumn(
      label: Expanded(
        child: Text('Asset Quantity', style: tx),
      ),
    );

    list.add(gc);
    list.add(c);
    list.add(cc);
    list.add(l);
    list.add(as);
    list.add(at);
    list.add(at2);
    list.add(as2);
    list.add(aq);

    setState(() {
      columnList = list;
    });
  }

  String selectedGroupCompany = 'Select Group Company';
  String selectedCompany = 'Select Company';
  String selectedAssetType = 'Select Asset Type';
  String? selectedCostCentre = 'Select Cost Centre';
  String? selectedLocation = 'Select Location';
  int id = 0;
  String? name = 'Dashboard';
  double sizeOfDrawer = 0.0;
  double size = 0.0;
  bool openedDashboard = false;
  Color color = Colors.blue.shade900;
  String selectedAssetCategory = 'Select Asset Category';

  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;

    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Stock Verification'),
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
          Flexible(
            child: Container(
              width: openedDashboard ? size : fullSize,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Group Comapany
                  Row(
                    children: [
                      Text(
                        'Group Company :  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: openedDashboard ? 12 : 16,
                        ),
                      ),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedGroupCompany,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGroupCompany = newValue!;
                            selectedCompany = "Select Company";
                            selectedCostCentre = "Select Cost Centre";
                            selectedLocation = 'Select Location';
                            selectCostCare = [];
                            selectLocation = [];
                            selectCompany = [];
                          });
                          for (var v in groupCompany) {
                            if (v['group_company_name'] == newValue) {
                              getselectCompanyList(v['id']);
                            }
                          }

                          getRowData();
                        },
                        items: groupCompany.map((Map language) {
                          return DropdownMenuItem<String>(
                            value: language['group_company_name'],
                            child: Text(language['group_company_name'],
                                style: TextStyle(
                                    fontSize: openedDashboard ? 10 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  //Comapny
                  Row(
                    children: [
                      Text(
                        'Company :  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: openedDashboard ? 12 : 16,
                        ),
                      ),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedCompany,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCompany = newValue!;
                            selectedCostCentre = "Select Cost Centre";
                            selectedLocation = 'Select Location';
                            selectCostCare = [];
                            selectLocation = [];
                          });
                          for (var v in selectCompany) {
                            if (v['name'] == newValue) {
                              getselectCostCareList(v['id']);
                            }
                          }
                          setRowDataForCompany();
                        },
                        items: selectCompany.map((Map language) {
                          return DropdownMenuItem<String>(
                            value: language['name'],
                            child: Text(language['name'],
                                style: TextStyle(
                                    fontSize: openedDashboard ? 10 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  //Cost Centre
                  Row(
                    children: [
                      Text('Cost Centre :  ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: openedDashboard ? 12 : 16)),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedCostCentre,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCostCentre = newValue!;
                            selectedLocation = 'Select Location';
                            selectLocation = [];
                          });
                          for (var v in selectCostCare) {
                            if (v['name'] == newValue) {
                              getselectLocationList(v['id']);
                            }
                          }
                          setRowDataForCostCenter();
                        },
                        items: selectCostCare.map((Map language) {
                          return DropdownMenuItem<String>(
                            value: language['name'],
                            child: Text(language['name'],
                                style: TextStyle(
                                    fontSize: openedDashboard ? 10 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  //Location
                  Row(
                    children: [
                      Text('Location :  ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: openedDashboard ? 12 : 16)),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedLocation,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });

                          setRowDataForLocation();
                        },
                        items: selectLocation.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language,
                                style: TextStyle(
                                    fontSize: openedDashboard ? 12 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //Asset Category
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asset Category :  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: openedDashboard ? 12 : 16,
                        ),
                      ),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedAssetCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAssetCategory = newValue!;
                            selectedAssetType = 'Select Asset Type';
                          });
                          for (var v in selectAssetCategory) {
                            if (v['name'] == newValue) {
                              getselectAssetTypeList(v['id']);
                            }
                          }
                        },
                        items: selectAssetCategory.map((Map language) {
                          return DropdownMenuItem<String>(
                            value: language['name'],
                            child: Text(language['name'],
                                style: TextStyle(
                                    fontSize: openedDashboard ? 10 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  //Asset Type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asset Type :  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: openedDashboard ? 12 : 16,
                        ),
                      ),

                      // Your content goes here
                      DropdownButton<String>(
                        value: selectedAssetType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAssetType = newValue!;
                          });
                        },
                        items: selectAssetType.map((String language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language,
                                style: TextStyle(
                                    fontSize: openedDashboard ? 10 : 16)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                        border: TableBorder.all(),
                        columns: columnList,
                        rows: rowList),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
