import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tic_tac_toe_game/models/user.dart';
import 'package:tic_tac_toe_game/screen/auth/auth.wrapper.dart';
import 'package:tic_tac_toe_game/screen/game/game.screen.dart';
import 'package:tic_tac_toe_game/screen/game/scan.qr.dart';
import 'package:tic_tac_toe_game/screen/home/loading.screen.dart';
import 'package:tic_tac_toe_game/screen/leaderboard/leaderboard.dart';
import 'package:tic_tac_toe_game/screen/qr/show.qr.dart';
import 'package:tic_tac_toe_game/utils/colors.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:tic_tac_toe_game/utils/images.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/const.dart';
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
    getUserData(setState);
    getPlayerRank(setState);
  }

  @override
  Widget build(BuildContext context) {
    return username == null || username == ""
        ? const Loading()
        : Scaffold(
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
                            wins!.toString().text.bold.size(15).white.make(),
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
                    Get.to(() => ShowQr());
                  },
                  child: Image.asset('assets/images/icons8-qr-code-94.png',
                          height: 30)
                      .paddingOnly(right: 20),
                ),
                GestureDetector(
                    onTap: () {
                      Dialogs.bottomMaterialDialog(
                          msg: 'Are you sure?',
                          title: 'Sign Out',
                          context: context,
                          actions: [
                            IconsOutlineButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                              iconData: Icons.cancel_outlined,
                              textStyle: TextStyle(color: Colors.grey),
                              iconColor: Colors.grey,
                            ),
                            IconsOutlineButton(
                              onPressed: () {
                                Navigator.pop(context);
                                FirebaseAuth.instance.signOut();
                                Get.offAll(AuthWrapper());
                              },
                              text: 'Continue',
                              iconData: Icons.logout,
                              color: Colors.blueAccent,
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);
                    },
                    child: const Icon(
                      Icons.logout,
                      color: Colors.blue,
                    )),
                20.widthBox,
              ],
            ),
            body: VxBox(
              child: Column(
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 95,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GlowButton(
                                borderRadius: BorderRadius.circular(20),
                                onPressed: () {
                                  Get.to(() => Leaderboard());
                                },
                                color: AppColors.btn_colors,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    '# $rank'.text.bold.size(15).white.make(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Image.asset(AppImages.leaderboard, height: 50),
                        ],
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
                        Get.to(() => ScanQr());
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
                        Get.to(() => TicTacToeGameOffline());
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
