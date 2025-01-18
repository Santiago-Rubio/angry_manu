import 'dart:ui';

import 'package:forge2d/forge2d.dart';

class Fruit {
  Body? body;
  double width;
  double height;
  double rotation;
  //final String type;  // Campo para el tipo de fruta

  Fruit({
    required this.body,
    required this.width,
    required this.height,
    required this.rotation,
    //required this.type,  // Inicialización del tipo
  });


  bool isPointInside(Offset point) {
    // Usamos la posición del cuerpo para detectar la colisión
    final worldPos = body?.worldCenter ?? Vector2.zero();
    return point.dx >= worldPos.x &&
        point.dx <= worldPos.x + width &&
        point.dy >= worldPos.y &&
        point.dy <= worldPos.y + height;
  }

  // Actualiza la posición de la fruta en base a su cuerpo en Forge2D
  void updatePosition() {
    if (body != null) {
      final worldPos = body!.worldCenter;  // Usamos '!' porque ya verificamos que body no es null
      // Actualiza la posición de la fruta de acuerdo a la posición física en el mundo
      width = worldPos.x;
      height = worldPos.y;
      rotation = body!.angle;  // Rotación de la fruta
    }
  }
}