import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Guest/RequestService.dart';
import 'package:untitled/HelpDesk/Issues/IssueDetail.dart';

class GuestActivity extends StatefulWidget {
  const GuestActivity({super.key});
  @override
  State<GuestActivity> createState() => _GuestActivityState();
}

class _GuestActivityState extends State<GuestActivity> {
  double? width;

  void bottomSheetForGuestDetails() {
    TextEditingController? userEmailController = TextEditingController();
    bool key = true;
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
            child: Container(
              height: 200,
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const CustomTitleText(
                    size: 24,
                    title: 'Track Status',
                    color: Color(0xFF282828),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                      node1: node,
                      usernameController: userEmailController,
                      onSubmitted: () {
                        submit(userEmailController.text);
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter Refrenece Number...',
                      obscureText: false,
                      suffixWidget: const Text(''),
                      width: 275,
                      onPressed: () {}),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomSubmitButton(onPressed: () {
                    submit(userEmailController.text);
                  })
                ],
              ),
            ),
          );
        });
  }

  void submit(email) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (email.isEmpty) {
      EasyLoading.showToast('Type Reference no.');
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IssueDetail(
                    ticketNo: email,
                  )));
    }
  }

   

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(txt: ''),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('  i ',
                      style: GoogleFonts.yellowtail(
                        textStyle: const TextStyle(
                            color: Color(0xFF282828),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      )),
                  Text('AssetMax',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Color(0xFF282828),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height / 2,
                child: GridView.count(
                  crossAxisCount: 2, // Number of columns
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestService(
                                      isReportScreen: true,
                                    )));
                      },
                      child: Card(
                          color: const Color(0XFF151b54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/report_issue.svg',
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const CustomTitleText(
                                  title: 'Report an Issue',
                                  size: 16,
                                  color: Colors.white)
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestService(
                                      isReportScreen: false,
                                    )));
                      },
                      child: Card(
                          color: const Color(0XFF151b54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/request_service.svg',
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const CustomTitleText(
                                  title: 'Request for Service',
                                  size: 16,
                                  color: Colors.white)
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        bottomSheetForGuestDetails();
                      },
                      child: Card(
                          color: const Color(0XFF151b54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/track_status.svg',
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const CustomTitleText(
                                  title: 'Track Status',
                                  size: 16,
                                  color: Colors.white)
                            ],
                          )),
                    ),
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
