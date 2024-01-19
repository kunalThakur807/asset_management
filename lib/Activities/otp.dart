import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/Authentication/forgotpassword.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/snackbar.dart';

@immutable
class OTP extends StatefulWidget {
  final String? otp;
  final bool? hasForgotPassword;
  const OTP({super.key, required this.otp, required this.hasForgotPassword});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }

  String? errorTextForOTP;

  @override
  void initState() {
    super.initState();
  }

  void _login(context) {
    StringBuffer str = StringBuffer();
    for (var controller in _controllers) {
      str.write(controller.text);
    }
    String s = str.toString();

    if (s.isNotEmpty) {
      if (widget.otp == s) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ForgotPassword()));
      } else {
        snackBar(context, 'Invalid OTP', const Color(0xFF8B0000));
      }
    } else {
      snackBar(context, 'Empty OTP', const Color(0xFF8B0000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppBar(txt: 'Verify Email'),
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset('assets/otp.svg', semanticsLabel: 'Acme Logo'),
            const SizedBox(
              height: 10,
            ),
            Text(
              'OTP has been sent',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
            ),
            Text(
              'on your email',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Enter 4 DIGIT OTP',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: SizedBox(
                    width: 50.0,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) => _onTextChanged(index, value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      focusNode: _focusNodes[index],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't recieve the OTP?",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(
                  width: 8,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      // Add your button's functionality here
                    },
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Text color
                        // Add underline for a link-like appearance
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomSubmitButton(
              onPressed: () {
                _login(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
