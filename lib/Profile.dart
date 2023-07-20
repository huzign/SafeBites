// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Landing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  // ignore: unused_field
  User? _user;
  late String _username;
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
      _useremail = user?.email;
    });
    _username = _useremail!.replaceAll('@gmail.com', '').capitalizeFirst!;
  }

  logOutUser() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingScreen()));
      });
      // Navigate to the login screen or any other screen
      // after successful logout
      // ignore: unused_catch_clause
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 30),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
              const CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/user_profile.png'),
              ),
              const SizedBox(height: 30.0),
              Text(
                '$_username',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$_useremail',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Change Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => logOutUser()));
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Manrope',
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80.0),
              Text(
                'SafeBites Version: v1.5.0',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 0.0),
              Text(
                'Made with ❤️ by Huzaifa Ali.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
