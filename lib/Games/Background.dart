import 'package:flame_forge2d/forge2d.dart';

class Background extends BodyComponent {
  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(Vector2(-10, -5), Vector2(10, -5)); // Tamaño del suelo
    final fixtureDef = FixtureDef(shape);
    final bodyDef = BodyDef()
      ..position = Vector2.zero()
      ..type = BodyType.static; // El suelo no se mueve
    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef);
    return body;
  }
}