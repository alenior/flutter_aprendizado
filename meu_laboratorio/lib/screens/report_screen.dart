import 'package:flutter/material.dart';
import 'package:meu_laboratorio/utils/pdf_generator.dart';
import '../models/item.dart';
import '../database/database_helper.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerar Relatório PDF')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Buscar os itens no banco de dados
              List<Item> items = await DatabaseHelper().getItems();
              if (items.isEmpty) {
                // Mostrar uma mensagem para o usuário
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Nenhum item encontrado para gerar o relatório'),
                  ),
                );
              } else {
                // Gerar o PDF e abrir no app
                await PdfGenerator.generatePdf(items);
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao buscar itens: $e')),
              );
            }
          },
          child: Text('Gerar Relatório'),
        ),
      ),
    );
  }
}
