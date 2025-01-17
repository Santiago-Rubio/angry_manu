import 'dart:ui';

class FruitPart {
  final Offset position;
  final double width;
  final double height;
  final bool isLeft;
  final double gravitySpeed;
  final Offset additionalForce;
  final double rotation;

  FruitPart({
    required this.position,
    required this.width,
    required this.height,
    required this.isLeft,
    required this.gravitySpeed,
    required this.additionalForce,
    required this.rotation,
  });
}