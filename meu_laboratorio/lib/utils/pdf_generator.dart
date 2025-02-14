import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/item.dart';

class PdfGenerator {
  static Future<void> generatePdf(List<Item> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text('Relatório de Itens')),
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['Nome', 'Descrição', 'Valor', 'Quantidade'],
                  ...items.map((item) => [item.name, item.description, item.value.toString(), item.quantity.toString()]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/relatorio.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}