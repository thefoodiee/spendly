import 'package:cloud_firestore/cloud_firestore.dart';

Future addUserDetails(String name, int age, int income) async{
    await FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'age':age,
      'income':income,
      
    });
  }