import 'package:flutter/material.dart';
import 'package:projeto_aprendizado/home_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red, 
      brightness: Brightness.light),
      home: HomePage(),
    );
  }
}
