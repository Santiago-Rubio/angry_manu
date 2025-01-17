import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/forge2d/forge2d_game.dart';
import 'fruit.dart';

class FruitSpawner extends Component with HasGameRef<Forge2DGame> {
  late Timer _timer;

  FruitSpawner() {
    _timer = Timer(2, repeat: true, onTick: spawnFruit);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void spawnFruit() {
    final position = Vector2(gameRef.size.x * 0.5, gameRef.size.y - 1); // Genera frutas desde abajo.
    gameRef.add(Fruit(position));
  }
}