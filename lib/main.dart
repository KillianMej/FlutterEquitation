import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/utilisateur.dart';

Future<void> initDb() async {
  sqfliteFfiInit();
  // Change the default factory to FFI
  databaseFactory = databaseFactoryFfi;

  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE utilisateur(id INTEGER PRIMARY KEY AUTOINCREMENT, nom VARCHAR(100) NOT NULL, email VARCHAR(255) UNIQUE NOT NULL, mot_de_passe VARCHAR(255) NOT NULL, numero VARCHAR(20), age INT, ffe VARCHAR(255), gerant BOOLEAN)',
      );
    },
    version: 1,
  );
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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
