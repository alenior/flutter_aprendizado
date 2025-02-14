import 'package:flutter/material.dart';
import 'item_list_screen.dart';
import 'item_form_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Laboratório'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemListScreen()),
                );
              },
              child: Text('Ver Itens'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemFormScreen()),
                );
              },
              child: Text('Adicionar Item'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreen()),
                );
              },
              child: Text('Gerar Relatório PDF'),
            ),
          ],
        ),
      ),
    );
  }
}