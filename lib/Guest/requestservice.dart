import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';
import 'package:untitled/Guest/guestactivity.dart';

class RequestService extends StatefulWidget {
  final bool isReportScreen;
  const RequestService({super.key, required this.isReportScreen});

  @override
  State<RequestService> createState() => _RequestServiceState();
}

class _RequestServiceState extends State<RequestService> {

  late List<String> selectType;
  String selectedPriority = 'High';
  List<String> selectPriority = ['High', 'Medium', 'Low'];
  String? selectedType = 'Select Service';
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  late TextEditingController assetTagController,
      assetIssueController,
      locationController,
      nearByController;
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? controller;
  String? result;
  bool openedDashboard = false;
  bool isKeyBoardOpened = false;
  bool key = true;
  bool openedQR = false;
  bool isCurrentLocationAdded = false;
  bool isAttached = true;
  double? width;
  String imageStr = '';
  bool submitBttnPressed = true;
  final FocusNode assetTagFocusNode = FocusNode();
  final FocusNode assetIssueFocusNode = FocusNode();
  late Position currentposition;
  String? txt;
  File? imagepath;
  double? heigth = 40;
  String imageName = ' ';
  String? userEmail2;
  List<Map> images = [];
  String imageData = ' ';
  String errorTextAssetTag = '';
  String errorTextAssetIssue = '';
  String assetId = '';
  FocusNode? node1;
  FocusNode? node2;
  FocusNode? node3;
  FocusNode? node4;
  
