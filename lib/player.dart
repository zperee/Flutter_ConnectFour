
import 'package:flutter/material.dart';

class Player {
  MaterialColor color;
  int playerNumber;

  Player(int playerNumber) {
    this.playerNumber = playerNumber;
    this.color = playerNumber == 1 ? Colors.red : playerNumber ==  2 ? Colors.yellow : Colors.orange; // Colors Player 1, Player 2, draw
  }
}
