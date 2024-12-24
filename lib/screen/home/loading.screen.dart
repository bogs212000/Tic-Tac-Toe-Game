import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VxBox(
        child: Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: const CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          ),
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .make(),
    );
  }
}
