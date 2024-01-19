import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';     
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Activities/homepage.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';
 


class AssetVerification extends StatefulWidget {
  const AssetVerification({super.key});

  @override 
  State<AssetVerification> createState() => _AssetVerificationState();
}

class _AssetVerificationState extends State<AssetVerification> {
 
  
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  late TextEditingController assetTagController, 
      locationController,
      assetCoordinates,
      nearByController,
      remarkController;     
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? controller;
  String? result;
  bool isKeyBoardOpened = false;
  bool key = true;
  bool openedQR = false;
  bool isAttached = true;
  double? width;
  String imageStr = '';
  bool submitBttnPressed = true;
  final FocusNode assetTagFocusNode = FocusNode();
  final FocusNode assetIssueFocusNode = FocusNode();
  late Position currentposition;
  File? imagepath;
  double? heigth = 40;
  String imageName = ' ';
  String? indexId;
  List<Map> images = [];
  String imageData = ' ';
  String imageSize = ' ';
  String errorTextAssetTag = '';
  String assetId = '';
  FocusNode? node1;
  FocusNode? node2;
  FocusNode? node3;
  FocusNode? node4;
  
  void getDataFromDB() async
  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      indexId = prefs.getString('id');
      
  }
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
          setState(() {
      currentposition = position;
          });
    } catch (e) {
             
     _determinePosition();
    }
  }

  void fetchDataFromQR(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      try {
        Map<String, dynamic> jsonMap = jsonDecode(event.code.toString());
         if(openedQR)
          {
              snackBar(context, 'Scanned Successfully', const Color(0xFF019031));   
          } 
        setState(() {
          assetTagController.text = jsonMap['asset_tag'];
          openedQR = false;
        }); 
      } catch (e) {
      snackBar(context, 'Invalid QR', const Color(0xFF8B0000)); 
      }
    });
  }

  Future<void> getImage(ImageSource src) async {
    if (images.length <= 9) {
      openedQR = false;
      var get = await ImagePicker().pickImage(source: src);
     
      if (get == null) return;
      setState(() {
        imageStr = "${images.length + 1} attachments added successfully";
        imagepath = File(get.path);
        imageName = get.path.split('/').last;
        imageData = base64Encode(imagepath!.readAsBytesSync());
 
        var d = {'name': imageName, 'img_data': imageData,'img_size': imagepath?.lengthSync().toString()};
        images.add(d);
      });
       
    } 
    else {
      snackBar(context,'You can only add 10', const Color(0xFF8B0000));
    }
     _determinePosition();  
  }

  void pickFile() async {
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
            imageSize=m.size.toString();
            var d = {'name': imageName, 'img_data': imageData,'img_size':imageSize};
            images.add(d);
          });
        }
      }
    } catch (e) {
      e;
    }
     _determinePosition();
  }

  void submit() async {
    var assetTag = assetTagController.text;
    var remarks = remarkController.text;
    if (assetTag.isNotEmpty)
    {
      addImages(assetTag,remarks);
    } 
    else 
    {
      snackBar(context,'Fill Asset id', const Color(0xFF8B0000));
    }  
  }  
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
  void addImages(String assetTag ,String remarks) {
    int i;
    int k = 0;
 
     
    do {
      Map<String, dynamic> data;
      if (images.isNotEmpty) {
         EasyLoading.show(status: 'Submit...');
      submitBttnPressed = true;
    String name=images[k]['name'].toString();
    String subString;
    if(name.length>10)
    {
      subString='${assetTag}_${name.substring(name.length-10)}';
    }
    else
    {
      subString=name;
    }
         i = 0;
        data = {
          'asset_tag': assetTag,
          'name': subString,
          'location': locationController.text.toString(),
          'nearby_landmark': nearByController.text.toString(), 
          'latitude': currentposition.latitude.toString(),
          'longitude': currentposition.longitude.toString(),
          'img_data': images[k]['img_data'],
          'verified_on': timestamp(),
          'remarks': remarks,
          'user_index': indexId
        };
          String urlHead = 'http://192.168.1.108/dashboard/sf11/';

      String url = '${urlHead}insertDataForAssetVerification.php';

      http.post(Uri.parse(url), body: data).then((response) {
        if (response.body == response.body.split(':')[0]) {
          i++;
          if (i == images.length) {
            EasyLoading.dismiss();
            
        snackBar(context, 'Asset Verified', const Color(0xFF019031));
            Navigator.push(context,  
                MaterialPageRoute(builder: (context) => const HomePage()));
          }
        } else {
      snackBar(context,'Error', const Color(0xFF8B0000));
        }
      }).catchError((error) {
      snackBar(context,'Error', const Color(0xFF8B0000));
      });
      k++;
      } 
      else
      {
      snackBar(context,'Attach asset image', const Color(0xFF8B0000));

      }  
    } while (k < images.length);
  }

  @override
  void dispose() {
    super.dispose();
    assetTagFocusNode.dispose();
    assetIssueFocusNode.dispose();
    assetTagController.dispose();
    controller?.dispose();
    locationController.dispose();
    nearByController.dispose();
    remarkController.dispose();
    assetCoordinates.dispose();
  }

  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    node2 = FocusNode();
    node3 = FocusNode();
    node4 = FocusNode();
    getDataFromDB();
    
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
    locationController = TextEditingController();
    nearByController = TextEditingController();
    remarkController = TextEditingController();
    assetCoordinates = TextEditingController();
    
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
              CustomAppBar(txt: 'Asset Verification'),
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
                                FocusScope.of(context).requestFocus(node3),
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
                    
                    const Row(
                      children: [
                          CustomTitleText(
                        title: 'Attachments',
                        size: 18,
                        color: Color(0XFF282828)),
                          CustomTitleText(
                          title: '*',
                          size: 18,
                          color: Colors.red,
                        ),
                         
                      ],
                    ),
                    

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
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                               Text('+ ',style: TextStyle(
                                  fontSize: 20, color: Colors.white
                                ),),
                              Text('Add Attachments',style: TextStyle(
                                  fontSize: 16, color: Colors.white
                                ),),  
                              ],
                            )),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              getImage(ImageSource.camera);
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
                        height: (heigth! + (images.length * 40)),
                         
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
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                          child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTitleText(
                                title: 'Items(${ images.length})',
                                size: 16,
                                color: const Color(0XFF282828)),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                        
                                itemExtent: 40.0, 
                                itemCount: images.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin: const EdgeInsets.fromLTRB(8,8,0,0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.panorama_fisheye_outlined,
                                          color: Colors.black,
                                          size: 14,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                                images[index]['name'],
                                                overflow: TextOverflow.ellipsis, // This will add ellipsis (...) at the end if the text overflows.
                                                maxLines: 1, // You can adjust this to limit the number of lines.
                                                style: const TextStyle(fontSize: 14.0, color:   Color(0xFF282828),),
                                            ),
                                        ),
                                          Text(
                                               "${"(${(int.parse(images[index]['img_size'])/(1024 * 1024)).toString().substring(0,3)}" }MB)",
                                                      overflow: TextOverflow.ellipsis, // This will add ellipsis (...) at the end if the text overflows.
                                              maxLines: 1, // You can adjust this to limit the number of lines.
                                                style: const TextStyle(fontSize: 14.0, color:   Color(0xFF282828),),
                                            ),
                                             IconButton(
                                              onPressed: () {
                                                  setState(() {
                                                images.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                size: 24,
                                                color: Colors.red,
                                              ))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ), 
                    const SizedBox(
                      height: 16,
                    ),
                     const CustomTitleText(
                        title: 'Asset Current Coordinates',
                        size: 18,
                        color: Color(0XFF282828)),

                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: width,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: TextField(
                          readOnly: true,

                          decoration: InputDecoration(
                              hintText: "Latitude : ${currentposition.latitude.toString()} | Longitude : ${currentposition.longitude.toString()}",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none,
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
                        onSubmitted: () =>
                                FocusScope.of(context).requestFocus(node2),
                        keyboardType: TextInputType.streetAddress,
                        hintText: "Enter your nearby landmark...",
                        obscureText: false,
                        suffixWidget: const Text(''),
                        width: width!,
                        onPressed: () {}),

                    const SizedBox(
                      height: 16,
                    ),
                      const CustomTitleText(
                        title: 'Remarks',
                        size: 18,
                        color: Color(0XFF282828)),

                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        node1: node2!,
                        usernameController: remarkController,
                        onSubmitted: () {
                           
                        },
                        keyboardType: TextInputType.streetAddress,
                        hintText: "Any remarks you want to add...",
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
