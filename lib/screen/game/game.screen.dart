import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tic_tac_toe_game/screen/home/home.screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/colors.dart';
import '../../utils/const.dart';
import '../../utils/fonts.dart';
import '../../utils/functions.dart';
import '../../utils/images.dart';
import '../../utils/sounds.dart';

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  // The 3x3 grid
  List<List<String>> grid = List.generate(3, (_) => List.filled(3, ''));

  // Current player ('X' or 'O')
  String currentPlayer = 'O'; // Start with 'O'

  // Game status
  String? gameResult;

  // Reset the game
  void resetGame() {
    setState(() {
      grid = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'O'; // Reset to 'O'
      gameResult = null;
    });
  }

  // Handle a player's move
  void makeMove(int row, int col) {
    soundWin();
    if (grid[row][col] == '' && gameResult == null) {
      setState(() {
        grid[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          gameResult = '$currentPlayer Wins!';
          if (currentPlayer == 'X') {
            print('X win!');
            addScore(Get.arguments[0], 1);
            getUserData(setState);
          } else if (currentPlayer == 'O') {
            print('O win!');
            wins! + 1;
            addScore(FirebaseAuth.instance.currentUser!.email.toString(), 1);
            getUserData(setState);
          }
          _showResultDialog('$currentPlayer Wins!');
        } else if (isDraw()) {
          gameResult = 'It\'s a Draw!';
          _showResultDialog('It\'s a Draw!');
        } else {
          currentPlayer = currentPlayer == 'O' ? 'X' : 'O';
        }
      });
    }
  }

  // Check if the current player has won
  bool checkWinner(int row, int col) {
    // Check row
    if (grid[row].every((cell) => cell == currentPlayer)) return true;

    // Check column
    if (grid.every((r) => r[col] == currentPlayer)) return true;

    // Check diagonal (top-left to bottom-right)
    if (row == col &&
        List.generate(3, (i) => grid[i][i])
            .every((cell) => cell == currentPlayer)) {
      return true;
    }

    // Check anti-diagonal (top-right to bottom-left)
    if (row + col == 2 &&
        List.generate(3, (i) => grid[i][2 - i])
            .every((cell) => cell == currentPlayer)) {
      return true;
    }

    return false;
  }

  // Check if the game is a draw
  bool isDraw() {
    return grid.every((row) => row.every((cell) => cell != ''));
  }

  late AudioPlayer player = AudioPlayer();

  void soundWin() {
    player.play(AssetSource(AppSounds.win));
  }

  void tap() {
    player.play(AssetSource(AppSounds.tap));
  }

  // Show result dialog
  void _showResultDialog(String message) {
    tap();
    Dialogs.materialDialog(
        barrierDismissible: false,
        color: Colors.white,
        msg: '$message',
        msgStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        title: 'Game Over',
        lottieBuilder: Lottie.asset(
          'assets/lottie/trophy.json',
          fit: BoxFit.contain,
        ),
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.offAll(HomeScreen());
            },
            text: 'Exit',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            text: 'Play Again',
            iconData: Icons.gamepad_outlined,
            color: Colors.green,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  // Reset Game table

  void _showResetDialog() {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: 'Do you want to reset the game?',
        title: 'Reset',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'No',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsOutlineButton(
            onPressed: () {
              resetGame();
              Navigator.of(context).pop();
            },
            text: 'Yes',
            iconData: Icons.refresh,
            color: Colors.green,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tic Tac Toe'),
        leading: GestureDetector(
          onTap: () {
            Get.offAll(HomeScreen());
          },
          child: const Icon(Icons.arrow_back, color: Colors.blue),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _showResetDialog();
            },
            color: Colors.blue,
          )
        ],
      ),
      body: VxBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current Player or Game Result
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(3.14159),
                child: Text(
                  Get.arguments[0],
                  style: const TextStyle(
                    fontFamily: AppFonts.quicksand,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ).animate()
                .fade(duration: 100.ms)
                .scale(delay: 100.ms),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VxBox()
                    .color(Colors.pinkAccent)
                    .height(4)
                    .width(150)
                    .rounded
                    .make(),
                Image.asset(
                  'assets/images/1.png',
                  height: 40,
                ),
              ],
            ).animate()
                .fade(duration: 200.ms)
                .scale(delay: 200.ms),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(3.14159),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gameResult ?? 'Player turn: ',
                      style: const TextStyle(
                        fontFamily: AppFonts.quicksand,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    currentPlayer == 'O'
                        ? Image.asset('assets/images/2.png', height: 50)
                        : Image.asset('assets/images/1.png', height: 50)
                  ],
                ),
              ),
            ).animate()
                .fade(duration: 300.ms)
                .scale(delay: 300.ms),
            // Tic Tac Toe Grid
            ...List.generate(3, (row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (col) {
                  return GestureDetector(
                    onTap: () => makeMove(row, col),
                    child: Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: grid[row][col] == ''
                          ? null
                          : Image.asset(
                              grid[row][col] == 'X'
                                  ? 'assets/images/1.png'
                                  : 'assets/images/2.png',
                            ).animate()
                          .fade(duration: 200.ms)
                          .scale(delay: 200.ms),
                    ),
                  );
                }),
              ).animate()
                  .fade(duration: 400.ms)
                  .scale(delay: 400.ms);
            }),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameResult ?? 'Player turn: ',
                    style: const TextStyle(
                      fontFamily: AppFonts.quicksand,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  currentPlayer == 'O'
                      ? Image.asset('assets/images/2.png', height: 50)
                      : Image.asset('assets/images/1.png', height: 50),
                  // Spacer(),
                  // Stack(
                  //   children: [
                  //     SizedBox(
                  //       height: 35,
                  //       width: 90,
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 5),
                  //         child: GlowButton(
                  //           borderRadius: BorderRadius.circular(20),
                  //           onPressed: () {},
                  //           color: AppColors.btn_colors,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               wins!.toString().text.bold.size(15).white.make(),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Image.asset(AppImages.trophy, height: 40),
                  //   ],
                  // ),
                ],
              ),
            ).animate()
        .fade(duration: 300.ms)
        .scale(delay: 300.ms),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/2.png',
                  height: 40,
                ),
                VxBox()
                    .color(Colors.blueAccent)
                    .height(4)
                    .width(150)
                    .rounded
                    .make(),
              ],
            ).animate()
        .fade(duration: 200.ms)
        .scale(delay: 200.ms),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(
                  fontFamily: AppFonts.quicksand,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ).animate()
        .fade(duration: 100.ms)
        .scale(delay: 100.ms),
          ],
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
      .white
          // .bgImage(const DecorationImage(
          //     image: AssetImage(AppImages.bg), fit: BoxFit.cover))
          .make(),
    );
  }
}
