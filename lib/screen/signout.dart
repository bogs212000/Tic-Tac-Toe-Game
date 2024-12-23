import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utils/colors.dart';
import '../utils/functions.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
  TextEditingController();
  bool _isPasswordVisible = false;
  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Sign up'.text.color(Colors.blueAccent).make(),
        centerTitle: true,
        foregroundColor: AppColors.btn_colors,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(right: 40, left: 40, top: 10),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              20.heightBox,
              SizedBox(
                height: 50,
                child: TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.name,
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
                    hintText: 'Username',
                    prefixIcon: const Icon(
                      Icons.person_sharp,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
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
              20.heightBox,
              SizedBox(
                height: 50,
                child: TextField(
                  controller: passwordConfirmController,
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
                    hintText: 'Confirm Password',
                    // suffixIcon: IconButton(
                    //   icon: Icon(
                    //     _isPasswordVisible
                    //         ? Icons.visibility
                    //         : Icons.visibility_off,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       _isPasswordVisible = !_isPasswordVisible;
                    //     });
                    //   },
                    // ),
                    prefixIcon:
                    Icon(Icons.verified_user_rounded, color: Colors.blueAccent),
                  ),
                ),
              ),
              15.heightBox,
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 40,
                    child: GlowButton(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.btn_colors,
                        onPressed: () {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              usernameController.text.isEmpty) {
                            Get.snackbar(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              'Notice',
                              'Please fill all the required details.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              isDismissible:
                              false, // Make it non-dismissible until login is complete
                            );
                          } else if (passwordConfirmController.text !=
                              passwordController.text) {
                            Get.snackbar(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              'Notice',
                              'Password doest not match!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                              isDismissible:
                              false, // Make it non-dismissible until login is complete
                            );
                          } else {
                            Get.snackbar(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              'Loading',
                              'Please wait while we process your Sign up.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.white,
                              colorText: Colors.blueAccent,
                              duration: Duration(seconds: 3),
                              isDismissible:
                              false, // Make it non-dismissible until login is complete
                            );
                            AuthService().signUp(
                                emailController.text.trim().toLowerCase(),
                                passwordController.text.trim(),
                                usernameController.text.toString());
                          }
                        },
                        child: "Sign up".text.bold.white.make()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}