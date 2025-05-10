import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spendly/pages/sms_permission.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  // google signin and signup
  // final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print("Login canceled by user.");
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Login error: ${e.toString()}");
      return null;
    }
  }



  // email and pass signup and sign in

  Future<bool> signup({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return true; //  signup succeeded
  } on FirebaseAuthException catch (e) {
    String message = '';
    if (e.code == 'weak-password') {
      message = "The password provided is too weak";
    } else if (e.code == 'email-already-in-use') {
      message = "Account already exists";
    } else {
      message = e.message ?? "Authentication error";
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
    return false; //  signup failed
  } catch (e) {
    Fluttertoast.showToast(
      msg: "An unexpected error occurred.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
    return false;
  }
}



  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SmsPermission()
          )
      );
    } on FirebaseAuthException catch(e){
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
    catch (e){

    }
  }
}