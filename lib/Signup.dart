import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safebites/Login.dart';
import 'package:safebites/signup_controller.dart';

import 'main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  // Storing user data
  Future addUserData(String userName, String userEmail) async{
    await FirebaseFirestore.instance.collection('users').add({
      'name': userName,
      'email': userEmail,

    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = SignUpController();

    @override
    void registerUser() async {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: controller.email.text.toString(),
                password: controller.password.text.toString())
            .then((value){
          addUserData(
            controller.name.text.toString(),
            controller.email.text.toString(),
          );
        }).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Navbar()));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          const snackBar = SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                Text('Weak Password.'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          );
          // Show the snackbar using the ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'email-already-in-use') {
          const snackBar = SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                Text('This email is already in use.12345'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          );
          // Show the snackbar using the ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'invalid-email') {
          const snackBar = SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                Text('Invalid email format! Try again.'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          );
          // Show the snackbar using the ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_vector.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: SizedBox(
                            width: 250,
                            height: 300,
                            /*decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50.0)),*/
                            child: Image.asset(
                                'assets/images/signup_vector.png')),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Text(
                          'Create a new account',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontFamily: 'Manrope',
                              fontSize: 30),
                        )),
                    const Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 30),
                        child: Text(
                          'Please put your information below to create a new account.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontFamily: 'Manrope',
                              fontSize: 18),
                        )),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 0, bottom: 0),
                      child: TextField(
                        controller: controller.name,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                            labelText: 'Full Name',
                            hintText: 'Enter your full name'),
                      ),
                    ),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: TextField(
                        controller: controller.email,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter your email'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: controller.password,
                        obscureText: true,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.key),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: 'Enter your password'),
                      ),
                    ),
                    Container(
                      alignment: const Alignment(1, 0),
                      padding: const EdgeInsets.all(15.0),
                    ),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: registerUser,
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => LoginScreen()));
                        },
                        child: const Text(
                          'Already a user? Log In',
                          style: TextStyle(
                            color: Color(0xff71429C),
                            fontSize: 16,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
