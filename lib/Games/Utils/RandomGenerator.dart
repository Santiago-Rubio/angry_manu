import 'dart:math';
import 'package:flame_forge2d/flame_forge2d.dart';

class RandomGenerator {
  final Random random = Random();

  Vector2 generatePosition() {
    return Vector2(random.nextDouble() * 10, random.nextDouble() * 2 + 1);
  }

  Vector2 generateVelocity() {
    return Vector2(random.nextDouble() * 5 - 2.5, -random.nextDouble() * 5);
  }
}