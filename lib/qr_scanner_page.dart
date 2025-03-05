import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  final Function(String) onScanned;

  const QRScannerPage({required this.onScanned, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan QR Code")),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            String scannedCode = barcodes.first.rawValue!;

            Future.delayed(Duration.zero, () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              Future.delayed(Duration(milliseconds: 300), () {
                onScanned(scannedCode);
              });
            });
          }
        },
      ),
    );
  }
}