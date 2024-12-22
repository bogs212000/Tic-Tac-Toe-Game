import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tic_tac_toe_game/screen/game/qr.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import 'game.screen.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: VxBox(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 220,
            child: GlowButton(
              borderRadius: BorderRadius.circular(20),
              onPressed: () {
                Get.to(()=>QrScreen());
              },
              color: AppColors.btn_colors,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, color: Colors.white),
                  10.widthBox,
                  'Scan Player QR'
                      .text
                      .bold
                      .size(20)
                      .fontFamily(AppFonts.quicksand)
                      .white
                      .make(),
                ],
              ),
            ),
          ),
        ],
      ),)
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
      .padding(EdgeInsets.all(20))
          .white
          .make(),
    );
  }
}
