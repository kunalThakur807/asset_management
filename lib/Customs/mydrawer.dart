import 'package:flutter/material.dart';
import 'package:untitled/Data/listmodel.dart';

class MyDrawer extends StatefulWidget {
  final double sizeOfDrawer;
  final List<ListObject> list;

  const MyDrawer({super.key, required this.sizeOfDrawer, required this.list});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  List<ListObject> l = [];

  @override
  void initState() {
    super.initState();
    // l=getData('INPUTER') as List<listObject>;
    l = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue.shade800,
        width: widget.sizeOfDrawer,
        child: ListView.builder(
          itemCount: l.length,
          itemBuilder: (BuildContext context, int index) {
            // Build your list item here based on the index
            return ListTile(
                title: Text(
                  l[index].getName()!,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => l[index].getWidget()!));
                });
          },
        ));
  }
}
