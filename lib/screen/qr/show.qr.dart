import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_bar_code/code/src/code_generate.dart';
import 'package:qr_bar_code/code/src/code_type.dart';
import 'package:qr_bar_code/qr/src/qr_code.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../home/home.screen.dart';

class ShowQr extends StatefulWidget {
  const ShowQr({super.key});

  @override
  State<ShowQr> createState() => _ShowQrState();
}

class _ShowQrState extends State<ShowQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          10.heightBox,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: 'Do not share an image of your qr code.'.text.size(15).fontFamily(AppFonts.quicksand).make(),
          ).animate()
              .fade(duration: 100.ms)
              .scale(delay: 100.ms),
          10.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VxBox(child: QRCode(data: FirebaseAuth.instance.currentUser!.email.toString()))
                  .height(200)
                  .width(200)
                  .shadow
                  .white
                  .rounded
                  .padding(EdgeInsets.all(5))
                  .make().animate()
        .fade(duration: 200.ms)
        .scale(delay: 200.ms),
            ],
          ),
          30.heightBox,
          SizedBox(
            height: 50,
            width: 200,
            child: GlowButton(
              borderRadius: BorderRadius.circular(20),
              onPressed: () {
                Get.offAll(HomeScreen());
              },
              color: AppColors.btn_colors,
              child: 'Back to Home'
                  .text
                  .bold
                  .size(20)
                  .fontFamily(AppFonts.quicksand)
                  .white
                  .make(),
            ),
          ).animate()
              .fade(duration: 300.ms)
              .scale(delay: 300.ms),
        ],
      ),
    );
  }
}
