import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  void registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('Email is not a valid format.');
      } else if (e.code == 'email-already-in-use') {
        print('Email already in use by another user! Register with another email.');
      } else if (e.code == 'weak-password') {
        print('Password is weak. Use a combination of upper case, lower case and special characters.');
      }
    }
  }
}
