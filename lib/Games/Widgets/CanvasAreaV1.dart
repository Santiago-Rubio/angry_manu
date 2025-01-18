import 'dart:math';
import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart'hide Transform;
import '../Components/Fruit.dart';
import '../Components/FruitPart.dart';
import '../Components/Slicer.dart';
import 'SlicePainter.dart';


class CanvasAreaV1 extends StatefulWidget {
  @override
  _CanvasAreaState createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasAreaV1> {
  int _score = 0;
  Slicer? _touchSlice;
  final List<Fruit> _fruits = <Fruit>[];
  final List<FruitPart> _fruitParts = <FruitPart>[];

  late World world; // Mundo físico de Forge2D

  @override
  void initState() {
    super.initState();
    world = World(Vector2(0, 15.8)); // Gravedad de 9.8 m/s²

    _spawnRandomFruit();
    _tick();
  }

  // Método para generar frutas en el mundo físico
  void _spawnRandomFruit() {
    final randomPositionX = Random().nextDouble() * 300.0; // Posición aleatoria en el eje X
    final randomDirectionX = (Random().nextDouble() - 0.5) * 4.0; // Dirección aleatoria (izquierda/derecha)
    final randomDirectionY = Random().nextDouble() * -4.0 - 2.0; // Movimiento hacia arriba (valores negativos para ir arriba)

    // Reducción de las sandías, la probabilidad es más baja
    //final fruitType = Random().nextDouble() > 0.2 ? 'melon' : 'watermelon'; // 80% melón, 20% sandía para si metos bombas o algo

    final bodyDef = BodyDef()
      ..position = Vector2(randomPositionX, 300) // La fruta empieza en una posición aleatoria
      ..type = BodyType.dynamic; // Cuerpo dinámico, sujeto a la gravedad

    final body = world.createBody(bodyDef);

    final shape = CircleShape()  // Forma circular para la fruta
      ..radius = 40.0;

    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.3
      ..restitution = 0.5;  // Rebote de la fruta

    body.createFixture(fixtureDef);

    // Establecemos las velocidades iniciales
    body.linearVelocity.setValues(randomDirectionX * 10.0, randomDirectionY * 10.0);

    setState(() {
      _fruits.add(Fruit(
        body: body,
        width: 80,
        height: 80,
        rotation: Random().nextDouble(),
        //type: fruitType,  // Asignamos el tipo de fruta aquí
      ));
    });
  }

  // Método para actualizar el mundo de Forge2D
  void _tick() {
    world.stepDt(1 / 60); // Avanza la simulación de la física (60 FPS)

    setState(() {
      // Actualizamos las frutas según el mundo físico
      // Ahora se actualizan las posiciones y los valores de las frutas
      for (Fruit fruit in _fruits) {
        // Actualizamos la posición de la fruta
        fruit.updatePosition();
      }
    });
// Generamos una nueva fruta cada 2 segundos
    Future.delayed(Duration(seconds: 2), () {
      _spawnRandomFruit();
    });

    Future<void>.delayed(Duration(milliseconds: 30), _tick);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _getStack(),
    );
  }

  // Método para construir el widget con todas las capas
  List<Widget> _getStack() {
    List<Widget> widgetsOnStack = <Widget>[];

    widgetsOnStack.add(_getBackground());
    widgetsOnStack.add(_getSlice());
    widgetsOnStack.addAll(_getFruitParts());
    widgetsOnStack.addAll(_getFruits());
    widgetsOnStack.add(_getGestureDetector());
    widgetsOnStack.add(

      Positioned(
        right: 16,
        top: 16,
        child: Text(
          'Score: $_score',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );

    return widgetsOnStack;
  }

  // Fondo de la pantalla
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

  // Pintamos el corte
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

  // Mostrar las frutas en el mundo físico
  List<Widget> _getFruits() {
    List<Widget> list = <Widget>[];

    for (Fruit fruit in _fruits) {
      final worldPos = fruit.body?.position;  // Usa la posición del cuerpo

      // Determina la imagen según el tipo de fruta
      //String fruitImage = fruit.type == 'melon'
          //? 'assets/melon_uncut.png'
          //: 'assets/watermelon_uncut.png'; // Cambiar según el tipo de fruta

    // Agregar la fruta a la lista de widgets
      list.add(
        Positioned(
          top: worldPos?.y,
          left: worldPos?.x,
          child: Transform.rotate(
            angle: fruit.rotation,  // Usamos la rotación que se actualiza
            child: _getMelon(fruit),
          ),
        ),
      );
    }

    return list;
  }

  // Mostrar las partes de la fruta después de cortarla
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

  // Crear una representación de la fruta
  Widget _getMelon(Fruit fruit) {
    return Image.asset(
      'assets/melon_uncut.png',
      height: 80,
      fit: BoxFit.fitHeight,
    );
  }

  // Crear una parte de la fruta
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

  // Gestos del usuario para cortar la fruta
  Widget _getGestureDetector() {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        setState(() => _setNewSlice(details));
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(
              () {
            _addPointToSlice(details);
            _checkCollision();
          },
        );
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() => _resetSlice());
      },
    );
  }

  // Comprobar si el corte ha tocado alguna fruta
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
          _fruits.remove(fruit);
          _turnFruitIntoParts(fruit);
          _score += 10;
          break;
        }
      }
    }
  }

  // Transformar la fruta en partes cuando se corta
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

  // Resetear el corte
  void _resetSlice() {
    _touchSlice = null;
  }

  // Iniciar el corte
  void _setNewSlice(ScaleStartDetails details) {
    _touchSlice = Slicer(startOffset: details.localFocalPoint);
  }

  // Agregar un punto al corte
  void _addPointToSlice(ScaleUpdateDetails details) {
    if (_touchSlice == null) return;
    _touchSlice!.pointsList.add(details.localFocalPoint);
  }
}
