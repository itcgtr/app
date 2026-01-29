import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:gtr_app/Environment.dart';
import 'package:gtr_app/routes/Routes.dart';
import 'package:gtr_app/themes/Theme_Data.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: QR_Scan_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class QR_Scan_Page extends StatefulWidget {
  const QR_Scan_Page({super.key});

  @override
  State<QR_Scan_Page> createState() => QR_Scan_PageState();
}

class QR_Scan_PageState extends State<QR_Scan_Page> {
  MobileScannerController controller_scanner = MobileScannerController(
    facing: CameraFacing.back, //
    torchEnabled: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Page')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: MobileScanner(
                  controller: controller_scanner,
                  onDetect: (capture) async {
                    if (capture.barcodes.isNotEmpty) {
                      final barcode = capture.barcodes.first;

                      if (barcode.rawValue != null) {
                        controller_scanner.stop();
                        Navigator.of(context).pop(barcode.rawValue);
                      }
                    }
                  },
                  tapToFocus: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
