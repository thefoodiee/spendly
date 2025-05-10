import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spendly/services/auth_service.dart';


class LoginAccount extends StatefulWidget {
  const LoginAccount({super.key});

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

int primaryTextColor = 0xffffffff;
int bodyMediumColor = 0xffffffff;
int accent3Color = 0xff757575;
int secondaryTextColor = 0xff8b97a2;
int secondaryBackgroundColor = 0xff111417;

class _LoginAccountState extends State<LoginAccount> {
  final _auth = AuthService();
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    passwordVisible = true;
  }

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
                              children: [
                                Text(
                                  "Welcome Back",
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 28,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Color(primaryTextColor),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Login to access your account below.",
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0,20,0,0),
                              child: TextFormField(
                                controller: _emailController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                    color: Color(secondaryTextColor),
                                    letterSpacing: 0,
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(secondaryBackgroundColor),
                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0,
                                  color: Color(primaryTextColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0,20,0,0),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: passwordVisible,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Color(secondaryTextColor),
                                    letterSpacing: 0,
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(secondaryBackgroundColor),
                                  contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: (){
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  alignLabelWithHint: false,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0x00000000),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                style: TextStyle(
                                  fontFamily: 'Lexend',
                                  letterSpacing: 0,
                                  color: Color(primaryTextColor),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 5),
                              child: TextButton(
                                onPressed: () async{
                                  await AuthService().signin(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff00968a),
                                  fixedSize: Size(120, 30),
                                  elevation: 3,

                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0,
                                      color: Color(primaryTextColor),
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                              child: TextButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false, // Prevents user from closing it manually
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[850],
                                        content: Row(
                                          children: [
                                            CircularProgressIndicator(color: Color(0xff00968a),),
                                            SizedBox(width: 20),
                                            Text("Signing in...", style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  // Perform login
                                  try {
                                    final user = await _auth.loginWithGoogle();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }

                                    if (user != null) {
                                      if (context.mounted) {
                                        final userEmail = user.user?.email ?? "Unknown";
                                        Navigator.pushReplacementNamed(context, '/smsPermission');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Logged in as $userEmail"))
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Login cancelled.")),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Login failed. Please try again.")),
                                      );
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff00968a),
                                  fixedSize: Size(170, 30),
                                  elevation: 3,

                                ),
                                child: Text(
                                  "Login with Google",
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0,
                                      color: Color(primaryTextColor),
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width * 0.8,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Color(0xff111417),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Lexend",
                                              color: Color(primaryTextColor),
                                              letterSpacing: 0
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 4, 0),
                                          child: TextButton.icon(
                                            onPressed: (){
                                              Navigator.pushReplacementNamed(context, '/createAccount');
                                            },
                                            iconAlignment: IconAlignment.end,
                                            label: Text(
                                              "Create",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Lexend',
                                                  color: Color(0xff00968a),
                                                  letterSpacing: 0
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Color(0xff00968a),
                                            ),
                                          ),
                                        )
                                      ],),
                                  )
                                ],),
                          ]),
                      )
                    )
                  ])
                )
            )
                ])
        )
    );
  }
}
