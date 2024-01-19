import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/Customs/customtitletext.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  String? txt;

  CustomAppBar({super.key, @required this.txt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        color: Colors.black,
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/backbttn.svg',
                ),
                CustomTitleText(
                  title: txt,
                  size: 18,
                  color: const Color(0xFF282828),
                ),
                Container(),
                Container()
              ],
            )),
      ),
    );
  }
}
