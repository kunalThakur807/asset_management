import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Activities/OTP.dart';
import 'package:untitled/Customs/customappbar.dart';
import 'package:untitled/Customs/customsubmitbutton.dart';
import 'package:untitled/Customs/customtextfield.dart';
import 'package:untitled/Customs/customtitletext.dart';
import 'package:untitled/Customs/snackbar.dart';
import 'package:untitled/Data/data.dart';
import 'package:untitled/Data/listModel.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class RegisteredUserForm extends StatefulWidget {
  const RegisteredUserForm({super.key});

  @override
  State<RegisteredUserForm> createState() => _RegisteredUserFormState();
}

class _RegisteredUserFormState extends State<RegisteredUserForm> {
  bool isClicked = true;
  late TextEditingController firstNameController,
      lastNameController,
       
      usernameController,
      addressController,
      mobileNumController,
      emailController,
      countryController;
  late FocusNode firstNameNode,
      lastNameNode,
      passwordNode,
      usernameNode,
      addressNode,
      mobileNumNode,
      emailNode;
  double? width;
  String urlHead = 'http://192.168.1.108/dashboard/sf11/';
  bool isClickedOnBox = true;
  List<String> selectCompany = ['Company 1', 'Company 2', 'Company 3'];
  List<String> selectUserType = ['INPUTER', 'APPROVER', 'TECHNICIAN'];
  String? selectedUserType = 'INPUTER';
  List<String> selectStoreRoom = [
    'Store room 1',
    'Store room 2',
    'Store room 3'
  ];
  String? selectedStoreRoom = 'Store room 1';
  double sizeOfDrawer = 0.0;
  List<String> countriesList = [];
  String? otp;
  double size = 0.0;
  late List<ListObject> listObjects = [];
  late List<String> l;
  bool openedDashboard = false;
  bool isKeyboardOpened = true;
  @override
  void initState() {
    super.initState();
    l = [];
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
   
    usernameController = TextEditingController();
    addressController = TextEditingController();
    mobileNumController = TextEditingController();
    emailController = TextEditingController();
    countryController = TextEditingController();
    firstNameNode = FocusNode();
    lastNameNode = FocusNode();
    passwordNode = FocusNode();
    usernameNode = FocusNode();
    addressNode = FocusNode();
    mobileNumNode = FocusNode();
    emailNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
   
    usernameController.dispose();
    addressController.dispose();
    mobileNumController.dispose();
    emailController.dispose();
    countryController.dispose();
  }

  String generateOTP() {
    // Generate a random 6-digit OTP
    Random random = Random();
    int min = 1000; // Minimum OTP value
    int max = 9999; // Maximum OTP value
    int otp = min + random.nextInt(max - min);

    return otp.toString();
  }

