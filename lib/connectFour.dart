import 'dart:math';

import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  List<List<int>> field;
  int activePlayer;
  int winner;
  int countMoves;

  GameState() {
    reset();
  }

  void reset() {
    field = List.generate(7, (index) => List.generate(6, (index) => 0));
    Random random = new Random();
    winner = 0;
    activePlayer = random.nextBool() ? 1 : 2;

    countMoves = 0;
    notifyListeners();
  }

  @override
  String toString() {
    // return a string representation of the field for debugging
    return field.join('\n');
  }

  bool canMove(int column) {
    return !field[column].contains(0);
  }

  move(int column) {
    if (canMove(column) || winner != '') return;

    int row = field[column].indexOf(0);
    field[column][row] = activePlayer;

    countMoves++;

    // Überprüfung, ob aktueller Spieler gewonnen hat
    if (checkWinningMove(column, row)) {
      winner = activePlayer;
    } else {
      if (countMoves == 42) winner = 3;

      activePlayer = activePlayer == 1 ? 2 : 1;
    }
  }

  bool checkWinningMove(int column, int row) {
    // horitontal
    for (int i = 0; i < 3; i++) {
      bool winningResult = checkWinningSlice(field[column].sublist(i, i + 4));
      if (winningResult != false) return winningResult;
    }

    // vertikal
    for (int i = 0; i < 4; i++) {
      bool winningResult = checkWinningSlice(
          field.sublist(i, i + 4).map((col) => col[row]).toList());
      if (winningResult != false) return winningResult;
    }

    // diagonal
    for (int i = 0; i < 4; i++) {
      // down left
      if (column >= 3) {
        bool winningResult = checkWinningSlice(field
            .sublist(i, i + 4)
            .asMap()
            .entries
            .map((entry) => entry.value[entry.key])
            .toList());
        if (winningResult != false) return winningResult;
      }

      // down right
      if (column <= 3) {
        bool winningResult = checkWinningSlice(field
            .sublist(i, i + 4)
            .asMap()
            .entries
            .map((entry) => entry.value[3 - entry.key])
            .toList());
        if (winningResult != false) return winningResult;
      }
    }
    return false;
  }

  bool checkWinningSlice(List<int> miniField) {
    if (miniField.any((cell) => cell == 0)) return false;
    if (miniField[0] == miniField[1] &&
        miniField[1] == miniField[2] &&
        miniField[2] == miniField[3]) {
      return true;
    }

    return false;
  }
}
