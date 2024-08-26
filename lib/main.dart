import 'package:flutter/material.dart';
import 'package:wordwizz/components/navigation_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kursy Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavigationBarScreen(),
    );
  }
}