  void sendMailForOTP(String email, bool hasForgotPassword) async {
    if (email.isNotEmpty) {
      // setState(() {
      //   isClicked=false;
      // });
      EasyLoading.show(status: "Sending Mail...");
      otp = generateOTP();

      //  String encryptedData= encryptData(userEmail2!);

      String adminEmail = 'kunal8076142807@gmail.com';
      String password = 'gbvm zwkm asvn dhfz';

      final smtpServer = gmail(adminEmail, password);
      final sms =
          '<!DOCTYPE html> <html> <head> <style> a{    color: white; text-decoration: none; }         body {             font-family: Arial, sans-serif;             text-align: center;         }         .container {             margin: 10px auto;             padding: 20px;             border: 1px solid #ccc;             border-radius: 5px;             max-width: 300px;         }         h1 {             font-size: 24px;         }         .button-container {             margin-top: 20px;         }         .button {             display: inline-block;             padding: 10px 20px;             margin: 0 10px;             border: none;             border-radius: 5px;             cursor: pointer;             font-size: 16px;         }         .confirm-button {             background-color: #4CAF50;             color: white;         }         .deny-button {             background-color: #FF5733;             color: white;         }     </style>  </head> <body>     <div class="container">         <h1>Four Digit OTP</h1>         <p>$otp</p>            <div class="button-container">             <a href="myflutterapp://" class="button confirm-button"> Open in App </a>    </div>     </div> </body> </html>  ';
      // Create our message.
      final message = Message()
        ..from = Address(adminEmail, adminEmail)
        ..recipients.add(email)
        // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        // ..bccRecipients.add(Address('bccAddress@example.com'))
        ..subject = 'One Time Password'
        ..text = 'This is the plain text.\nThis is line 2 of the text part.'
        ..html = sms;

      try {
        final sendReport = await send(message, smtpServer);
        EasyLoading.dismiss();
        EasyLoading.showToast(sendReport.toString(),
            toastPosition: EasyLoadingToastPosition.top);
      } on MailerException catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showToast('Message not sent. ${e.message}',
            toastPosition: EasyLoadingToastPosition.top);
      }
    } else {
      EasyLoading.showToast('Fill All The Details',
          toastPosition: EasyLoadingToastPosition.top);
    }
  }

  addDynamic(String s) {
    setState(() {
      l.add(s);
    });
  }

  void removeDropdownItem(String itemToRemove) {
    setState(() {
      selectCompany.remove(itemToRemove);
    });
  }

  tap(String s) {
    addDynamic(s);

    removeDropdownItem(s);
    setState(() {
      isClickedOnBox = false;
    });
  }

  String encryptData(String txt) {
    StringBuffer str = StringBuffer();
    for (var i = 0; i < txt.length; i++) {
      int charCode = txt.codeUnitAt(i);
      String char = String.fromCharCode(charCode + 3);
      str.write(char);
    }
    return str.toString();
  }

  String decryptData(String txt) {
    StringBuffer str = StringBuffer();
    for (var i = 0; i < txt.length; i++) {
      int charCode = txt.codeUnitAt(i);
      String char = String.fromCharCode(charCode - 3);
      str.write(char);
    }
    return str.toString();
  }

  Future<void> saveDataForForgotPassword(firstName, lastName, address, mobileNum, userName, email,
           country, userRole, storeRoom, companies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String company = companies.join(',');
    prefs.setString('user_email', email);
    prefs.setString('name', firstName+' '+lastName);
    prefs.setString('address', address);
    prefs.setString('mobileNum', mobileNum);
    prefs.setString('userName', userName);
    prefs.setString('country', country);
    prefs.setString('userRole', userRole);
    prefs.setString('storeRoom', storeRoom);
    prefs.setString('companies', company);
   
  }

  String hidePassword(String password) {
    // Calculate the length of the password and create a string of asterisks of the same length
    String hiddenPassword = '*' * password.length;
    return hiddenPassword;
  }

  void sendMailForApproval(
      context,
      String firstName,
      String lastName,
      String address,
      String mobileNum,
      String userName,
      String email,
  
      String country,
      String userRole,
      String storeRoom,
      List<String> companies) async {
    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        address.isNotEmpty &&
        mobileNum.isNotEmpty &&
        userName.isNotEmpty &&
        email.isNotEmpty &&
        country.isNotEmpty) {
      if (!email.contains('@')) {
        snackBar(context, 'Invalid Email', const Color(0xFF8B0000));
      }
      if (mobileNum.length < 10) {
        snackBar(context, 'Invalid Mobile Number', const Color(0xFF8B0000));
      } else {
        setState(() {
          isClicked = false;
        });
        saveDataForForgotPassword(firstName, lastName, address, mobileNum, userName, email,
              country, userRole, storeRoom, companies);
        sendMailForOTP(email, true);
        sendMail(firstName, lastName, address, mobileNum, userName, email,
             country, userRole, storeRoom, companies);
      }
    } else {
      snackBar(context, 'Fill All The Details', const Color(0xFF8B0000));
    }
  }

  Future<void> sendMail(
      String firstName,
      String lastName,
      String address,
      String mobileNum,
      String userName,
      String email,
      String country,
      String userRole,
      String storeRoom,
      List<String> companies) async {
    EasyLoading.show(status: "Loading...");
    String encryptedData = encryptData(email);
    String adminEmail = 'kunal8076142807@gmail.com';
    String password = 'gbvm zwkm asvn dhfz';
 
    String company = companies.join(',');
    final smtpServer = gmail(adminEmail, password);
    final sms =
        '<!DOCTYPE html> <html> <head> <style> a{    color: white; text-decoration: none; }         body {             font-family: Arial, sans-serif;             text-align: center;         }         .container {             margin: 10px auto;             padding: 20px;             border: 1px solid #ccc;             border-radius: 5px;             max-width: 300px;         }         h1 {             font-size: 24px;         }         .button-container {             margin-top: 20px;         }         .button {             display: inline-block;             padding: 10px 20px;             margin: 0 10px;             border: none;             border-radius: 5px;             cursor: pointer;             font-size: 16px;         }         .confirm-button {             background-color: #4CAF50;             color: white;         }         .deny-button {             background-color: #FF5733;             color: white;         }     </style>  </head> <body>     <div class="container">         <h1>Permission Request Details</h1>       <p><strong>First Name: </strong> $firstName</p>       <p><strong>Last Name: </strong> $lastName</p>       <p><strong>Address: </strong>$address</p>       <p><strong>Mobile Number: </strong>$mobileNum</p>       <p><strong>Email ID: </strong>$email</p>       <p><strong>Username: </strong> $userName</p>       <p><strong>Password: </strong> </p>       <p><strong>Name of the Company: </strong>$company</p>       <p><strong>Name of the Storeroom: </strong>$storeRoom</p>       <p><strong>Country: </strong>$country</p>         <p><strong>User Role: </strong> $userRole</p>         <h1>Do you grant permission?</h1>         <div class="button-container">             <a href="http://192.168.1.108/dashboard/sf11/mail_authentication_data.php?id=$encryptedData&permission=confirm" class="button confirm-button"> Approve </a>             <a href="http://192.168.1.108/dashboard/sf11/mail_authentication_data.php?id=$encryptedData&permission=reject"   class="button deny-button"> Deny </a>                      </div>     </div> </body> </html>  ';
    // Create our message.
    final message = Message()
      ..from = Address(email, email)
      ..recipients.add(adminEmail)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Request For Permission'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = sms;

    try {
      final sendReport = await send(message, smtpServer);
      EasyLoading.dismiss();
      EasyLoading.showToast(sendReport.toString(),
          toastPosition: EasyLoadingToastPosition.top);
      callRoute();
    } on MailerException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Message not sent. ${e.message}',
          toastPosition: EasyLoadingToastPosition.top);
    }
  }

  void callRoute() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OTP(
                  otp: otp,
                  hasForgotPassword: true,
                )));
  }

  List<String> getCountriesList(String v) {
    List<String> list = [];
    for (String s in countries) {
      if (s.startsWith(v)) {
        list.add(s);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (isKeyboardOpened) {
      FocusScope.of(context).requestFocus(firstNameNode);
      isKeyboardOpened = false;
    }
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomAppBar(txt: 'Registration'),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'First Name',
                          size: 18,
                          color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: firstNameNode,
                          usernameController: firstNameController,
                          onSubmitted: () =>
                              FocusScope.of(context).requestFocus(lastNameNode),
                          keyboardType: TextInputType.name,
                          hintText: 'Type your first name...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),

                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'Last Name',
                          size: 18,
                          color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: lastNameNode,
                          usernameController: lastNameController,
                          onSubmitted: () =>
                              FocusScope.of(context).requestFocus(addressNode),
                          keyboardType: TextInputType.name,
                          hintText: 'Type your first name...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),

                      const SizedBox(
                        height: 16,
                      ),

                      const CustomTitleText(
                          title: 'Address', size: 18, color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: addressNode,
                          usernameController: addressController,
                          onSubmitted: () => FocusScope.of(context)
                              .requestFocus(mobileNumNode),
                          keyboardType: TextInputType.streetAddress,
                          hintText: 'Type your address...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),

                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'Mobile number',
                          size: 18,
                          color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: mobileNumNode,
                          usernameController: mobileNumController,
                          onSubmitted: () =>
                              FocusScope.of(context).requestFocus(emailNode),
                          keyboardType: TextInputType.number,
                          hintText: 'Type your mobile number...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),

                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'Email', size: 18, color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: emailNode,
                          usernameController: emailController,
                          onSubmitted: () =>
                              FocusScope.of(context).requestFocus(usernameNode),
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
                        title: 'Username',
                        size: 18,
                        color: Color(0xFF282828),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          node1: usernameNode,
                          usernameController: usernameController,
                          onSubmitted: () {},
                          keyboardType: TextInputType.name,
                          hintText: 'Type your username...',
                          obscureText: false,
                          suffixWidget: const Text(''),
                          width: width!,
                          onPressed: () {}),
                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'User Type',
                          size: 18,
                          color: Color(0xFF282828)),

                      const SizedBox(height: 10),
                      // Your content goes here

                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedUserType,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedUserType = newValue!;
                              });
                            },
                            items: selectUserType.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language,
                                    style: const TextStyle(fontSize: 18)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                          title: 'Country', size: 18, color: Color(0xFF282828)),

                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isClickedOnBox = true;
                          });
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                    onChanged: (value) {
                                      setState(() {
                                        countriesList = getCountriesList(value);
                                      });
                                    },
                                    controller: countryController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  color: Colors.white,
                                  margin: const EdgeInsets.all(5),
                                  // Fixed height for the vertical list
                                  height: countriesList.isNotEmpty ? 150 : 0,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) {
                                        return ListTile(
                                          title: Text(countriesList[index]),
                                          onTap: () {
                                            setState(() {
                                              countryController.text =
                                                  countriesList[index];
                                              countriesList = [];
                                            });
                                          },
                                        );
                                      },
                                      itemCount: countriesList.length)),
                            ],
                          ),
                        ),
                      ),

                      const CustomTitleText(
                          title: 'Company', size: 18, color: Color(0xFF282828)),

                      const SizedBox(
                        height: 10,
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isClickedOnBox) {
                              isClickedOnBox = true;
                            } else {
                              isClickedOnBox = false;
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue[900]),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' ${l[index]} ',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  selectCompany.add(l[index]);

                                                  l.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: l.length,
                                ),
                              ),
                              Offstage(
                                offstage: isClickedOnBox,
                                child: SizedBox(
                                    // Fixed height for the vertical list
                                    height: 100,
                                    child: ListView.builder(
                                        itemBuilder: (_, index) {
                                          return ListTile(
                                            title: Text(selectCompany[index]),
                                            onTap: () {
                                              tap(selectCompany[index]);
                                            },
                                          );
                                        },
                                        itemCount: selectCompany.length)),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),
                      const CustomTitleText(
                        title: 'Store Room',
                        size: 18,
                        color: Color(0xFF282828),
                      ),

                      const SizedBox(height: 10),
                      // Your content goes here
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10))
                            ]),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStoreRoom,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStoreRoom = newValue!;
                              });
                            },
                            items: selectStoreRoom.map((String language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language,
                                    style: const TextStyle(fontSize: 18)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomSubmitButton(onPressed: () {
                  isClicked
                      ? sendMailForApproval(
                          context,
                          firstNameController.text,
                          lastNameController.text,
                          addressController.text,
                          mobileNumController.text,
                          usernameController.text,
                          emailController.text,
                      
                          countryController.text,
                          selectedUserType!,
                          selectedStoreRoom!,
                          l)
                      : () {};
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
