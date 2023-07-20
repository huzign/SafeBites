// ignore_for_file: unused_field, unused_catch_clause

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safebites/Landing.dart';

class CongratulationsScreen extends StatefulWidget {
  CongratulationsScreen();

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  User? _user;
  String? _username;
  String? _useremail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = user;
      _username = user?.displayName;
      _useremail = user?.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    void logOutUser() async {
      try {
        await FirebaseAuth.instance.signOut().then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LandingScreen()));
        });
        // Navigate to the login screen or any other screen
        // after successful logout
      } on FirebaseAuthException catch (e) {
        const snackBar = SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_rounded, color: Colors.white),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
              Text('Error occured during sign out.'),
            ],
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
        );
        // Show the snackbar using the ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // Handle any error that occurred during logout
      }
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_vector.png"),
                fit: BoxFit.contain,
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
                        height: 500,
                        child: Image.asset(
                          'assets/images/waiting_vector.png',
                          fit: BoxFit.contain,
                        )),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Text(
                      'CONGRATULATIONS!',
                      style: TextStyle(
                          color: Color(0xff71429C),
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        "$_username, You're part of the beta tester program. Welcome onboard!",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xff71429C),
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    )),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: const Color(0xff71429C),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: logOutUser,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: Colors.white),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
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
