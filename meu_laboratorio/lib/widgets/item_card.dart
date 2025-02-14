import 'dart:io'; // Importação necessária para usar a classe File
import 'package:flutter/material.dart';
import '../models/item.dart';
import '../database/database_helper.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Function refreshItems;

  const ItemCard({super.key, required this.item, required this.refreshItems});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: item.imagePath.isNotEmpty
            ? Image.file(File(item.imagePath), width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.image),
        title: Text(item.name),
        subtitle: Text(item.description),
        trailing: Text('Quantidade: ${item.quantity}'),
        onTap: () {
          // Implementar edição do item
        },
        onLongPress: () async {
          await DatabaseHelper().deleteItem(item.id!);
          refreshItems();
        },
      ),
    );
  }
}