
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe_game/screen/home/home.screen.dart';
import 'package:tic_tac_toe_game/utils/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/images.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            20.heightBox,
            Row(
              children: [
                Image.asset(AppImages.tictactoe),
                10.widthBox,
                'Tic Tac Toe'.text.bold.size(30).make()
              ],
            ),
            20.heightBox,
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
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            20.heightBox,
            SizedBox(
              height: 50,
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
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
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.blueAccent),
                ),
              ),
            ),
            15.heightBox,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => SignUpPage());
                  },
                  child: 'Sign up'.text.color(Colors.blueAccent).bold.size(13).make(),
                ),
                Spacer(),
                SizedBox(
                  height: 40,
                  child: GlowButton(
                      borderRadius: BorderRadius.circular(20),
                    color: AppColors.btn_colors,
                      onPressed: () {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          if(!Get.isSnackbarOpen){
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
                            'Please wait while we process your login.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            colorText: Colors.blueAccent,
                            duration: Duration(seconds: 3),
                            isDismissible:
                            false, // Make it non-dismissible until login is complete
                          );
                          Get.to(()=>HomeScreen());
                          // AuthService().signIn(
                          //     emailController.text.trim().toLowerCase(),
                          //     passwordController.text.trim());
                        }
                      },
                      child: 'Sign in'.text.bold.white.make()),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    // Get.to(()=> PuzzleScreen());
                    // Get.to(()=> TicTacToeGame());
                    // Get.to(()=>ForgotPassPage());
                  },
                  child: 'Forgot password'.text.color(Colors.blueAccent).bold.size(12).make(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}