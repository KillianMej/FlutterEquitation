import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/utilisateur.dart';
import 'pages/register.dart';


Future<void> initDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = join(await getDatabasesPath(), 'database.db');
  print("📂 La base de données sera créée à : $dbPath");

  final database = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      print("🛠 Création de la table utilisateur...");
      await db.execute(
        'CREATE TABLE utilisateur('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'nom TEXT NOT NULL, '
            'email TEXT UNIQUE NOT NULL, '
            'mot_de_passe TEXT NOT NULL, '
            'numero TEXT, '
            'age INTEGER, '
            'ffe TEXT, '
            'gerant BOOLEAN'
            ')',
      );
      print("✅ Table utilisateur créée !");
    },
  );

  print("🚀 Base de données prête !");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDb();

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _insertInitialUser();
  }

  Future<void> _insertInitialUser() async {
    final jaque = Utilisateur(
      nom: "Jaque",
      email: "jaque@gmail.com",
      mot_de_passe: "test",
      numero: "0606060606",
      age: 25,
      ffe: "123456",
      gerant: true,
    );

    await insertUtilisateur(jaque);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(), // Définir directement RegisterPage comme écran d'accueil
    );
  }
}
