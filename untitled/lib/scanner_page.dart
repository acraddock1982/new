// scanner_page.dart
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ScannerPage extends StatefulWidget {
  final double budget;
  final Function(double) onUpdateTotal;

  const ScannerPage({Key? key, required this.budget, required this.onUpdateTotal}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<String> scannedItems = [];
  double totalSpent = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Remaining Budget: \$${(widget.budget - totalSpent).toStringAsFixed(2)}',
              style: TextStyle(
                color: budgetExceeded() ? Colors.red : budgetNearExceeded() ? Colors.yellow : Colors.green,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scannedItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(scannedItems[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        removeItem(index);
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _scanItem,
              child: Text('Scan Item'),
            ),
          ],
        ),
      ),
    );
  }

  bool budgetExceeded() {
    return totalSpent > widget.budget;
  }

  bool budgetNearExceeded() {
    return totalSpent > widget.budget * 0.8; // Adjust the threshold as needed
  }

  void _scanItem() async {
    try {
      final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

      if (pickedFile == null) {
        throw 'Error picking image';
      }

      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final barcodeScanner = GoogleMlKit.vision.barcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final String scannedItem = barcodes.first.value! as String;
        setState(() {
          scannedItems.add(scannedItem);
          totalSpent += 5.0; // Replace with logic to get the price of the item
          widget.onUpdateTotal(totalSpent);
        });
      } else {
        throw 'No barcode detected';
      }
    } catch (e) {
      print('Error scanning item: $e');
      // Handle error, show a message, etc.
    }
  }

  void removeItem(int index) {
    setState(() {
      totalSpent -= 5.0; // Replace with logic to subtract the price of the item
      widget.onUpdateTotal(totalSpent);
      scannedItems.removeAt(index);
    });
  }
}
