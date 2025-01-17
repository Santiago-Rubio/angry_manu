import 'package:angry_manu/Games/AngryManuGame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      const GameWidget<AngryManuGame>.controlled(
        gameFactory: AngryManuGame.new,
      )
  );
}
