

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class AngryManuGame extends Forge2D with HasKeyboardHandlerComponents, HasCollisionDetection{


  @override
  bool get debugMode => true;
  late Background background;
  late Scoreboard scoreboard;
  late double screenHeight;
  late double screenWidth;
  late List<Fruit> fruits;

  @override
  Future<void> onLoad() async {
    screenHeight = size.y;
    screenWidth = size.x;

    background = Background();
    add(background);

    scoreboard = Scoreboard();
    add(scoreboard);

    fruits = [];
    spawnFruit();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Actualizar cada fruta en la lista
    for (var fruit in fruits) {
      fruit.update(dt);
    }
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    super.onPanUpdate(details);

    // Cortar las frutas al tocar la pantalla
    for (var fruit in fruits) {
      if (fruit.toRect().contains(details.localPosition)) {
        fruit.cut();
        scoreboard.incrementScore(); // Sumar puntos al cortar una fruta
        remove(fruit);
        spawnFruit(); // Generar una nueva fruta
      }
    }
  }

  void spawnFruit() {
    // Generar frutas al azar en la parte inferior de la pantalla
    final fruit = Fruit(world)
      ..position = Vector2(screenWidth * 0.5, screenHeight)
      ..size = Vector2(50, 50)
      ..speed = 300;
    fruits.add(fruit);
    add(fruit);
  }
}

}