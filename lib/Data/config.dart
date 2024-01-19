import 'package:flutter/material.dart';
import 'package:untitled/Guest/requestservice.dart';
import 'package:untitled/Permissions/addpermission.dart';

import '../Activities/createuser.dart';
import '../Activities/dashboard.dart';
 
import '../Permissions/permissions.dart';
import '../Activities/qrscanner.dart';
import '../Activities/reportwidget.dart';
String? userType;
Map<String, Widget> getWidgets={
  'DashBoard':DashBoard(userType: userType,),
  'QR Scanner': const QRScannerWidget(),
  'create user' : const CreateUser(),
  'permission' : const Permissions(),
  'report':const ReportWidget(),
  'add permission':const AddPermission(),
  'report an issue':const RequestService(isReportScreen: true,),
  'request for service':const RequestService(isReportScreen: false,),
  'track status':const RequestService(isReportScreen: false,),
};