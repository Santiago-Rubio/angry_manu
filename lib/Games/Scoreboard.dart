import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Scoreboard extends PositionComponent {
  int score = 0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: $score',
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, 10));
  }

  void incrementScore() {
    score += 10; // Cada fruta cortada suma 10 puntos
  }
}