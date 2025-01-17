import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import '../Utils/VectorHelpers.dart';
import 'fruit.dart';

class FruitSpawner extends Component with HasGameRef<Forge2DGame> {
  late Timer spawnTimer;
  final Random _random = Random(); // Instancia de generador de números aleatorios


  FruitSpawner() {
    spawnTimer = Timer(2, repeat: true, onTick: _spawnFruit);
  }

  void _spawnFruit() {
    final position = Vector2(gameRef.size.x / 2, gameRef.size.y - 20);
    final velocity = VectorHelpers.rotate(Vector2(0, -10), _randomAngle());


    gameRef.add(Fruit(
      position: position,
      velocity: velocity,
      width: 20, // Asigna un valor adecuado para el ancho
      height: 20, // Asigna un valor adecuado para la altura
    ));
  }

  double _randomAngle() {
    return (_random.nextDouble() - 0.5) * 0.5; // Ángulo aleatorio
  }

  @override
  void update(double dt) {
    spawnTimer.update(dt);
  }
}