  void _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showToast(
          'Location permissions are denied',
          toastPosition: EasyLoadingToastPosition.top,
          dismissOnTap: true,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      EasyLoading.showToast(
        'Location permissions are permanently denied, we cannot request permissions.',
        toastPosition: EasyLoadingToastPosition.top,
        dismissOnTap: true,
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentposition = position;
    } catch (e) {
      EasyLoading.showToast('Error',
          toastPosition: EasyLoadingToastPosition.top);
    }
  }
 
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userEmail = prefs.getString(
        'user_email'); // Replace 'key' with the key you used to save the data
    if (userEmail != null) {
      // Data exists, use it

      setState(() {
        userEmail2 = userEmail;
      });
    }  
  }

  String encryptData(String txt) {
    StringBuffer str = StringBuffer();
    for (var i = 0; i < txt.length; i++) {
      int charCode = txt.codeUnitAt(i);
      String char = String.fromCharCode(charCode + 3);
      str.write(char);
    }
    return str.toString();
  }

  String decryptData(String txt) {
    StringBuffer str = StringBuffer();
    for (var i = 0; i < txt.length; i++) {
      int charCode = txt.codeUnitAt(i);
      String char = String.fromCharCode(charCode - 3);
      str.write(char);
    }
    return str.toString();
  }

  void sendMailForApproval() async {
    int assetNum = int.parse(assetId) + 1;
    if (userEmail2!.isNotEmpty) {
      // setState(() {
      //   isClicked=false;
      // });
      EasyLoading.show(status: "Sending Mail...");

      //  String encryptedData= encryptData(userEmail2!);

      String adminEmail = 'kunal8076142807@gmail.com';
      String password = 'gbvm zwkm asvn dhfz';

      final smtpServer = gmail(adminEmail, password);
      final sms =
          '<!DOCTYPE html> <html> <head> <style> a{    color: white; text-decoration: none; }         body {             font-family: Arial, sans-serif;             text-align: center;         }         .container {             margin: 10px auto;             padding: 20px;             border: 1px solid #ccc;             border-radius: 5px;             max-width: 300px;         }         h1 {             font-size: 24px;         }         .button-container {             margin-top: 20px;         }         .button {             display: inline-block;             padding: 10px 20px;             margin: 0 10px;             border: none;             border-radius: 5px;             cursor: pointer;             font-size: 16px;         }         .confirm-button {             background-color: #4CAF50;             color: white;         }         .deny-button {             background-color: #FF5733;             color: white;         }     </style>  </head> <body>     <div class="container">         <h1>Ticket Raised Id </h1>         <p>$assetNum</p>            <div class="button-container">             <a href="myflutterapp://" class="button confirm-button"> Open in App </a>    </div>     </div> </body> </html>  ';
      // Create our message.
      final message = Message()
        ..from = Address(adminEmail, adminEmail)
        ..recipients.add(userEmail2!)
        // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        // ..bccRecipients.add(Address('bccAddress@example.com'))
        ..subject = 'Ticket Raised Id'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = sms;

      try {
        final sendReport = await send(message, smtpServer);
        EasyLoading.dismiss();
        EasyLoading.showToast(sendReport.toString(),
            toastPosition: EasyLoadingToastPosition.top);
      } on MailerException catch (e) {
        EasyLoading.dismiss();
        
        EasyLoading.showToast('Message not sent. ${e.message}',
            toastPosition: EasyLoadingToastPosition.top);
      }
    } else {
       
      snackBar(context, 'Fill All The Details', const Color(0xFF8B0000));
          
    }
  }

  void fetchDataFromQR(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      try {
        Map<String, dynamic> jsonMap = jsonDecode(event.code.toString());

        setState(() {
          assetTagController.text = jsonMap['asset_tag'];
          openedQR = false;
        });
        snackBar(context, 'Scanned Successfully', const Color(0xFF019031));   
      } catch (e) {
      snackBar(context, 'Invalid QR', const Color(0xFF8B0000));

        
      }
    });
  }

  Future<void> getImage() async {
    _determinePosition();
    if (images.length <= 9) {
      openedQR = false;
      final get = await ImagePicker().pickImage(source: ImageSource.camera);
      if (get == null) return;

      setState(() {
        imageStr = "${images.length + 1} attachments added successfully";
        imagepath = File(get.path);
        imageName = get.path.split('/').last;
        imageData = base64Encode(imagepath!.readAsBytesSync());
        var m = {'name': imageName, 'img_data': imageData};
        images.add(m);
      });
    } else {
      snackBar(context,'You can only add 10', const Color(0xFF8B0000));
    }
  }

  void getLastRow() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.108/dashboard/sf11/queryDataForLastRow.php'));
    var m = json.decode(response.body);
    setState(() {
      assetId = m[0]["report_id"];
    });
  }

  void pickFile() async {
    _determinePosition();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        imageStr =
            "${images.length + result.files.length} attachments added successfully";
        for (var m in result.files) {
          setState(() {
            imagepath = File(m.path!);
            imageName = m.name;
            imageData = base64Encode(imagepath!.readAsBytesSync());
            var d = {'name': imageName, 'img_data': imageData};
            images.add(d);
          });
        }
      }
    } catch (e) {
      e;
    }
  }

  void submit() async {
    var assetTag = assetTagController.text;
    var assetIssue = assetIssueController.text;

    if (assetTag.isNotEmpty && assetIssue.isNotEmpty) {
      EasyLoading.show(status: 'Submit...');
      submitBttnPressed = true;
      addImages(assetTag, assetIssue);
    } else {
      snackBar(context,'Fill Asset id and issue', const Color(0xFF8B0000));
    }
  }

  void addImages(String assetTag, String assetIssue) {
    int i;
    int assetNum = int.parse(assetId) + 1;

    int k = 0;
    do {
      Map<String, dynamic> data;
      if (images.isEmpty) {
        i = -1;
        data = {
          'issue_id': assetNum.toString(),
          'user_email': userEmail2,
          'level_of_urgency': selectedPriority,
          'asset_tag': assetTag,
          'asset_issue': assetIssue,
          'name': 'Null',
          'issue_service_type': selectedType,
          'location': locationController.text.toString(),
          'nearby_landmark': nearByController.text.toString(),
          'latitude': isCurrentLocationAdded? currentposition.latitude.toString():"0.0",
          'longitude':  isCurrentLocationAdded?currentposition.longitude.toString():"0.0",
          'img_data': 'Null'
        };
      } else {
        i = 0;
        data = {
          'issue_id': assetNum.toString(),
          'user_email': userEmail2,
          'level_of_urgency': selectedPriority,
          'asset_tag': assetTag,
          'asset_issue': assetIssue,
          'name': images[k]['name'],
          'issue_service_type': selectedType,
          'location': locationController.text.toString(),
          'nearby_landmark': nearByController.text.toString(),
          'latitude': currentposition.latitude.toString(),
          'longitude': currentposition.longitude.toString(),
          'img_data': images[k]['img_data']
        };
      }

      String urlHead = 'http://192.168.1.108/dashboard/sf11/';

      String url = '${urlHead}insertDataForReportIssue.php';

      http.post(Uri.parse(url), body: data).then((response) {
        if (response.body == response.body.split(':')[0]) {
          i++;
          if (i == images.length) {
            EasyLoading.dismiss();
            sendMailForApproval();
        snackBar(context, 'Issue Reported', const Color(0xFF019031));


            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GuestActivity()));
          }
        } else {
      snackBar(context,'Error', const Color(0xFF8B0000));
 
        }
      }).catchError((error) {
      snackBar(context,'Error', const Color(0xFF8B0000));

         
      });
      k++;
    } while (k < images.length);
  }

  @override
  void dispose() {
    super.dispose();
    assetTagFocusNode.dispose();
    assetIssueFocusNode.dispose();
    assetIssueController.dispose();
    assetTagController.dispose();
    controller?.dispose();
    locationController.dispose();
    nearByController.dispose();
  }

  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    node2 = FocusNode();
    node3 = FocusNode();
    node4 = FocusNode();
    selectType = widget.isReportScreen
        ? ['Select Issue', 'Issue 1', 'Issue 2', 'Issue 3']
        : ['Select Service', 'Service 1', 'Service 2', 'Service 3'];
    selectedType =
        widget.isReportScreen ? 'Select Issue' : 'Select Service';
     _determinePosition();

    currentposition = Position(
      latitude: 0.0,
      longitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    assetTagController = TextEditingController();
    assetIssueController = TextEditingController();
    locationController = TextEditingController();
    nearByController = TextEditingController();
    assetIssueFocusNode.addListener(() {
      if (assetIssueFocusNode.hasFocus) {
        setState(() {
          isKeyBoardOpened = true;
        });
      } else {
        setState(() {
          isKeyBoardOpened = false;
        });
      }
    });
    assetTagFocusNode.addListener(() {
      if (assetTagFocusNode.hasFocus) {
        setState(() {
          isKeyBoardOpened = true;
        });
      } else {
        setState(() {
          isKeyBoardOpened = false;
        });
      }
    });
    getLastRow();
    fetchData();
  }

  void _showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Asset ID Info'),
          content: const Text('Asset ID is an unique id for every asset.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0XFF192A56),
                shadowColor: const Color(0XFFFFFFFF), // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    txt = widget.isReportScreen ? 'Report an Issue' : 'Request for Service';
    if (key) {
      FocusScope.of(context).requestFocus(node1);
      key = false;
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(txt: txt),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    openedQR
                        ? SizedBox(
                            height: 400,
                            width: 400,
                            child: QRView(
                              key: _globalKey,
                              onQRViewCreated: fetchDataFromQR,
                            ),
                          )
                        : Container(),

                    Row(
                      children: [
                        const CustomTitleText(
                          title: 'Asset ID',
                          size: 18,
                          color: Color(0xFF282828),
                        ),
                        const CustomTitleText(
                          title: '*',
                          size: 18,
                          color: Colors.red,
                        ),
                        IconButton(
                            onPressed: () {
                              _showInformationDialog(context);
                            },
                            icon: const Icon(Icons.info)),
                      ],
                    ),

                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CustomTextField(
                            node1: node1!,
                            usernameController: assetTagController,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node2),
                            keyboardType: TextInputType.name,
                            hintText: 'Type your asset id...',
                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: width!,
                            onPressed: () {}),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (openedQR) {
                                    openedQR = false;
                                  } else {
                                    openedQR = true;
                                  }
                                });
                              },
                              icon: Icon(
                                openedQR?Icons.close:
                                Icons.qr_code_2,
                                size: 42,
                              )),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    CustomTitleText(
                        title: widget.isReportScreen
                            ? 'Issue Type'
                            : 'Service Type',
                        size: 18,
                        color: const Color(0xFF282828)),

                    const SizedBox(height: 10),
                    // Your content goes here

                    Container(
                      width: MediaQuery.sizeOf(context).width,
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
                          value: selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue!;
                            });
                          },
                          items: selectType.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language,
                                  style: const TextStyle(fontSize: 18)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        CustomTitleText(
                            title: widget.isReportScreen
                                ? 'Issue Description'
                                : 'Service Description',
                            size: 18,
                            color: const Color(0XFF282828)),
                        const CustomTitleText(
                            title: '*', size: 18, color: Colors.red)
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Center(
                          child: CustomTextField(
                              node1: node2!,
                              usernameController: assetIssueController,
                              onSubmitted: () =>
                                  FocusScope.of(context).requestFocus(node3),
                              keyboardType: TextInputType.multiline,
                              hintText: widget.isReportScreen
                                  ? "Type down what issue you have."
                                  : "Type down what service you want.",
                              obscureText: false,
                              suffixWidget: const Text(''),
                              width: width!,
                              onPressed: () {})),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

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
                              pickFile();
                            },
                            child: const Row(
                               
                              children: [
                                Text('+ ',style: TextStyle(
                                  fontSize: 20, color: Colors.white
                                ),),
                              Text('Add Attachments',style: TextStyle(
                                  fontSize: 16, color: Colors.white
                                ),),
                           
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 36,
                            ))
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Offstage(
                      offstage: images.isEmpty ? true : false,
                      child: Container(
                        width: MediaQuery.of(context).size.width -
                            25, // You can adjust the width and height as needed
                        height: (heigth! + (images.length * 15)),
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(
                              10), // Radius for rounded corners
                          border: Border.all(
                            color: const Color(0xFF282828)
                                .withOpacity(0.5), // Light grey border color
                            width: 0.5, // Border width
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
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: images.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.panorama_fisheye_outlined,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomTitleText(
                                    title: images[index]['name'],
                                    size: 14,
                                    color: const Color(0xFF282828),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const CustomTitleText(
                      title: 'Priority ',
                      size: 18,
                      color: Colors.black,
                    ),

                    const SizedBox(height: 10),
                    // Your content goes here
                    Container(
                      width: width,
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
                          value: selectedPriority,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPriority = newValue!;
                            });
                          },
                          items: selectPriority.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(language,
                                  style: const TextStyle(fontSize: 18)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const CustomTitleText(
                        title: 'Location', size: 18, color: Color(0XFF282828)),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        CustomTextField(
                            node1: node3!,
                            usernameController: locationController,
                            onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node4),
                            keyboardType: TextInputType.streetAddress,
                            hintText: "Enter your location",
                            obscureText: false,
                            suffixWidget: const Text(''),
                            width: width!,
                            onPressed: () {}),
                        IconButton(
                            onPressed: () {
                              setState(() {
                              isCurrentLocationAdded = true;   
                              });
                              snackBar(context, 'Your current location is attached.', const Color(0xFF019031));
                            },
                            icon: const Icon(
                              Icons.location_on,
                              size: 36,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const CustomTitleText(
                        title: 'Nearby Landmark',
                        size: 18,
                        color: Color(0XFF282828)),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        node1: node4!,
                        usernameController: nearByController,
                        onSubmitted: () {},
                        keyboardType: TextInputType.streetAddress,
                        hintText: "Enter your nearby landmark...",
                        obscureText: false,
                        suffixWidget: const Text(''),
                        width: width!,
                        onPressed: () {}),

                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: CustomSubmitButton(onPressed: (){ submitBttnPressed ? submit() : () {};}),
                    ),
                      
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
