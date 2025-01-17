import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math';

class VectorHelpers {
  /// Rotates a vector by a given angle in radians.
  static Vector2 rotate(Vector2 vector, double angle) {
    final cosTheta = cos(angle);
    final sinTheta = sin(angle);

    return Vector2(
      vector.x * cosTheta - vector.y * sinTheta,
      vector.x * sinTheta + vector.y * cosTheta,
    );
  }

  /// Calculates the distance between two points.
  static double distance(Vector2 a, Vector2 b) {
    return (a - b).length;
  }

  /// Normalizes a vector (makes its magnitude equal to 1).
  static Vector2 normalize(Vector2 vector) {
    return vector.normalized();
  }

  /// Linearly interpolates between two vectors by a factor t (0.0 to 1.0).
  static Vector2 lerp(Vector2 start, Vector2 end, double t) {
    return start + (end - start) * t;
  }

  /// Clamps the magnitude of a vector to a given max length.
  static Vector2 clampMagnitude(Vector2 vector, double maxLength) {
    if (vector.length > maxLength) {
      return vector.normalized() * maxLength;
    }
    return vector;
  }
}