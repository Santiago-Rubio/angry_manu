

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/forge2d/forge2d_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

class AngryManuGame extends Forge2DGame with HasTappableComponents, HasDraggableComponents {
  AngryManuGame() : super(gravity: Vector2(0, 10)); // Gravedad hacia abajo.


  @override
  bool get debugMode => true;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Añadimos el spawner para generar frutas.
    add(FruitSpawner());

    // Añadimos el slicer para detectar gestos de corte.
    add(Slicer());
  }
}