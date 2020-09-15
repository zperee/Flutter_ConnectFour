import 'dart:math';

import 'package:connect_four/player.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  List<List<Player>> field;
  Player activePlayer;
  Player player1;
  Player player2;
  Player winner;
  int countMoves;

  GameState() {
    reset();
  }

  void reset() {
    field = List.generate(7, (index) => List.generate(6, (index) => null));
    Random random = new Random();
    winner = null;
    player1 = new Player(1);
    player2 = new Player(2);
    activePlayer = random.nextBool() ? player1 : player2;

    countMoves = 0;
    notifyListeners();
  }

  @override
  String toString() {
    // return a string representation of the field for debugging
    return field.join('\n');
  }

  bool canMove(int column) {
    return !field[column].contains(null);
  }

  move(int column) {
    if (canMove(column) || winner != null) return;
    int row = field[column].indexOf(null);//  indexWhere((element) => element.playerNumber == 0);
    field[column][row] = activePlayer;

    countMoves++;

    // Überprüfung, ob aktueller Spieler gewonnen hat
    if (checkWinningMove(column, row)) {
      winner = activePlayer;
    } else {
      if (countMoves == 42) winner = new Player(3);

      activePlayer = activePlayer == player1 ? player2 : player1;
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

  bool checkWinningSlice(List<Player> miniField) {
    if (miniField.any((cell) => cell == null)) return false;
    if (miniField[0] == miniField[1] &&
        miniField[1] == miniField[2] &&
        miniField[2] == miniField[3]) {
      return true;
    }

    return false;
  }
}
