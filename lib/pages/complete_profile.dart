
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spendly/pages/set_budget.dart';

import 'package:spendly/services/userdata.dart';

class CompleteProfile extends StatelessWidget {
  // text controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _incomeController = TextEditingController();

  void dispose(){
    _nameController.dispose();
    _ageController.dispose();
    _incomeController.dispose();
  }
  // final String? email;
  final int? budget;
  CompleteProfile({this.budget});

  Future submitDetails() async{
    addUserDetails(_nameController.text.trim(),int.parse(_ageController.text.trim()),int.parse(_incomeController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff1a1f24),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D3B66), Color(0xFF041322)],
                    stops: [0, 1],
                    begin: AlignmentDirectional(0, -1),
                    end: AlignmentDirectional(0, 1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  "Complete Profile",
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 28,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ],
                            ),
                            
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: inputDecoration("Name"),
                                style: inputTextStyle(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: TextFormField(
                                controller: _ageController,
                                decoration: inputDecoration("Age"),
                                style: inputTextStyle(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: TextFormField(
                                controller: _incomeController,
                                decoration: inputDecoration("Income"),
                                style: inputTextStyle(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                              child: TextButton(
                                onPressed: () async{
                                  await submitDetails();
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => SetBudget(),
                                  
                                  ));}
                                ,
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xff00968a),
                                  fixedSize: Size(130, 50),
                                  elevation: 3,
                                ),
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    color: Color(0xffffffff),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Color(0xff8b97a2),
        fontFamily: 'Lexend',
        fontSize: 14,
      ),
      filled: true,
      fillColor: Color(0xff111417),
      contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  TextStyle inputTextStyle() {
    return TextStyle(
      fontFamily: 'Lexend',
      color: Color(0xffffffff),
    );
  }
}
