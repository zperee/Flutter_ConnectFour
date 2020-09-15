import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'connectFour.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Four',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  GameState game = GameState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Four'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  game.reset();
                });
              }),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    padding: EdgeInsets.all(15),
                    color: game.winner != null
                        ? game.winner.color
                        : game.activePlayer.color,
                    child: (game.winner != null
                        ? game.winner.playerNumber != 3
                            ? Center(
                                child: Text('Spieler ${game.winner.playerNumber} hat gewonnen'))
                            : Center(child: Text('Das Spiel endet unentschieden'))
                        : Center(
                            child: Text('Spieler ${game.activePlayer.playerNumber} ist am Zug'))),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child:
              GridView.count(
                crossAxisCount: 7,
                children: List.generate(42, (index) {
                  int column = index % 7;
                  int row = index ~/ 7;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: FlatButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50)),
                        color:
                            game.field.elementAt(column).reversed.elementAt(row) != null
                                ? game.field.elementAt(column).reversed.elementAt(row).color
                                : Colors.lightBlue,
                        onPressed: () {
                          setState(() {
                            game.move(column);
                          });
                        }, child: null,
                      ),
                    ),
                  );
                }),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
