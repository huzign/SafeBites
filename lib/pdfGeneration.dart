import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    List<int> bytes = await pdf.save();
    final dir = await getExternalStorageDirectory();

    final file = File('${dir?.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

class PdfParagraphApi {
  static Future<File> generate(
    String scanName,
    String? userName,
    String? userEmail,
    String? extractText,
    List<List<dynamic>> matchingIngredients,
    List<List<dynamic>> matchingHalalProducts,
  ) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/Manrope-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/Manrope-Bold.ttf")),
    );

    final pdf = Document(theme: myTheme);
    const note =
        'Please note that the articles are somewhat fetched from Google which indicates that not every information provided by Google is correct. Furthermore, please do not worry about the authenticity of this application as our database is checked and verified by Dr. Areesha, a professional Nutritionist.';
    final reportName = scanName;
    final date = reportName.substring(5, 15);
    final ByteData image =
        await rootBundle.load('assets/images/splash_logo.png');
    Uint8List logoData = (image).buffer.asUint8List();

    List<String> listOfIngredients =
        matchingIngredients.map((innerList) => innerList.join(' → ')).toList();
    List<String> listOfEcodes = matchingHalalProducts
        .map((innerList) => innerList.join(' → '))
        .toList();

    // final customFont = Font.ttf(await rootBundle.load('assets/fonts/Manrope-Regular.ttf'));

    pdf.addPage(
      MultiPage(
        build: (context) => <Widget>[
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildCustomHeader(logoData),
          Paragraph(text: ''),
          ...buildBulletPoints(date, userName, userEmail),
          Paragraph(text: ''),
          Header(
              child: Text('Extracted Text',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Paragraph(text: '$extractText'),
          Header(
              child: Text('Ingredient Analysis',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          ...buildListOfIngredients(listOfIngredients),
          Header(
              child: Text('E-Numbers Analysis',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          ...buildListOfEcodes(listOfEcodes),
          Header(child: Text('')),
          Paragraph(
              text: 'Disclaimer:',
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  color: PdfColors.grey400)),
          Paragraph(
              text: note,
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 10,
                  color: PdfColors.grey400)),
          Header(child: Text('')),
        ],
        footer: (context) {
          final text = 'Page ${context.pageNumber} of ${context.pagesCount}';
          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1 * PdfPageFormat.cm),
            child: Text(
              text,
              style: const TextStyle(color: PdfColors.grey),
            ),
          );
        },
      ),
    );
    return PdfApi.saveDocument(name: 'Report of $reportName.pdf', pdf: pdf);
  }

  static Widget buildCustomHeader(logoData) => Container(
        padding: const EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1, color: PdfColor.fromHex('#71429C'))),
        ),
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              child: Image(MemoryImage(logoData)),
            ),
            SizedBox(width: 0.5 * PdfPageFormat.cm),
            Text(
              'Product Analysis Report - By SafeBites',
              style: const TextStyle(
                fontSize: 20,
                color: PdfColors.black,
              ),
            ),
          ],
        ),
      );

  static Widget buildLink() => UrlLink(
        destination: 'https://flutter.dev',
        child: Text(
          'Go to flutter.dev',
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: PdfColors.blue,
          ),
        ),
      );

  static List<Widget> buildBulletPoints(date, userName, userEmail) => [
        Bullet(
            text:
                'User: ${userEmail.toString().capitalizeFirst?.replaceAll('@gmail.com', '')}'),
        Bullet(text: 'Email: $userEmail'),
        Bullet(text: 'Date: $date'),
      ];

  // Helper method to build the list of ingredients in Paragraph style
  static List<Widget> buildListOfIngredients(List<String> listOfIngredients) {
    final List<Widget> ingredientsWidgets = [];
    ingredientsWidgets.add(Paragraph(
        text: 'Ingredients → Impact → Comments by Certified Medical Professional Dr. Arisha',
        style: TextStyle(fontWeight: FontWeight.bold)));

    for (var ingredient in listOfIngredients) {
      ingredientsWidgets.add(Paragraph(text: ingredient));
    }

    return ingredientsWidgets;
  }

// Helper method to build the list of Ecodes in Paragraph style
  static List<Widget> buildListOfEcodes(List<String> listOfEcodes) {
    final List<Widget> ecodesWidgets = [];
    ecodesWidgets.add(Paragraph(
        text:
            'E Codes → Name → Description → Halal Sign Status → Clarification',
        style: TextStyle(fontWeight: FontWeight.bold)));

    for (var ecode in listOfEcodes) {
      ecodesWidgets.add(Paragraph(text: ecode));
    }

    return ecodesWidgets;
  }
}
