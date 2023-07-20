// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreen createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
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
      _useremail = _user?.email;
      _username = _useremail!.replaceAll('@gmail.com', '').capitalizeFirst!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_vector3.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  const Text(
                    'Hi!',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF351454)),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Welcome to SafeBites.',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF351454)),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/report_vector.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 20.0),
                            child: const Text(
                              'Now introducing\nscan report.',
                              style: TextStyle(
                                  fontSize: 28.0,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff71429C)),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                  left: 20.0, bottom: 20.0),
                              child: const Text(
                                'Scan report is a detailed\nanalysis of the product.',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff71429C)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    'Best Practices',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF351454)),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Make sure the camera is clean.',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF351454)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.light_mode_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Flexible(
                        child: Text(
                          'Make sure the lights/flash is enough for clearer results.',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF351454)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xff71429C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.center_focus_strong_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Flexible(
                        child: Text(
                          'Make sure the camera is aligned and focused well on the ingredients part only.',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF351454)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
