import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:tic_tac_toe_game/screen/game/game.screen.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/const.dart';

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
          setState(() {
            scannedData = result.text;
          });
          print('Results: $scannedData');
          Get.offAll(TicTacToeGame(), arguments: [scannedData, scannedData]);
          Get.snackbar(
            icon: Icon(Icons.check_circle, color: Colors.white,),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            'Success',
            'Scanning has been completed!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
            isDismissible:
            false, // Make it non-dismissible until login is complete
          );
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
