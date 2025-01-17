import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';


class Fruit extends BodyComponent {
  final Vector2 position;
  final Vector2 velocity;
  final double width;
  final double height;

  Fruit({
    required this.position,
    required this.velocity,
    this.width = 10.0,
    this.height = 10.0,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = width / 2;

    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.6
      ..density = 0.8;

    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    body.applyLinearImpulse(velocity);
    return body;
  }
}