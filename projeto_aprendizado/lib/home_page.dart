import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'), 
        backgroundColor: Colors.red,),
      
      body: Container(
        width: 200,
        height: 200,
        color: Colors.blueGrey,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
              counter++;
            });
        },
      ),
      
    );
  }
}
