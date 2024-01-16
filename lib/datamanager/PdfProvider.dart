import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final generatedPdf = pw.Document();

  Future<void> generate(List<String> cloudFirestorePdfLinks) async {
    for (String documentLink in cloudFirestorePdfLinks) {
      // Fetch data from Firestore based on the document link
      DocumentSnapshot snapshot = await _firestore.doc(documentLink).get();

      // Extract relevant data from the snapshot
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Add data to the PDF
      generatedPdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(
                data.toString(),
                style: pw.TextStyle(fontSize: 12),
              ),
            );
          },
        ),
      );
    }

    // Save the generated PDF to a file or do something else with it
    // Example: Save PDF to a file
    final pdfFile = await generatedPdf.save();
    print("PDF File saved at: $pdfFile");

    notifyListeners();
  }
}
