import 'package:flutter/material.dart';
import '../models/item.dart';
import '../database/database_helper.dart';
import 'item_form_screen.dart';
import '../widgets/item_card.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  ItemListScreenState createState() => ItemListScreenState();
}

class ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Item>> _itemsFuture;
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Função para carregar os itens do banco de dados
  void _loadItems() {
    setState(() {
      _itemsFuture = DatabaseHelper().getItems().then((items) {
        _allItems = items;
        _filteredItems = items; // Inicializa com todos os itens
        return items;
      });
    });
  }

  // Função para filtrar os itens com base na pesquisa
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens Cadastrados'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemFormScreen()),
              );

              if (updated == true) {
                _loadItems(); // Atualiza a lista após adição de item
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar por nome ou descrição',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Item>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar itens'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum item cadastrado'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      Item item = _filteredItems[index];
                      return GestureDetector(
                        onTap: () async {
                          bool? updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemFormScreen(item: item),
                            ),
                          );

                          if (updated == true) {
                            _loadItems(); // Atualiza a lista após edição do item
                          }
                        },
                        child: ItemCard(
                          item: item,
                          refreshItems: _loadItems,
                          itemCode: index + 1,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
