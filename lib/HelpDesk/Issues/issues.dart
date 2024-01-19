 

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Issues extends StatefulWidget {
  const Issues({super.key});

  @override
  State<Issues> createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  Color color = Colors.blue.shade900;

  String urlHead = 'http://192.168.1.108/dashboard/sf11/';

  bool openedDashboard = false;
  List<Map> issues = [];
  @override
  void initState() {
    super.initState();
    getIssuesList();
  }

  Color getColor(String s) {
    switch (s) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.deepOrange;
      default:
        return Colors.blue;
    }
  }

  void getIssuesList() async {
    // Issue('Issue Id', 'Asset Tag', '', 'Report Status','')
    List<Map> list = [];
    String url = '${urlHead}queryDataForIssues.php';
    final response = await http.get(Uri.parse(url));
    var j = json.decode(response.body);
    for (var n in j) {
      list.add(n);
    }
    setState(() {
      issues = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues'),
        backgroundColor: color,
      ),
      body: Row(
        children: [
          // openedDashboard?   MyDrawer(sizeOfDrawer: sizeOfDrawer,list: listObjects,):
          // Container(),
          ListView.builder(
            itemCount: issues.length, // The total number of items in your list.
            itemBuilder: (BuildContext context, int index) {
              // Return a widget for each item at the specified index.
              return Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 2.5),
                color: getColor(issues[index]['level_of_urgency']),
                child: ListTile(
                  onTap: () {
                    if (issues[index]['report_id'] != 'Issue Id') {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => IssueDetail(issue: issues[index],)));
                    }
                  },
                  title: Text(
                    issues[index]['asset_tag'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  leading: Text(
                    issues[index]['report_id'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    issues[index]['asset_issue'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Text(
                    issues[index]['issue_status'],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
