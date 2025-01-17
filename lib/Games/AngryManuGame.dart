

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import '../Fruits/fruit.dart';
import 'Components/FruitSpawner.dart';
import 'Components/Slicer.dart';
import 'Utils/RandomGenerator.dart';

class AngryManuGame extends Forge2DGame {
  AngryManuGame() : super(gravity: Vector2(0, 10), zoom: 10);

  @override
  Future<void> onLoad() async {
    add(FruitSpawner());
  }
}