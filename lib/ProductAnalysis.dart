// ignore_for_file: use_key_in_widget_constructors
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:csv/csv.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/services.dart';
import 'package:safebites/pdfGeneration.dart';

class ProductAnalysis extends StatefulWidget {
  @override
  _ProductAnalysis createState() => _ProductAnalysis();
}

class _ProductAnalysis extends State<ProductAnalysis> {
  bool _scanning = false;
  String _extractText = '';
  XFile? _pickedImage;
  List<Map<String, String>> _ingredientsResults = [];
  List<Map<String, String>> _halalProductsResults = [];

  List<List<dynamic>> matchingIngredients = [];
  List<List<dynamic>> matchingHalalProducts = [];

  // Generate scan name using the scanning datetime
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final String? userName = FirebaseAuth.instance.currentUser?.displayName;
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final String scanName = 'Scan ${DateTime.now()}';

  Future<List<List<dynamic>>> readIngredientsCSV() async {
    final String csvData = await rootBundle.loadString(
        'assets/database/FYP_Product_Categorization_Ingredients.csv');
    final List<List<dynamic>> rows =
        const CsvToListConverter().convert(csvData);
    return rows;
  }

  Future<List<List<dynamic>>> readHalalProductsCSV() async {
    final String csvData = await rootBundle
        .loadString('assets/database/Halal_Musbooh_Products.csv');
    final List<List<dynamic>> rows =
        const CsvToListConverter().convert(csvData);
    return rows;
  }

