import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Activities/Technician/technician_issues.dart';
 
import 'package:untitled/Activities/homePage.dart';
import 'package:untitled/Authentication/register.dart';
 
 
     
void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeActivity(),
      //  OTPScreen(),
      //  OTP(otp: '123456', hasForgotPassword: true,),
      builder: EasyLoading.init(),
    );
  }
}

class HomeActivity extends StatefulWidget {
  const HomeActivity({super.key});

  @override
  State<HomeActivity> createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  bool isNUll = false;
  Widget? w;
  String? userRole;
  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Replace 'key' with the key you used to save the data
    String? userType = prefs.getString(
        'user_type'); // Replace 'key' with the key you used to save the data
    // Replace 'key' with the key you used to save the data

    if (userType != null) {
      // Data exists, use it

      setState(() {
        isNUll = true;
        if(userType=='TECHNICIAN') {
          w=const TechnicianIssues();
        }
        else
        {
          w=const HomePage();
        }

        userRole = userType;

      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isNUll
        ?  w! 
        :   const Register();
  }
}
