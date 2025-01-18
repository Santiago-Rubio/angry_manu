import 'dart:math';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart' hide Transform;
import '../Components/Fruit.dart';
import '../Components/FruitPart.dart';
import '../Components/Slicer.dart';
import 'SlicePainter.dart';

class CanvasArea extends StatefulWidget {
  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  int _score = 0;
  Slicer? _touchSlice;
  final List<Fruit> _fruits = <Fruit>[];
  final List<FruitPart> _fruitParts = <FruitPart>[];

  late World world; // Mundo físico de Forge2D
  late Size screenSize; // Para almacenar el tamaño de la pantalla

  @override
  void initState() {

    super.initState();
    world = World(Vector2(0, 15.8)); // Gravedad de 9.8 m/s²

    // Usamos addPostFrameCallback para obtener el tamaño de la pantalla después de que el árbol de widgets haya sido construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var screenSize = MediaQuery.of(context).size;
      _spawnRandomFruit();
      _tick();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accede a MediaQuery en didChangeDependencies
    screenSize = MediaQuery.of(context).size;
  }

  int _fruitCount = 0;

  void _spawnRandomFruit() {
    if (_fruitCount >= 5) {
      return;
    }

    // Obtener el tamaño de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Posición de inicio de la fruta (en la parte inferior)
    final randomPositionX = Random().nextDouble() * screenWidth;
    final randomDirectionX = (Random().nextDouble() - 0.5) * 6.0; // Movimiento aleatorio horizontal
    final randomDirectionY = -Random().nextDouble() * 5.0 - 5.0; // Movimiento hacia arriba más rápido

    // Definición del cuerpo en el mundo físico
    final bodyDef = BodyDef()
      ..position = Vector2(randomPositionX, screenHeight) // Posición inicial en la parte inferior
      ..type = BodyType.dynamic;

    final body = world.createBody(bodyDef);

    // Creación de la forma de la fruta (círculo)
    final shape = CircleShape()..radius = 40.0;
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5; // Bounciness (rebote)

    body.createFixture(fixtureDef);

    // Velocidad inicial aleatoria (lanzamiento parabólico)
    body.linearVelocity.setValues(randomDirectionX * 15.0, randomDirectionY * 15.0);

    setState(() {
      // Agregar la fruta a la lista de frutas
      _fruits.add(Fruit(
        body: body,
        width: 80,
        height: 80,
        rotation: Random().nextDouble(),
      ));
      _fruitCount++;
    });
  }

  void _updateFruits() {
    setState(() {
      _fruits.removeWhere((fruit) {
        final position = fruit.body?.position;
        if (position != null &&
            (position.x < 0 || position.x > screenSize.width || position.y < 0 || position.y > screenSize.height)) {
          if (fruit.body != null) {
            world.destroyBody(fruit.body!); // Eliminar cuerpo de la fruta cuando sale de los límites
          }
          _fruitCount--;  // Reducir el contador de frutas
          return true;
        }
        return false;
      });
    });
  }

  void _cutFruit(Fruit fruit) {
    setState(() {
      _fruits.remove(fruit);
      if (fruit.body != null) {
        world.destroyBody(fruit.body!); // Eliminar cuerpo cuando se corta
      }
      _fruitCount--;  // Reducir el contador de frutas
    });
  }

