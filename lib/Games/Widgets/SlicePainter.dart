import 'package:flutter/material.dart';

class SlicePainter extends CustomPainter {
  final List<Offset> pointsList; // Lista de puntos del corte

  SlicePainter({required this.pointsList});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.6) // Color del corte
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5; // Grosor de la línea

    for (int i = 0; i < pointsList.length - 1; i++) {
      // Dibujamos una línea entre los puntos consecutivos
      canvas.drawLine(pointsList[i], pointsList[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Siempre repintamos cuando el estado cambia
  }
}