import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:tic_tac_toe_game/screen/game/scan.qr.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/fonts.dart';
import '../../utils/const.dart';
import '../game/game.screen.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() {
          _isPermissionGranted = true;
        });
      } else {
        setState(() {
          _isPermissionGranted = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan QR codes.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    }
  }

  Future<void> _checkScannedData(String scannedData) async {
    try {
      // Query Firebase Firestore
      var query = await FirebaseFirestore.instance
          .collection('users') // Adjust collection name
          .where('email', isEqualTo: scannedData) // Replace 'uniqueId' with the appropriate field
          .get();

      if (query.docs.isNotEmpty) {
        // If data exists, navigate to the game screen
        Get.offAll(
          TicTacToeGame(),
          arguments: [scannedData, scannedData],
        );
        Get.snackbar(
          'Success',
          'Scanning has been completed!',
          icon: Icon(Icons.check_circle, color: Colors.white),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        // If no matching data found
        Get.snackbar(
          'Error',
          'No data found for this QR code!',
          icon: Icon(Icons.error, color: Colors.white),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        Get.to(()=>ScanQr());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        icon: Icon(Icons.error, color: Colors.white),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      Get.to(()=>ScanQr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Scanning player QR code'.text.fontFamily(AppFonts.quicksand).make(),
        backgroundColor: Colors.white,
      ),
      body: _isPermissionGranted
          ? QRCodeDartScanView(
        scanInvertedQRCode: true,
        typeScan: TypeScan.live,
        onCapture: (Result result) {
          String scannedData = result.text;
          print('Results: $scannedData');
          _checkScannedData(scannedData);
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Camera permission is required to scan QR codes.'),
            ElevatedButton(
              onPressed: _checkPermission,
              child: Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}
