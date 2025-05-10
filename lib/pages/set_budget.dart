import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendly/pages/home_page.dart';

class SetBudget extends StatefulWidget {
  const SetBudget({super.key});

  @override
  State<SetBudget> createState() => _SetBudgetState();
}

int primaryTextColor = 0xffffffff;
int bodyMediumColor = 0xffffffff;
int accent2Color = 0xffe0e0e0;
int accent3Color = 0xff757575;
int secondaryTextColor = 0xff8b97a2;
int secondaryBackgroundColor = 0xff111417;

class _SetBudgetState extends State<SetBudget> {
  final TextEditingController _controller = TextEditingController();
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
                                        Icons.cookie_rounded,
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
                                                      "Create Budget",
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
                                              //

                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                                child: TextFormField(
                                                  controller: _controller,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelStyle: TextStyle(
                                                      fontFamily: "Lexend",
                                                      color: Colors.grey[300],
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 32
                                                    ),
                                                    hintText: "Amount",
                                                    hintStyle: TextStyle(
                                                      fontSize: 32,
                                                      fontFamily: "Lexend",
                                                      color: Colors.grey[700],
                                                      fontWeight: FontWeight.w300,
                                                      letterSpacing: 0,
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(accent3Color),
                                                        width: 2
                                                      ),
                                                      borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 0,
                                                      ),
                                                        borderRadius: BorderRadius.circular(8)
                                                    ),
                                                    errorBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 2,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    focusedErrorBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Color(0x00000000),
                                                        width: 2,
                                                      ),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 24, 24),
                                                    prefixIcon: Icon(
                                                      Icons.currency_rupee_rounded,
                                                      color: Color(primaryTextColor),
                                                      size: 32,
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Lexend',
                                                    letterSpacing: 0.0,
                                                    fontSize: 32,
                                                    color: Color(primaryTextColor)
                                                  ),
                                                  // textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number,
                                                )
                                              ),

                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if(_controller.text.isNotEmpty){
                                                      int setBudget = int.parse(_controller.text);
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => HomePage(),
                                                          settings: RouteSettings(arguments: {'budget':setBudget})
                                                        )
                                                      );
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Color(0xff00968a),
                                                    fixedSize: Size(180, 50),
                                                    elevation: 3,
                                                  ),
                                                  child: Text(
                                                    "Set Budget",
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
