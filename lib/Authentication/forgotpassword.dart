import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Authentication/loginpage.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FocusNode? node1;
  FocusNode? node2;
  double? width;
  bool key = true;
  String? name;
    String? address ;
    String? mobileNum ;
    String? userName ;
    String? country ;
    String? userRole ;
    String? storeRoom ;
    String? companies;
  String? userEmail;
 
  bool isPasswordNotValidated = true;
  bool _obscureText = false;
  String? errorTextForPassword;
  TextEditingController? _passwordController;
  String? errorTextForConfirmPassword;
  TextEditingController? _confirmPasswordController;
  bool hasLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool hasDigit(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  bool hasSpecialChar(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  bool validate(userPassword) {
    if ((userPassword.length >= 8) &&
        hasUppercase(userPassword) &&
        hasLowercase(userPassword) &&
        hasDigit(userPassword) &&
        hasSpecialChar(userPassword)) {
      return true;
    } else {
      setState(() {
        isPasswordNotValidated = false;
      });
      return false;
    }
  }

  void _submit() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    String pass = _passwordController!.text;
    String conPass = _confirmPasswordController!.text;

    if (pass == conPass) {
      if (validate(pass)) {
        EasyLoading.show(status: 'Updating...');
        updateDetail();
      }
    } else {
      snackBar(
          context, 'Both password should be same', const Color(0xFF8B0000));
    }
  }

  void getDataFromDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userEmail = prefs.getString('user_email');
     name = prefs.getString('name');
     address = prefs.getString('address');
     mobileNum = prefs.getString('mobileNum');
     userName = prefs.getString('userName');
     country = prefs.getString('country');
     userRole = prefs.getString('userRole');
     storeRoom = prefs.getString('storeRoom');
     companies = prefs.getString('companies');
     
     
  }

  void updateDetail() async {
    if (_confirmPasswordController!.text.isNotEmpty &&
        _passwordController!.text.isNotEmpty) {
      const urlHead = 'http://192.168.1.108/dashboard/sf11/';
      const url = '${urlHead}UpdateDataForUser.php';
    
      var data = {
        'user_email': userEmail,
        'user_password': _passwordController!.text,
        'name': name,
        'address': address,
        'mobileNum': mobileNum,
        'userName': userName,
        'country': country,
        'userRole': userRole,
        'companies': companies,
        'storeRoom': storeRoom,
      };

      http.post(Uri.parse(url), body: data).then((response) {
        if (response.statusCode == 200) {
          // Data successfully addedprint
          EasyLoading.dismiss();
          EasyLoading.showToast("Updated Successfully",
              toastPosition: EasyLoadingToastPosition.top);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          // Error occurred
          EasyLoading.dismiss();
          EasyLoading.showToast("Error!1",
              toastPosition: EasyLoadingToastPosition.top);
        }
      }).catchError((error) {
        EasyLoading.dismiss();
        EasyLoading.showToast("Error!2",
            toastPosition: EasyLoadingToastPosition.top);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    node1 = FocusNode();
    node2 = FocusNode();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    getDataFromDB();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(txt: 'Create Password'),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTitleText(
                    title:
                        'This password should be different\nfrom the previous password',
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const CustomTitleText(
                    title: 'Password',
                    size: 18,
                    color: Color(0XFF282828),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    node1: node1!,
                    usernameController: _passwordController!,
                    onSubmitted: () =>
                        FocusScope.of(context).requestFocus(node2),
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Type your password...',
                    obscureText: _obscureText,
                    suffixWidget: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    width: width!,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const CustomTitleText(
                    title: 'Confirm Password',
                    size: 18,
                    color: Color(0XFF282828),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      node1: node2!,
                      usernameController: _confirmPasswordController!,
                      onSubmitted: () =>
                          FocusScope.of(context).requestFocus(node2),
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'Type your confirm password...',
                      obscureText: _obscureText,
                      suffixWidget: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      width: width!,
                      onPressed: () {}),
                  Offstage(
                    offstage: isPasswordNotValidated,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      padding: const EdgeInsets.all(10),
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(
                            10), // Radius for rounded corners
                        border: Border.all(
                          color: const Color(0xFF282828)
                              .withOpacity(0.25), // Light grey border color
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
                      child: const Column(children: [
                        Row(
                          children: [
                            Icon(
                              Icons.do_not_disturb_alt_outlined,
                              color: Colors.red,
                              size: 14,
                            ),
                            CustomTitleText(
                              title: 'Minimum 8 length',
                              size: 14,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.do_not_disturb_alt_outlined,
                                color: Colors.red, size: 14),
                            CustomTitleText(
                              title: 'Atleast 1 Upper Case Letter',
                              size: 14,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.do_not_disturb_alt_outlined,
                                color: Colors.red, size: 14),
                            CustomTitleText(
                              title: 'Atleast 1 Lower Case Letter',
                              size: 14,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.do_not_disturb_alt_outlined,
                                color: Colors.red, size: 14),
                            CustomTitleText(
                              title: 'Atleast 1 Special Character (@ , _ , /)',
                              size: 14,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.do_not_disturb_alt_outlined,
                                color: Colors.red, size: 14),
                            CustomTitleText(
                              title: 'Atleast 1 Numeric Character',
                              size: 14,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            CustomSubmitButton(onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
