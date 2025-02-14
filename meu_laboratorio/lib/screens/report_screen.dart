import 'package:flutter/material.dart';
import '../models/item.dart';
import '../database/database_helper.dart';
import '../utils/pdf_generator.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerar Relatório PDF'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            List<Item> items = await DatabaseHelper().getItems();
            PdfGenerator.generatePdf(items);
          },
          child: Text('Gerar Relatório'),
        ),
      ),
    );
  }
}