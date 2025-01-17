import 'package:flame/components.dart';
import 'package:flame/forge2d/forge2d_component.dart';
import 'package:flame/forge2d/position_body_component.dart';


class Fruit extends PositionBodyComponent {
  final Vector2 position;

  Fruit(this.position) : super(paint: Paint()..color = const Color(0xFF00FF00));

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = position;

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = 0.5; // Tamaño de la fruta.
    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.5 // Rebote
      ..density = 1.0
      ..friction = 0.2;

    body.createFixture(fixtureDef);
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset.zero, 50, paint); // Dibujar la fruta.
  }
}
