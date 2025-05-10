import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spendly/pages/complete_profile.dart';
// import 'package:spendly/pages/set_budget.dart';

class SmsPermission extends StatefulWidget {
  // final String? email;
  const SmsPermission({super.key});

  @override
  State<SmsPermission> createState() => _SmsPermissionState();
}

int primaryTextColor = 0xffffffff;
int bodyMediumColor = 0xffffffff;
int accent2Color = 0xffe0e0e0;
int accent3Color = 0xff757575;
int secondaryTextColor = 0xff8b97a2;
int secondaryBackgroundColor = 0xff111417;

class _SmsPermissionState extends State<SmsPermission> {
  String? email;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness: Brightness.light, // White icons on the status bar

    ));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff1a1f24),
        body: SafeArea(
            top: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container with gradient and overlaying Row
                  Expanded(
                      child: Container(
                          width: double.infinity, // Full width of the screen
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF0D3B66), Color(0xFF041322)],
                              stops: [0, 1],
                              begin: AlignmentDirectional(0, -1),
                              end: AlignmentDirectional(0, 1),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: Alignment.bottomCenter,
                              image: AssetImage('assets/images/login_bg@2x.png'),
                            ),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0,40,0,50),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.currency_rupee_rounded,
                                        color: Color(primaryTextColor),
                                        size: 24,
                                      ),
                                      Text(
                                        "Spendly",
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontSize: 28,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(bodyMediumColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:EdgeInsetsDirectional.fromSTEB(0,0,0,50),
                                                  child: Text(
                                                    "Allow SMS Permission",
                                                    style: TextStyle(
                                                      fontFamily: 'Lexend',
                                                      fontSize: 28,
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Color(primaryTextColor),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Allow SMS permission to automatically track and categorize your expenses!",
                                                    style: TextStyle(
                                                      fontFamily: 'Lexend',
                                                      color: Color(accent2Color),
                                                      fontSize: 17,
                                                      letterSpacing: 0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                              child: TextButton(
                                                onPressed: () async {
                                                  await handleSmsPermission(context, email);

                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Color(0xff00968a),
                                                  fixedSize: Size(185, 50),
                                                  elevation: 3,
                                                ),
                                                child: Text(
                                                  "Allow Permission",
                                                  style: TextStyle(
                                                    fontFamily: 'Lexend',
                                                    letterSpacing: 0,
                                                    color: Color(primaryTextColor),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ])
                                )
                                )])
                      )
                  )
                ])
        )
    );
  }
}

Future<void> handleSmsPermission(context, email) async {
  PermissionStatus smsStatus = await Permission.sms.request();

  if (smsStatus == PermissionStatus.granted) {
    print("SMS permission granted");
    Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => CompleteProfile(),
                                  
                                  ));
  } else if (smsStatus == PermissionStatus.denied) {
    print("SMS permission denied");
  } else if (smsStatus == PermissionStatus.permanentlyDenied) {
    print("SMS permission permanently denied. Opening settings...");
    await openAppSettings();
  }
}
