import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tic_tac_toe_game/screen/home/home.screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/fonts.dart';
import '../../utils/functions.dart';

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
    if (grid[row][col] == '' && gameResult == null) {
      setState(() {
        grid[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          gameResult = '$currentPlayer Wins!';
          if (currentPlayer == 'X') {
            print('X win!');
            addScore(Get.arguments[0], 1);
          } else if (currentPlayer == 'O') {
            print('O win!');
            addScore(Get.arguments[0], 1);
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

  // Show result dialog
  void _showResultDialog(String message) {
    Dialogs.materialDialog(
        color: Colors.white,
        msg: '$message',
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
            onPressed: (){
              _showResetDialog();
            },
            color: Colors.blue,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current Player or Game Result
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(3.14159),
              child: Text(
                gameResult ?? 'Player turn: $currentPlayer',
                style: const TextStyle(
                  fontFamily: AppFonts.quicksand,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
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
                          ),
                  ),
                );
              }),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              gameResult ?? 'Player turn: $currentPlayer',
              style: const TextStyle(
                fontFamily: AppFonts.quicksand,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