  // Método para actualizar el mundo de Forge2D
  void _tick() {
    world.stepDt(1 / 60); // Avanza la simulación de la física (60 FPS)

    // Actualizamos las frutas según el mundo físico
    setState(() {
      for (Fruit fruit in _fruits) {
        fruit.updatePosition();  // Actualiza la posición de cada fruta
      }
    });

    // Llamar a _updateFruits para eliminar frutas fuera de los límites
    _updateFruits();

    // Generamos una nueva fruta cada 2 segundos
    Future.delayed(Duration(seconds: 2), () {
      _spawnRandomFruit();
    });

    // Llamamos a _tick cada 30 ms para continuar con la simulación
    Future<void>.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getStack(),
    );
  }

  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = <Widget>[];

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getFruitParts());
    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());
    widgetsOnStack.add(Positioned(
      right: 16,
      top: 16,
      child: Text(
        'Score: $_score',
        style: TextStyle(fontSize: 24),
      ),
    ));

    return widgetsOnStack;
  }

  Container _getBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          stops: <double>[0.2, 1.0],
          colors: <Color>[Color(0xffFFB75E), Color(0xffED8F03)],
        ),
      ),
    );
  }

  Widget _getSlice() {
    if (_touchSlice == null) {
      return Container();
    }

    return CustomPaint(
      size: Size.infinite,
      painter: SlicePainter(
        pointsList: _touchSlice!.pointsList,
      ),
    );
  }

  List<Widget> _getFruits() {
    List<Widget> list = <Widget>[];

    for (Fruit fruit in _fruits) {
      final worldPos = fruit.body?.position;

      list.add(
        Positioned(
          top: worldPos?.y,
          left: worldPos?.x,
          child: Transform.rotate(
            angle: fruit.rotation,
            child: _getMelon(fruit),
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> _getFruitParts() {
    List<Widget> list = <Widget>[];

    for (FruitPart fruitPart in _fruitParts) {
      list.add(
        Positioned(
          top: fruitPart.position.dy,
          left: fruitPart.position.dx,
          child: _getMelonCut(fruitPart),
        ),
      );
    }

    return list;
  }

  Widget _getMelon(Fruit fruit) {
    return Image.asset(
      'assets/melon_uncut.png',
      height: 80,
      fit: BoxFit.fitHeight,
    );
  }

  Widget _getMelonCut(FruitPart fruitPart) {
    return Transform.rotate(
      angle: fruitPart.rotation * pi * 2,
      child: Image.asset(
        fruitPart.isLeft
            ? 'assets/melon_cut.png'
            : 'assets/melon_cut_right.png',
        height: 80,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        setState(() => _setNewSlice(details));
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _addPointToSlice(details);
          _checkCollision();
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() => _resetSlice());
      },
    );
  }

  void _checkCollision() {
    if (_touchSlice == null) {
      return;
    }

    for (Fruit fruit in List<Fruit>.from(_fruits)) {
      bool firstPointOutside = false;
      bool secondPointInside = false;

      for (Offset point in _touchSlice!.pointsList) {
        if (!firstPointOutside && !fruit.isPointInside(point)) {
          firstPointOutside = true;
          continue;
        }

        if (firstPointOutside && fruit.isPointInside(point)) {
          secondPointInside = true;
          continue;
        }

        if (secondPointInside && !fruit.isPointInside(point)) {
          _cutFruit(fruit);
          _fruits.remove(fruit);
          _turnFruitIntoParts(fruit);
          _score += 10;
          break;
        }
      }
    }
  }

  void _turnFruitIntoParts(Fruit hit) {
    FruitPart leftFruitPart = FruitPart(
      position: Offset(
        hit.body!.position.x - hit.width / 8,
        hit.body!.position.y,
      ),
      width: hit.width / 2,
      height: hit.height,
      isLeft: true,
      gravitySpeed: hit.body!.linearVelocity.length,
      additionalForce: Offset(0, 0),
      rotation: hit.rotation,
    );

    FruitPart rightFruitPart = FruitPart(
      position: Offset(
        hit.body!.position.x + hit.width / 4 + hit.width / 8,
        hit.body!.position.y,
      ),
      width: hit.width / 2,
      height: hit.height,
      isLeft: false,
      gravitySpeed: hit.body!.linearVelocity.length,
      additionalForce: Offset(0, 0),
      rotation: hit.rotation,
    );

    setState(() {
      _fruitParts.add(leftFruitPart);
      _fruitParts.add(rightFruitPart);
      _fruits.remove(hit);
    });
  }

  void _resetSlice() {
    _touchSlice = null;
  }

  void _setNewSlice(ScaleStartDetails details) {
    _touchSlice = Slicer(startOffset: details.localFocalPoint);
  }

  void _addPointToSlice(ScaleUpdateDetails details) {
    if (_touchSlice == null) return;
    _touchSlice!.pointsList.add(details.localFocalPoint);
  }
}
