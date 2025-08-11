import 'package:flutter/material.dart';

class DraggableFabScreen extends StatefulWidget {
  const DraggableFabScreen({Key? key}) : super(key: key);

  @override
  State<DraggableFabScreen> createState() => _DraggableFabScreenState();
}

class _DraggableFabScreenState extends State<DraggableFabScreen> {
  double _fabTop = 100.0; // Initial top position
  double _fabLeft = 100.0; // Initial left position

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draggable FAB')),
      body: Stack(
        children: [
          // Other content of your screen

        ],
      ),
    );
  }
}