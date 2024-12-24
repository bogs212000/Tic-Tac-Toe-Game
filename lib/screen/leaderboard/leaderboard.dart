
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe_game/utils/fonts.dart';
import 'package:tic_tac_toe_game/utils/images.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/const.dart';


class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Leaderboard'.text.make(),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: ['#$rank   '.text.bold.size(20).make(),],
      ),
      body: VxBox(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('wins', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error fetching data."));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No data available."));
              }
              // Extract data
              final users = snapshot.data!.docs;

              // Get current user's UID
              final currentUserEMAIL = FirebaseAuth.instance.currentUser?.email;
              for (int i = 0; i < users.length; i++) {
                if (users[i].id == currentUserEMAIL) {
                  rank = i + 1; // Rank is index + 1
                  break;
                }
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final username = user['username'];
                  final score = user['wins'];

                  return GestureDetector(
                    onTap: () {
                      // Handle onTap if needed
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                      child: VxBox(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              10.widthBox,
                              Expanded(
                                child: VxBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          '$username'.text.bold.size(15).make(),
                                          Spacer(),
                                          "${index + 1}  "
                                              .text
                                              .extraBold
                                              .size(30)
                                              .gray500
                                              .make(),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                         VxBox().height(5).width(150).color(Colors.blueAccent).rounded.make(),
                                          Spacer(),
                                          Image.asset(AppImages.trophy, height: 15),
                                          '$score wins'.text.size(15).make(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ).make(),
                              ),
                            ],
                          ),
                        ),
                      ).height(100).rounded.shadowXs.color(rank != index +1 ? Colors.blue.shade100 : Colors.white).make(),
                    ),
                  );
                },
              );
            }),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .color(Colors.blueAccent)
          .make(),
    );
  }
}