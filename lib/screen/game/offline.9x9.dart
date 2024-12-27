import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:tic_tac_toe_game/screen/home/home.screen.dart';
import 'package:tic_tac_toe_game/utils/sounds.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/fonts.dart';

class TicTacToeGameOffline9x9 extends StatefulWidget {
  @override
  _TicTacToeGameOffline9x9State createState() =>
      _TicTacToeGameOffline9x9State();
}

class _TicTacToeGameOffline9x9State extends State<TicTacToeGameOffline9x9> {
  // The 3x3 grid
  List<List<String>> grid = List.generate(5, (_) => List.filled(5, ''));

  // Current player ('X' or 'O')
  String currentPlayer = 'O'; // Start with 'O'

  final List<String> players = ['X', 'O', 'Z'];

  // Game status
  String? gameResult;

  // Reset the game
  void resetGame() {
    setState(() {
      grid = List.generate(5, (_) => List.filled(5, ''));
      currentPlayer = 'O'; // Reset to 'O'
      gameResult = null;
    });
  }

  void makeMove(int row, int col) {
    tap();
    if (grid[row][col] == '' && gameResult == null) {
      setState(() {
        grid[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          gameResult = '$currentPlayer Wins!';
          _showResultDialog('$currentPlayer Wins!');
        } else if (isDraw()) {
          gameResult = 'It\'s a Draw!';
          _showResultDialog('It\'s a Draw!');
        } else {
          // Cycle to the next player
          int nextPlayerIndex =
              (players.indexOf(currentPlayer) + 1) % players.length;
          currentPlayer = players[nextPlayerIndex];
        }
      });
    }
  }

  // Check if the current player has won
  bool checkWinner(int row, int col) {
    // Check row for 3 consecutive marks
    for (int startCol = 0; startCol <= col; startCol++) {
      if (col + 2 < grid[row].length) {
        if (grid[row]
            .skip(startCol)
            .take(3)
            .every((cell) => cell == currentPlayer)) {
          return true;
        }
      }
    }

    // Check column for 3 consecutive marks
    for (int startRow = 0; startRow <= row; startRow++) {
      if (row + 2 < grid.length) {
        if (grid.skip(startRow).take(3).every((r) => r[col] == currentPlayer)) {
          return true;
        }
      }
    }

    // Check diagonal (top-left to bottom-right) for 3 consecutive marks
    for (int i = 0; i < 3; i++) {
      if (grid[row + i][col + i] != currentPlayer) {
        return false;
      }
    }

    // Check anti-diagonal (top-right to bottom-left) for 3 consecutive marks
    for (int i = 0; i < 3; i++) {
      if (grid[row + i][col - i] != currentPlayer) {
        return false;
      }
    }

    return false;
  }

  // Check if the game is a draw
  bool isDraw() {
    return grid.every((row) => row.every((cell) => cell != ''));
  }

  late AudioPlayer player = AudioPlayer();

  void soundWin() {
    player.play(AssetSource(AppSounds.tap));
  }

  void tap() {
    player.play(AssetSource(AppSounds.win));
  }

  // Show result dialog
  void _showResultDialog(String message) {
    soundWin();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(''),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentPlayer == 'X')
                Image.asset(
                  'assets/images/1.png',
                  height: 50,
                ),
              if (currentPlayer == 'O')
                Image.asset(
                  'assets/images/2.png',
                  height: 70,
                ),
              if (currentPlayer == 'Z')
                Image.asset(
                  'assets/images/3.png',
                  height: 70,
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAll(HomeScreen());
              },
              child: Text('Exit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Current Player or Game Result
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
                  if (currentPlayer == 'O')
                    Image.asset('assets/images/2.png', height: 50),
                  if (currentPlayer == 'X')
                    Image.asset('assets/images/1.png', height: 50),
                  if (currentPlayer == 'Z')
                    Image.asset('assets/images/3.png', height: 50),
                  // Add Z image
                ],
              ),
            ),
          ),
          // Tic Tac Toe Grid
          ...List.generate(5, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (col) {
                return GestureDetector(
                  onTap: () => makeMove(row, col),
                  child: Container(
                    width: 60,
                    height: 60,
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
                                : grid[row][col] == 'O'
                                    ? 'assets/images/2.png'
                                    : 'assets/images/3.png', // Add Z image logic
                          ),
                  ),
                );
              }),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                if (currentPlayer == 'O')
                  Image.asset('assets/images/2.png', height: 50),
                if (currentPlayer == 'X')
                  Image.asset('assets/images/1.png', height: 50),
                if (currentPlayer == 'Z')
                  Image.asset('assets/images/3.png', height: 50), // Add Z image
              ],
            ),
          ),
        ],
      ),
    );
  }
}
