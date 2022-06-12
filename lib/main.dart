import 'package:flutter/material.dart';
import 'package:tv_maze/lock_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Maze',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LockScreen(),
    );
  }
}
