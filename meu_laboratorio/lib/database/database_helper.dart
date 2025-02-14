import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meu_laboratorio.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        value REAL,
        quantity INTEGER,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    Database db = await database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getItems() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<List<Item>> searchItems(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(Item item) async {
    Database db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}