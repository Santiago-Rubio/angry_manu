import 'package:flutter/material.dart';

import 'Games/Widgets/CanvasArea.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Slice',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fruit Slice Game'),
          backgroundColor: Colors.orange,
        ),
        body: CanvasArea(),  // El área de dibujo con las frutas y la física
      ),
    );
  }
}