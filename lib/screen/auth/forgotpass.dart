import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../../utils/functions.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({super.key});

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
      ),
      body: VxBox(
        child: Column(
          children: [
            40.heightBox,
            Row(
              children: [
                'Forgot Password'
                    .text
                    .bold
                    .color(Colors.blueAccent)
                    .size(20)
                    .make(),
              ],
            ),
            Row(
              children: [
                'Please input your account email'
                    .text
                    .bold
                    .black
                    .fontFamily(AppFonts.quicksand)
                    .size(15)
                    .make(),
              ],
            ),
            10.heightBox,
            SizedBox(
              height: 50,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 140,
                  height: 40,
                  child: GlowButton(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.btn_colors,
                      onPressed: () {
                        if (emailController.text.isEmpty) {
                          if (!Get.isSnackbarOpen) {
                            Get.snackbar(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              'Notice',
                              'Please input your email and password.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              isDismissible:
                                  false, // Make it non-dismissible until login is complete
                            );
                          }
                        } else {
                          Get.snackbar(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            'Loading',
                            'Please wait while we sending a link.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: Colors.blueAccent,
                            duration: Duration(seconds: 3),
                            isDismissible:
                                false, // Make it non-dismissible until login is complete
                          );
                          // Get.to(()=>HomeScreen());
                          AuthService().forgotPass(
                              emailController.text.trim().toLowerCase());
                          emailController.clear();
                        }
                      },
                      child: 'Request Link'.text.bold.white.make()),
                ),
              ],
            ),
          ],
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .padding(
            EdgeInsets.all(20),
          )
          .white
          .make(),
    );
  }
}
