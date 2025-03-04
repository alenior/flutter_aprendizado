import 'dart:io'; // Importação necessária para usar a classe File
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importação para formatação correta
import '../models/item.dart';
import '../database/database_helper.dart';
import '../screens/item_form_screen.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Function refreshItems;

  const ItemCard({super.key, required this.item, required this.refreshItems});

  @override
  Widget build(BuildContext context) {
    // Formatação do preço para o padrão brasileiro (R$ 1.234,56)
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: item.imagePath.isNotEmpty
            ? Image.file(File(item.imagePath), width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.image),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description),
            Text('Valor: ${currencyFormat.format(item.value)}'), // Agora usa 'value' corretamente
          ],
        ),
        trailing: Text('Qtd: ${item.quantity}'),
        onTap: () async {
          bool? updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemFormScreen(item: item), // Passando o item para edição
            ),
          );

          if (updated == true) {
            refreshItems(); // Atualiza a lista se o item foi editado
          }
        },
        onLongPress: () async {
          await DatabaseHelper().deleteItem(item.id!);
          refreshItems();
        },
      ),
    );
  }
}
