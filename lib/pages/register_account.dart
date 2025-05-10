import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendly/services/auth_service.dart';
import 'package:spendly/pages/complete_profile.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

int primaryTextColor = 0xffffffff;
int bodyMediumColor = 0xffffffff;
int accent3Color = 0xff757575;
int secondaryTextColor = 0xff8b97a2;
int secondaryBackgroundColor = 0xff111417;

class _RegisterAccountState extends State<RegisterAccount> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    confirmPasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness:
          Brightness.light, // White icons on the status bar
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
                    image: AssetImage('assets/images/createAccount_bg@2x.png'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Row on top of the image
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 50),
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
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 28,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.normal,
                                    color: Color(primaryTextColor),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Create your account below",
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0,
                                      fontSize: 18,
                                      color: Color(accent3Color),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 24, 20, 24),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 24, 20, 24),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: TextFormField(
                                obscureText: confirmPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Color(secondaryTextColor),
                                    letterSpacing: 0,
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                  ),
                                  filled: true,
                                  fillColor: Color(secondaryBackgroundColor),
                                  contentPadding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          20, 24, 20, 24),
                                  suffixIcon: IconButton(
                                    icon: Icon(confirmPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        confirmPasswordVisible =
                                            !confirmPasswordVisible;
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                              child: TextButton(
                                onPressed: () async {
                                  bool success = await AuthService().signup(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context);

                                  if (success) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CompleteProfile(),
                                      ),
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff00968a),
                                  fixedSize: Size(160, 50),
                                  elevation: 3,
                                ),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      letterSpacing: 0,
                                      color: Color(primaryTextColor),
                                      fontSize: 16),
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
                                      // Icon(
                                      //   Icons.arrow_back_rounded,
                                      //   color: Color(0xff00968a),
                                      // ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            4, 0, 24, 0),
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(context, '/');
                                          },
                                          label: Text(
                                            "Login",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Lexend',
                                                color: Color(0xff00968a),
                                                letterSpacing: 0),
                                          ),
                                          icon: Icon(
                                            Icons.arrow_back_rounded,
                                            color: Color(0xff00968a),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Lexend",
                                            color: Color(primaryTextColor),
                                            letterSpacing: 0),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // Add other widgets here if needed
                    Spacer(), // Pushes content to the bottom of the column
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
