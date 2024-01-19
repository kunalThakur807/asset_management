import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Authentication/LoginPage.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';
import 'package:untitled/Guest/GuestActivity.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
 
  double? width;
  
  Future<void> saveData(String email,String mob,String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
    prefs.setString('user_name', name);
    prefs.setString('user_mob', mob);
  }
  
  void bottomSheetForGuestDetails() {
    TextEditingController? userEmailController = TextEditingController(),
        userMobController = TextEditingController(),
        userNameController = TextEditingController();
    bool isKeyboardOpened = true;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (BuildContext context) {
          final node1 = FocusNode();
          final node2 = FocusNode();
          final node3 = FocusNode();
          if (isKeyboardOpened) {
            FocusScope.of(context).requestFocus(node1);
            isKeyboardOpened = false;
          }
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 450,
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const Center(
                      child: CustomTitleText(
                    title: 'Continue as Guest',
                    size: 24,
                    color: Color(0XFF282828),
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    children: [
                      CustomTitleText(
                        title: 'Email',
                        size: 18,
                        color: Color(0XFF282828),
                      ),
                      CustomTitleText(
                        title: '*',
                        size: 18,
                        color: Colors.red,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    node1: node1,
                    usernameController: userEmailController,
                    onSubmitted: () =>
                        FocusScope.of(context).requestFocus(node2),
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Type your email address...',
                    obscureText: false,
                    suffixWidget: const Text(''),
                    width: width!,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTitleText(
                    title: 'Name',
                    size: 18,
                    color: Color(0XFF282828),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      node1: node2,
                      usernameController: userNameController,
                      onSubmitted: () =>
                          FocusScope.of(context).requestFocus(node3),
                      keyboardType: TextInputType.name,
                      hintText: 'Type your name...',
                      obscureText: false,
                      suffixWidget: const Text(''),
                      width: width!,
                      onPressed: () {
                        // FocusScope.of(node3).unfocus();
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTitleText(
                    title: 'Mobile No.',
                    size: 18,
                    color: Color(0XFF282828),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                      node1: node3,
                      usernameController: userMobController,
                      onSubmitted: () {
                        String email = userEmailController.text;
                        String name=userNameController.text;
                        String mobileNum=userMobController.text;
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        submit(email,mobileNum,name);
                      },
                      keyboardType: TextInputType.name,
                      hintText: 'Type your mobile number...',
                      obscureText: false,
                      suffixWidget: const Text(''),
                      width: width!,
                      onPressed: () {}),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomSubmitButton(onPressed: () {
                    String email = userEmailController.text;
                    String name=userNameController.text;
                    String mobileNum=userMobController.text;
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    submit(email,mobileNum,name);
                  }),
                ],
              ),
            ),
          );
        });
  }

  void submit(String email,String mob,String name) {
    if (email.isNotEmpty && email.contains('@')) {
      saveData(email,mob,name);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GuestActivity()));
    } else {
      snackBar(context, 'Invalid email address', const Color(0xFF8B0000));
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
               constraints: const BoxConstraints.expand(),
                child: Image.asset(
                  'assets/bg_img.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                // Set constraints to match the screen size
                color: const Color(0XFF000000).withOpacity(0.50),
                constraints: const BoxConstraints.expand(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    const SizedBox(),
                    const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('i ',
                            style: GoogleFonts.yellowtail(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text('AssetMax',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    Text('Simplifying Asset Management',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                    Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              shadowColor:
                                  const Color(0XFF192A56), // Text color
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text('Sign in',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0XFF246EE9))),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: 200,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              backgroundColor: const Color(0XFF246EE9),
                              shadowColor:
                                  const Color(0XFF282828), // Text color
                            ),
                            onPressed: bottomSheetForGuestDetails,
                            child: const Center(
                              child: CustomTitleText(
                                  title: "Continue as Guest",
                                  size: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                          child: Opacity(
                              opacity: 0.6,
                              child: CustomTitleText(
                                  title: "Powered By : Aargus infotech",
                                  size: 12,
                                  color: Colors.white)),
                        )
                      ],
                    )
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
