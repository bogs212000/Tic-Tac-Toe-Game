import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe_game/screen/home/home.screen.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../utils/fonts.dart';

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
          } else if(currentPlayer == 'O'){
            print('O win!');
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
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
            onPressed: resetGame,
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
