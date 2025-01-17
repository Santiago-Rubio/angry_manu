
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Slicer extends Component {
  Vector2? lastPosition;

  @override
  void render(Canvas canvas) {
    if (lastPosition != null) {
      final paint = Paint()..color = Colors.red;
      canvas.drawCircle(lastPosition!.toOffset(), 3, paint);
    }
  }

  @override
  void update(double dt) {}

  void moveTo(Vector2 position) {
    lastPosition = position;
  }
}