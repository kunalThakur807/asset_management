import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Activities/OTP.dart';
import 'package:untitled/Activities/Technician/technician_issues.dart';
import 'package:untitled/Activities/homepage.dart';
import 'package:untitled/Authentication/registereduserform.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';
 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? otp;
  double? width;
  final node1 = FocusNode();
  final node2 = FocusNode();
  bool isKeyboardOpened = true;
  bool obscureText = false;
  String generateOTP() {
    // Generate a random 6-digit OTP
    Random random = Random();
    int min = 1000; // Minimum OTP value
    int max = 9999; // Maximum OTP value
    int otp = min + random.nextInt(max - min);

    return otp.toString();
  }

  void sendMailForApproval(String email, bool hasForgotPassword) async {
    EasyLoading.show(status: "Sending Mail...");
    otp = generateOTP();

    String adminEmail = 'kunal8076142807@gmail.com';
    String password = 'gpub qrlt qjrr pkky';

    final smtpServer = gmail(adminEmail, password);
    final sms =
        '<!DOCTYPE html> <html> <head> <style> a{    color: white; text-decoration: none; }         body {             font-family: Arial, sans-serif;             text-align: center;         }         .container {             margin: 10px auto;             padding: 20px;             border: 1px solid #ccc;             border-radius: 5px;             max-width: 300px;         }         h1 {             font-size: 24px;         }         .button-container {             margin-top: 20px;         }         .button {             display: inline-block;             padding: 10px 20px;             margin: 0 10px;             border: none;             border-radius: 5px;             cursor: pointer;             font-size: 16px;         }         .confirm-button {             background-color: #4CAF50;             color: white;         }         .deny-button {             background-color: #FF5733;             color: white;         }     </style>  </head> <body>     <div class="container">         <h1>Four Digit OTP</h1>         <p>$otp</p>            <div class="button-container">             <a href="myflutterapp://" class="button confirm-button"> Open in App </a>    </div>     </div> </body> </html>  ';

    final message = Message()
      ..from = Address(adminEmail, adminEmail)
      ..recipients.add(email)
      ..subject = 'One Time Password'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = sms;

    try {
      send(message, smtpServer);

      EasyLoading.dismiss();
      snackBar(context, 'Message sent successfully', const Color(0xFF019031));

      // EasyLoading.showToast( sendReport.toString(),toastPosition: EasyLoadingToastPosition.top);
      sendRoute();
    } on MailerException catch (e) {
      e;
      EasyLoading.dismiss();
      snackBar(context, 'Message not sent', const Color(0xFF8B0000));

      // EasyLoading.showToast( 'Message not sent. ${e.message}',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  void sendRoute() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  otp: otp,
                  hasForgotPassword: true,
                )));
  }

  String? errorTextForEmail;
  Future<void> saveDataForForgotPassword(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user_email', email);
  }

  void _submit(context, TextEditingController usernameController,
      bool hasForgotPassword) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (usernameController.text.isNotEmpty &&
        usernameController.text.contains('@gmail.com')) {
      Navigator.of(context).pop();
      saveDataForForgotPassword(usernameController.text);
      sendMailForApproval(usernameController.text, hasForgotPassword);
    } else {
      snackBar(context, 'Invalid email address', const Color(0xFF8B0000));
    }
  }

  void bottomUp(bool hasForgotPassword) {
    bool key = true;
    TextEditingController usernameController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (BuildContext context) {
          final node = FocusNode();
          if (key) {
            FocusScope.of(context).requestFocus(node);
            key = false;
          }

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  height: 225,
                  margin: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      const Center(
                          child: CustomTitleText(
                        title: 'Forgot Password',
                        size: 24,
                        color: Color(0xFF282828),
                      )),
                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                        title: 'Email',
                        size: 18,
                        color: Color(0xFF282828),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: node,
                          usernameController: usernameController,
                          onSubmitted: () => _submit(
                              context, usernameController, hasForgotPassword),
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Type your email...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomSubmitButton(onPressed: () {
                        _submit(context, usernameController, hasForgotPassword);
                      })
                    ],
                  ),
                )),
          );
        });
  }
  
  Future<void> saveData(String email, String userType,int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
    prefs.setString('user_type', userType);
    prefs.setString('id', id.toString());
  }

  void getData(String userName, String userPassword) async {
    String url = 'http://192.168.1.108/dashboard/sf11/authentication_data.php';
    _usernameController.text = '';
    _passwordController.text = '';
    var data = {'user_email': userName, 'user_password': userPassword};

    http.post(Uri.parse(url), body: data).then((response) {
      if (response.statusCode == 200) {
        // Data successfully added

        if (response.body.length <= 2) {
          EasyLoading.dismiss();

          snackBar(context, 'Access Denied', const Color(0xFF8B0000));
        } else {
          EasyLoading.dismiss();
          final data = json.decode(response.body);
          Map d = data[0];
          Widget? w;
          if (d['granted'] == 'confirm') {
            //  getDataFromDB(context);
            saveData(d['user_email'], d['user_type'],d['id']);
             if(d['user_type']=='TECHNICIAN') {
                w=const TechnicianIssues();
              }   
              else
              {
                w=const HomePage();
              }
           Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => w!,
                  ),
                );
          } else {
            snackBar(
                context, "You don't have the grant", const Color(0xFF8B0000));
          }
        }
      } else {
        // Error occurred
        snackBar(context, "Error!", const Color(0xFF8B0000));
      }
    }).catchError((error) {
      snackBar(context, "Error!", const Color(0xFF8B0000));
    });
  }

  void _login(context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (_usernameController.text.isEmpty) {
      snackBar(context, 'Empty email field', const Color(0xFF8B0000));
    }
    if (_passwordController.text.isEmpty) {
      snackBar(context, 'Empty password field', const Color(0xFF8B0000));
    } else if (!_usernameController.text.contains('@')) {
      snackBar(context, 'Invalid email address', const Color(0xFF8B0000));
    } else {
      EasyLoading.show(status: 'loading...');

      getData(_usernameController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    if (isKeyboardOpened) {
      FocusScope.of(context).requestFocus(node1);
      isKeyboardOpened = false;
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0XFF151b54),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 24,
                          ),
                          const CustomTitleText(
                            title: 'Email',
                            size: 18,
                            color: Color(0xFF282828),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              node1: node1,
                              usernameController: _usernameController,
                              onSubmitted: () =>
                                  FocusScope.of(context).requestFocus(node2),
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Type your email...',
                              obscureText: false,
                              suffixWidget: const Text(''),
                              width: width!,
                              onPressed: () {}),
                          const SizedBox(
                            height: 16,
                          ),
                          const CustomTitleText(
                            title: 'Password',
                            size: 18,
                            color: Color(0xFF282828),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              node1: node2,
                              usernameController: _passwordController,
                              onSubmitted: () {
                                _login(context);
                              },
                              keyboardType: TextInputType.visiblePassword,
                              hintText: 'Type your password...',
                              obscureText: obscureText,
                              suffixWidget: IconButton(
                                icon: Icon(obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              ),
                              width: width!,
                              onPressed: () {}),
                          const SizedBox(
                            height: 24,
                          ),
                          CustomSubmitButton(onPressed: () {
                            _login(context);
                          }),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisteredUserForm()));
                                  },
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF246EE9), // Text color
                                      // Add underline for a link-like appearance
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                bottomUp(true);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF246EE9), // Text color
                                    // Add underline for a link-like appearance
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

 
