import 'package:flame_forge2d/forge2d.dart';
import 'package:flame/components.dart';

class Fruit extends BodyComponent {
  double speed = 300; // Velocidad de ascenso de la fruta
  bool isCut = false; // Estado de la fruta (si está cortada o no)

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('fruit.png'); // Reemplaza con tu sprite de fruta
    position = Vector2(gameRef.size.x * 0.5, gameRef.size.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isCut) {
      position.y -= speed * dt; // Mueve la fruta hacia arriba
    }
  }

  void cut() {
    // Logica para cortar la fruta, añadiendo efectos visuales o animaciones
    isCut = true;
    removeFromParent();
  }
}