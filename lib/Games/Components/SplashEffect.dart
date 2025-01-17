import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

class SplashEffect extends SpriteAnimationComponent {
  final Vector2 initialPosition;

  SplashEffect({
    required this.initialPosition,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = initialPosition; // Posición de la fruta al cortarla
    size = Vector2(40, 40);     // Tamaño de la animación

    // Cargar las imágenes de la animación
    final sprites = await Future.wait([
      Flame.images.load('cut1.png'),
      Flame.images.load('cut2.png'),
      Flame.images.load('cut3.png'),
      Flame.images.load('cut4.png'),
    ]);

    // Crear la animación con los sprites cargados
    animation = SpriteAnimation.spriteList(
      sprites.map((image) => Sprite(image)).toList(),
      stepTime: 0.1,  // Tiempo entre cada frame
      loop: false,    // Animación no se repite
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Si la animación ha terminado, removemos el componente
    // Verificar si la animación ha terminado
    if (animationTicker?.done() == true) {
      removeFromParent(); // Eliminar el componente si terminó
    }
  }

}