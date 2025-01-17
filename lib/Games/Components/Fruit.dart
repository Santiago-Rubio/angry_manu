import 'dart:ui';

import 'package:forge2d/forge2d.dart';

class Fruit {
  Body? body;
  double width;
  double height;
  double rotation;

  Fruit({
    required this.body,
    required this.width,
    required this.height,
    required this.rotation,
  });


  bool isPointInside(Offset point) {
    // Usamos la posición del cuerpo para detectar la colisión
    final worldPos = body?.worldCenter ?? Vector2.zero();
    return point.dx >= worldPos.x &&
        point.dx <= worldPos.x + width &&
        point.dy >= worldPos.y &&
        point.dy <= worldPos.y + height;
  }
}