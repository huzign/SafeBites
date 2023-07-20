import 'package:flutter/material.dart';
import 'package:safebites/Login.dart';

import 'Signup.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreen createState() => _LandingScreen();
}

class _LandingScreen extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                          'assets/images/landing_vector.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Text(
                      'Welcome to Safe Bites.',
                      style: TextStyle(
                          color: Color(0xff71429C),
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                const Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Center(
                      child: Text(
                        'Safe Bites help you in eating healthier and safer so you can decide faster in a product aisle.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: const Text(
                      'Create an account',
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    child: const Text(
                      'Already have an account? Sign In.',
                      style: TextStyle(
                        color: Color(0xff71429C),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
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
