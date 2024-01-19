import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customtitletext.dart';

class IssueDetail extends StatefulWidget {
  final String ticketNo;
  const IssueDetail({super.key, required this.ticketNo});

  @override
  State<IssueDetail> createState() => _IssueDetailState();
}

class _IssueDetailState extends State<IssueDetail> {
  late Map assetData = {};
  bool hasAssetData = false;

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  void getDataFromDB() async {
    EasyLoading.show(status: 'Loading....');
    String url = 'http://192.168.1.108/dashboard/sf11/queryDataForAsset.php';
    final response = await http.post(Uri.parse(url), body: {
      'report_id': widget.ticketNo,
    });
    var j = json.decode(response.body);
    EasyLoading.dismiss();
    if (response.body.length > 2) {
      setState(() {
        assetData = j[0];
        hasAssetData = true;
      });
    }
  }

  Color color = Colors.blue.shade900;
  String urlhead = 'http://192.168.1.108/dashboard/sf11/';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(txt: 'Track Status'),
              const SizedBox(
                height: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width -
                      25, // You can adjust the width and height as needed
                  height: MediaQuery.of(context).size.height - 100,
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
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: hasAssetData
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Asset ID',
                                  style: TextStyle(
                                      color: Color(0XFF282828),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  assetData['asset_tag'],
                                  style: const TextStyle(
                                      color: Color(0XFF909090),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Issue Description',
                                          style: TextStyle(
                                              color: Color(0XFF282828),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          assetData['asset_issue'],
                                          style: const TextStyle(
                                              color: Color(0XFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Reported on',
                                          style: TextStyle(
                                              color: Color(0XFF282828),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '22/10/2023',
                                          style: TextStyle(
                                              color: Color(0XFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Current Status',
                                          style: TextStyle(
                                              color: Color(0XFF282828),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          assetData['issue_status'],
                                          style: const TextStyle(
                                              color: Color(0XFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      children: [
                                        Text(
                                          'Reported on',
                                          style: TextStyle(
                                              color: Color(0XFF282828),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '22/10/2023',
                                          style: TextStyle(
                                              color: Color(0XFF909090),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const Center(
                              child: CustomTitleText(
                                  title: 'No Data Found!',
                                  size: 16,
                                  color: Color(0xFF282828)),
                            )))
              //             Image.network(
              //   urlhead+widget.issue['img_path'],
              //   loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              //     if (loadingProgress == null) {
              //       return child;
              //     } else {
              //       return Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null
              //                 ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              //                 : null),
              //             SizedBox(height: 10),
              //             Text(
              //               '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toInt()}% loaded',
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
