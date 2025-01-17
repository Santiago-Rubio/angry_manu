

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import '../Fruits/fruit.dart';
import 'Components/Slicer.dart';
import 'Utils/RandomGenerator.dart';

class AngryManuGame extends Forge2DGame {
  AngryManuGame() : super(gravity: Vector2(0, 10), zoom: 10);


  late Slicer blade;
  final RandomGenerator random = RandomGenerator();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Añadir la cuchilla
    blade = Slicer();
    add(blade);

    // Generar frutas periódicamente
    addFruitPeriodically();
  }

  void addFruitPeriodically() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      final fruit = Fruit(random.generatePosition(), random.generateVelocity());
      add(fruit);
    });
  }
}