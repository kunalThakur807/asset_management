import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled/Customs/mydrawer.dart';
import 'package:untitled/Data/data.dart';
import 'package:untitled/Data/listmodel.dart';

class QRScannerWidget extends StatefulWidget {
  const QRScannerWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  Position? currentposition;
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? controller;
  String? result;
  bool openedDashboard = false;
  late List<ListObject> listObjects = [];

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      EasyLoading.showToast('Please enable Your Location Service',
          toastPosition: EasyLoadingToastPosition.bottom);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        EasyLoading.showToast(
          'Location permissions are denied',
          toastPosition: EasyLoadingToastPosition.bottom,
          dismissOnTap: true,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      EasyLoading.showToast(
        'Location permissions are permanently denied, we cannot request permissions.',
        toastPosition: EasyLoadingToastPosition.bottom,
        dismissOnTap: true,
      );
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      setState(() {
        currentposition = position;
      });
    } catch (e) {
      EasyLoading.showToast("Error!",
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  void fetchDataFromQR(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      Map<String, dynamic> jsonMap = jsonDecode(event.code.toString());

      var data = {
        'asset_tag': jsonMap['asset_tag'],
        'asset_latitude': currentposition!.latitude.toString(),
        'asset_altitude': currentposition!.altitude.toString()
      };
      setState(() {
        result = 'Data Inserted Sucessfully';
      });
      //Link for public url
      // // const url='https://hungry-butterfly-68378.pktriot.net/dashboard/sf11/insertData.php';
      String url = '${urlHead}insertDataIntoDb.php';

      http.post(Uri.parse(url), body: data).then((response) {
        if (response.statusCode == 200) {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  double sizeOfDrawer = 0.0;
  double size = 0.0;
  @override
  Widget build(BuildContext context) {
    double fullSize = MediaQuery.of(context).size.width;

    size = fullSize / 1.5;
    sizeOfDrawer = fullSize - size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.blue.shade900,
        leading: DrawerButton(
          onPressed: () {
            setState(() {
              if (listObjects.isEmpty) {
                listObjects = getList();
              }
              if (openedDashboard) {
                openedDashboard = false;
                controller?.resumeCamera();
              } else {
                openedDashboard = true;
                controller?.pauseCamera();
              }
            });
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          openedDashboard
              ? MyDrawer(
                  sizeOfDrawer: sizeOfDrawer,
                  list: listObjects,
                )
              : Container(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 400,
                  width: openedDashboard ? size : 400,
                  child: QRView(
                    key: _globalKey,
                    onQRViewCreated: fetchDataFromQR,
                  ),
                ),
                Center(
                  child: (result != null)
                      ? Text(
                          result!,
                          style: const TextStyle(fontSize: 20),
                        )
                      : const Text('Scan QR'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
