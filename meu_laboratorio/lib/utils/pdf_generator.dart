import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/item.dart';

class PdfGenerator {
  static Future<void> generatePdf(List<Item> items) async {
    try {
      // Criar o documento PDF
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Relatório de Itens',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  headers: ['Nome', 'Descrição', 'Valor', 'Quantidade'],
                  data: items.map((item) => [
                    item.name,
                    item.description,
                    item.value.toString(),
                    item.quantity.toString(),
                  ]).toList(),
                  headerStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: pw.TextStyle(fontSize: 12),
                  border: pw.TableBorder.all(),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
              ],
            );
          },
        ),
      );

      // Salvar o arquivo no diretório apropriado
      final output = await getExternalStorageDirectory();
      if (output == null) {
        print("Erro: Diretório de armazenamento externo não encontrado.");
        return;
      }

      final file = File('${output.path}/relatorio.pdf');
      await file.writeAsBytes(await pdf.save());

      print("PDF gerado em: ${file.path}");

      // Verificar se o arquivo foi realmente gerado e existe
      if (await file.exists()) {
        print("Arquivo encontrado, tentando abrir...");
        // Abrir o PDF no dispositivo
        await openPdf(file.path);

        // Compartilhar o arquivo
        await sharePdf(file.path);
      } else {
        print("Erro: Arquivo não encontrado.");
      }
    } catch (e) {
      print("Erro ao gerar PDF: $e");
    }
  }

  static Future<void> openPdf(String filePath) async {
    // Aguarda a abertura do arquivo
    final result = await OpenFile.open(filePath);
    print(result);
  }

  static Future<void> sharePdf(String filePath) async {
    // Compartilha o arquivo gerado
    await Share.shareXFiles([XFile(filePath)]);
  }
}
