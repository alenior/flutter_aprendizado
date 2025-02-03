import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Construtor com acesso privado
  DB._();
  // Criar uma instância de DB
  static final DB instance = DB._();
  // Instância do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'meu_laboratorio.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }
}
