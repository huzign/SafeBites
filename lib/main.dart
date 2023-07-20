import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safebites/Dashboard.dart';
import 'package:safebites/Landing.dart';
import 'package:safebites/Profile.dart';
import 'ProductAnalysis.dart';
import 'ScanHistory.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Manrope',
        primarySwatch: Colors.deepPurple,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
    );
  }
}

class Navbar extends StatefulWidget {
  Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  List<IconData> data = [
    Icons.dashboard_rounded,
    Icons.history_rounded,
    Icons.document_scanner_rounded,
    Icons.person_rounded
  ];

  final List<Widget> _screens = [
    DashboardScreen(),
    ScanHistory(),
    ProductAnalysis(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _screens[selectedIndex],
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF351454),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(data.length, (i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.only(bottom: 40, top: 15),
                        width: 50,
                        decoration: BoxDecoration(
                          border: i == selectedIndex
                              ? const Border(
                                  top: BorderSide(
                                      width: 3.0, color: Colors.white))
                              : null,
                          gradient: i == selectedIndex
                              ? const LinearGradient(
                                  colors: [
                                      Color(0xff71429C),
                                      Color(0xFF351454)
                                    ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)
                              : null,
                        ),
                        child: Icon(
                          data[i],
                          size: 35,
                          color: i == selectedIndex
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
