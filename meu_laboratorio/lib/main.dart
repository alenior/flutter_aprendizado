import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io'; // Para usar a classe Platform
import '../screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configura a databaseFactory para desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi;
  }

  // Inicializa o sqflite
  await initializeSqflite();

  runApp(MyApp());
}

Future<void> initializeSqflite() async {
  // Configura o caminho do banco de dados
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'meu_laboratorio.db');

  // Abre o banco de dados (ou cria se não existir)
  await openDatabase(path, version: 1, onCreate: _onCreate);
}

Future<void> _onCreate(Database db, int version) async {
  // Cria a tabela de itens
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Laboratório',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}