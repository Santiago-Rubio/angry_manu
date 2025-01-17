import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../Utils/VectorHelpers.dart';
import 'fruit.dart';

class FruitSpawner extends Component with HasGameRef<Forge2DGame> {
  late Timer spawnTimer;

  FruitSpawner() {
    spawnTimer = Timer(2, repeat: true, onTick: _spawnFruit);
  }

  void _spawnFruit() {
    final position = Vector2(gameRef.size.x / 2, gameRef.size.y - 20);
    final velocity = VectorHelpers.rotate(Vector2(0, -10), _randomAngle());
    gameRef.add(Fruit(position: position, velocity: velocity));
  }

  double _randomAngle() {
    return (gameRef.random.nextDouble() - 0.5) * 0.5; // Ángulo aleatorio
  }

  @override
  void update(double dt) {
    spawnTimer.update(dt);
  }
}