  Future<void> performOCRGallery() async {
    _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      final extractText =
          await FlutterTesseractOcr.extractText(_pickedImage!.path);
      setState(() {
        _extractText = extractText;
      });
    } catch (e) {
      setState(() {
        _extractText = 'OCR failed: $e';
      });
    }
  }

  Future<void> performOCRCamera() async {
    _pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      final extractText =
          await FlutterTesseractOcr.extractText(_pickedImage!.path);
      setState(() {
        _extractText = extractText;
      });
    } catch (e) {
      setState(() {
        _extractText = 'OCR failed: $e';
      });
    }
  }

  Future<void> searchIngredients() async {
    // Clear the previous results
    _ingredientsResults.clear();
    matchingIngredients.clear();
    // Read the CSV file
    List<List<dynamic>> ingredientsData = await readIngredientsCSV();

    String searchTerms = _extractText.toLowerCase();

    // Search and filter the halal products data
    for (List<dynamic> row in ingredientsData) {
      String ingredient = row[0].toString().toLowerCase();
      if (searchTerms.contains(ingredient)) {
        matchingIngredients.add(row);
      }
      setState(() {
        _ingredientsResults = matchingIngredients.map((row) {
          return {
            'Name': row[0].toString(),
            'Impact': row[1].toString(),
            'Comments by Certified Medical Professional Dr. Arisha': row[2].toString(),
          };
        }).toList();
      });
    }
  }

  Future<void> searchHalalProducts() async {
    _halalProductsResults.clear();
    matchingHalalProducts.clear();
    // Read the CSV file
    List<List<dynamic>> halalProductsData = await readHalalProductsCSV();

    // Clear the previous results

    String searchTerms = _extractText.toLowerCase();

    // Search and filter the halal products data
    for (List<dynamic> row in halalProductsData) {
      String eCode = row[0].toString().toLowerCase().substring(1);
      if (searchTerms.contains(eCode)) {
        matchingHalalProducts.add(row);
      }
      setState(() {
        _halalProductsResults = matchingHalalProducts.map((row) {
          return {
            'E Code': row[0].toString(),
            'HS Status': row[3].toString(),
            'Description': row[2].toString(),
          };
        }).toList();
      });
    }
  }

  Future<void> processImageAndSearchCamera() async {
    setState(() {
      _scanning = true;
    });

    await performOCRCamera();
    await searchIngredients();
    await searchHalalProducts();
    DatabaseReference scanReference =
        FirebaseDatabase.instance.ref().child('users/$userId/scans').push();
    scanReference.set({
      'scanName': scanName,
      'userId': userId,
      'scanText': _extractText,
      'ingredientAnalysis': matchingIngredients,
      'eCodeAnalysis': matchingHalalProducts,
    });

    setState(() {
      _scanning = false;
      imageCache.clear();
    });
  }

  Future<void> processImageAndSearchGallery() async {
    setState(() {
      _scanning = true;
    });

    await performOCRGallery();
    await searchIngredients();
    await searchHalalProducts();
    DatabaseReference scanReference =
        FirebaseDatabase.instance.ref().child('users/$userId/scans').push();
    scanReference.set({
      'scanName': scanName,
      'userId': userId,
      'scanText': _extractText,
      'ingredientAnalysis': matchingIngredients,
      'eCodeAnalysis': matchingHalalProducts,
    });

    setState(() {
      _scanning = false;
      imageCache.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0, bottom: 20),
            child: Text(
              'Product Analysis',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ),
          _pickedImage == null
              ? Container(
                  height: 300,
                  width: 300,
                  color: Colors.grey[200],
                  // ignore: prefer_const_constructors
                  child: Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                )
              : Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: FileImage(File(_pickedImage!.path)),
                        fit: BoxFit.contain,
                      )),
                ),
          Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: const Color(0xff71429C),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: processImageAndSearchGallery,
                  child: const Text(
                    'Select Image from Gallery',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              )),
          const SizedBox(width: 20),
          Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: const Color(0xff71429C),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: processImageAndSearchCamera,
                  child: const Text(
                    'Select Image from Camera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 20),
          _scanning
              // ignore: prefer_const_constructors
              ? Center(
                  child: const CircularProgressIndicator(),
                )
              : const Icon(
                  Icons.done,
                  size: 40,
                  color: Color(0xff71429C),
                ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 60.0, right: 20.0, left: 20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Extracted Text:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xff71429C),
                          fontFamily: 'Manrope',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _extractText,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Color(0xff71429C),
                          fontFamily: 'Manrope',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Flexible(
                        child: ExpandablePanel(
                          header: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Ingredients Analysis',
                              style: TextStyle(
                                color: Color(0xff71429C),
                                fontFamily: 'Manrope',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          expanded: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.all(
                                color: const Color(0xff71429C),
                                //style: BorderStyle.solid,
                                width: 1,
                              ),
                              showBottomBorder: true,
                              sortAscending: true,
                              dataRowMaxHeight: 48.0,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Color(0xff71429C),
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Impact',
                                  style: TextStyle(
                                    color: Color(0xff71429C),
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                      'Comments by Certified Medical Professional Dr. Arisha',
                                      style: TextStyle(
                                        color: Color(0xff71429C),
                                        fontFamily: 'Manrope',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                              ],
                              rows: _ingredientsResults.map<DataRow>((result) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                    result['Name'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                  DataCell(Text(
                                    result['Impact'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                  DataCell(Text(
                                    result['Comments by Certified Medical Professional Dr. Arisha'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                          collapsed: const SizedBox(height: 0.0),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Flexible(
                        child: ExpandablePanel(
                          header: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'E Numbers Analysis',
                              style: TextStyle(
                                color: Color(0xff71429C),
                                fontFamily: 'Manrope',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          expanded: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              showBottomBorder: true,
                              border: TableBorder.all(
                                color: const Color(0xff71429C),
                                //style: BorderStyle.solid,
                                width: 1,
                              ),
                              sortAscending: true,
                              dataRowMaxHeight: 58.0,
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'E Code',
                                  style: TextStyle(
                                    color: Color(0xff71429C),
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'HS Status',
                                  style: TextStyle(
                                    color: Color(0xff71429C),
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Color(0xff71429C),
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ],
                              rows:
                                  _halalProductsResults.map<DataRow>((result) {
                                return DataRow(cells: [
                                  DataCell(Text(
                                    result['E Code'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                  DataCell(Text(
                                    result['HS Status'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                  DataCell(Text(
                                    result['Description'] ?? '',
                                    style: const TextStyle(
                                      color: Color(0xff71429C),
                                      fontFamily: 'Manrope',
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                          collapsed: const Text(''),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                                color: const Color(0xff71429C),
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () async {
                                final pdfFile = await PdfParagraphApi.generate(
                                    scanName,
                                    userName,
                                    userEmail,
                                    _extractText,
                                    matchingIngredients,
                                    matchingHalalProducts);
                                PdfApi.openFile(pdfFile);
                              },
                              child: const Text(
                                'Download PDF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(height: 100.0),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }
}
