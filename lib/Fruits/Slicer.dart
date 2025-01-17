import 'package:flame/forge2d/forge2d_game.dart';
import 'package:flame/input.dart';

class Slicer extends Component with HasGameRef<Forge2DGame> {
  @override
  bool onDragUpdate(DragUpdateInfo info) {
    final dragPath = info.eventPosition.game;
    gameRef.world.forEachBody((body) {
      for (final fixture in body.fixtures) {
        if (fixture.testPoint(dragPath)) {
          gameRef.remove(body.userData as Component?);
        }
      }
    });
    return super.onDragUpdate(info);
  }
}