import 'package:flutter/material.dart';

class ListObject {
   String? name;

   Widget? widget;
  ListObject(String n, Widget w) {
     name = n;
    widget = w;
  }
  String? getName() => name;
  Widget? getWidget() => widget;
}
