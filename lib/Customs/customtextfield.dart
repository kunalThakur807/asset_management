import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.node1,
      required this.width,
      required TextEditingController usernameController,
      required this.keyboardType,
      required this.hintText,
      required this.obscureText,
      required this.suffixWidget,
      required this.onSubmitted,
      required this.onPressed})
      : _usernameController = usernameController;

  final FocusNode node1;
  final TextEditingController _usernameController;

  final TextInputType keyboardType;
  final String hintText;
  final double width;
  final bool obscureText;
  final Widget suffixWidget;
  final VoidCallback onSubmitted;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
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
        onTap: onPressed,
        keyboardType: keyboardType,
        focusNode: node1,
        minLines: 1,
        maxLines: 5,
        obscureText: obscureText,
        controller: _usernameController,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: suffixWidget),
        onSubmitted: (v) {
          onSubmitted();
        },
      ),
    );
  }
}
