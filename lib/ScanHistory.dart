import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ScanHistory extends StatefulWidget {
  const ScanHistory({Key? key}) : super(key: key);

  @override
  _ScanHistoryState createState() => _ScanHistoryState();
}

class _ScanHistoryState extends State<ScanHistory> {
  late DatabaseReference _databaseReference;
  late List<Map<dynamic, dynamic>> _scanList;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('users/$userId/scans/');
    _scanList = [];
    fetchScanData();
  }

  Future<void> fetchScanData() async {
    DatabaseEvent event = await _databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    Map<dynamic, dynamic>? data = dataSnapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      setState(() {
        _scanList = List<Map<dynamic, dynamic>>.from(data.values);
        _scanList.sort((a, b) => b['scanName'].compareTo(a['scanName']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 120.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Center(
            child: Text(
              "Scan History",
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100.0, top: 0.0),
        clipBehavior: Clip.hardEdge,
        itemCount: _scanList.length,
        itemBuilder: (context, itemCount) {
          Map<dynamic, dynamic> scanData = _scanList[itemCount];
          String scanName = scanData['scanName'] ?? '';
          String scanText = scanData['scanText'] ?? '';
          return ListTile(
            title: Text(
              scanName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('$scanText\n________________'),
          );
        },
      ),
    );
  }
}
