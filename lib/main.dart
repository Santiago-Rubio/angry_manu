import 'package:angry_manu/Games/AngryManuGame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';


void main() {
  runApp(
    GameWidget<AngryManuGame>(
      game: AngryManuGame(),
    ),
  );
}
