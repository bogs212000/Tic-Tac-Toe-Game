import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:tic_tac_toe_game/models/user.dart';
import 'package:tic_tac_toe_game/screen/game/game.screen.dart';
import 'package:tic_tac_toe_game/screen/game/scan.qr.dart';
import 'package:tic_tac_toe_game/screen/qr/show.qr.dart';
import 'package:tic_tac_toe_game/utils/colors.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:tic_tac_toe_game/utils/images.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/functions.dart';
import '../game/game.offline.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            SizedBox(
              height: 35,
              width: 90,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GlowButton(
                  borderRadius: BorderRadius.circular(20),
                  onPressed: () {},
                  color: AppColors.btn_colors,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      userModel!.role.toString()
                          .text
                          .bold
                          .size(15)
                          .fontFamily('Quicksand')
                          .white
                          .make(),
                    ],
                  ),
                ),
              ),
            ),
            Image.asset(AppImages.trophy, height: 40),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(()=>ShowQr());
            },
            child:
                Image.asset('assets/images/icons8-qr-code-94.png', height: 30)
                    .paddingOnly(right: 20),
          )
        ],
      ),
      body: VxBox(
        child: Column(
          children: [
            //icons8-trophy-96.png
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: GlowButton(
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () {},
                    color: AppColors.btn_colors,
                    child: const Center(
                        child: Icon(Icons.settings,
                            size: 20, color: Colors.white)),
                  ),
                ),
                10.widthBox,
                SizedBox(
                  height: 50,
                  width: 50,
                  child: GlowButton(
                    borderRadius: BorderRadius.circular(25),
                    onPressed: () {},
                    color: AppColors.btn_colors,
                    child: Center(
                        child: Icon(Icons.leaderboard_outlined,
                            size: 20, color: Colors.white)),
                  ),
                ),
              ],
            ),
            150.heightBox,
            Row(
              children: [
                Image.asset(AppImages.tictactoe),
                10.widthBox,
                'Tic Tac Toe'.text.bold.size(40).make()
              ],
            ),
            20.heightBox,
            SizedBox(
              height: 50,
              width: double.infinity,
              child: GlowButton(
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Get.to(()=>ScanQr());
                },
                color: AppColors.btn_colors,
                child: 'Multiplayer 1v1 (Online)'
                    .text
                    .bold
                    .size(20)
                    .fontFamily(AppFonts.quicksand)
                    .white
                    .make(),
              ),
            ),
            20.heightBox,
            SizedBox(
              height: 50,
              width: double.infinity,
              child: GlowButton(
                borderRadius: BorderRadius.circular(20),
                onPressed: () {
                  Get.to(()=>TicTacToeGameOffline());
                },
                color: AppColors.btn_colors,
                child: 'Multiplayer 1v1 (Offline)'
                    .text
                    .bold
                    .size(20)
                    .fontFamily('Quicksand')
                    .white
                    .make(),
              ),
            ),
          ],
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .padding(EdgeInsets.all(20))
          .white
          .make(),
    );
  }
}
