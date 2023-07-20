import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:safebites/login_controller.dart';
import 'Signup.dart';

import 'main.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

    void logInUser() async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: controller.emailController.text.toString(),
                password: controller.passwordController.text.toString())
            .then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Navbar()));
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          const snackBar = SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                Text('No user found with this email.'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
          );
          // Show the snackbar using the ScaffoldMessenger
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'wrong-password') {
          const snackBar = SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_rounded, color: Colors.white),
                Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                Text('Incorrect Password. Please Try again!'),
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
          Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: SizedBox(
                        width: 350,
                        height: 300,
                        child: Image.asset(
                          'assets/images/login_vector.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Welcome to Safe Bites.',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontFamily: 'Manrope',
                          fontSize: 30),
                    )),
                const Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30),
                    child: Text(
                      'Please put your information below to sign in to your account.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontFamily: 'Manrope',
                          fontSize: 18),
                    )),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: controller.emailController,
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
                    controller: controller.passwordController,
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
                  child: TextButton(
                    onPressed: () {
                      //TODO FORGOT PASSWORD SCREEN GOES HERE
                    },
                    child: const Text('Forgot Password?',
                        style: TextStyle(
                            fontFamily: 'Manrope',
                            color: Colors.grey,
                            fontSize: 15)),
                  ),
                ),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: const Color(0xff71429C),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: logInUser,
                    child: const Text(
                      'Login',
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
                      Navigator.pushReplacement(context,
                          // ignore: prefer_const_constructors
                          MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: const Text(
                      'New to Safe Bites? Create an Account',
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
    );
  }
}
