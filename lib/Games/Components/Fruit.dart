import 'package:flame_forge2d/flame_forge2d.dart';
import '../Utils/VectorHelpers.dart';


class Fruit extends BodyComponent {
  final Vector2 position;
  final Vector2 velocity;

  Fruit({required this.position, required this.velocity});

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1.0;

    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.6
      ..density = 0.8;

    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    body.applyLinearImpulse(VectorHelpers.clampMagnitude(velocity, 10));
    return body;
  }
}