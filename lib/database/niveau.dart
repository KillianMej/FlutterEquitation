import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Niveau {
  final int? id;
  final String nom;

  const Niveau({
    this.id,
    required this.nom,
  });

  Map<String, Object?> toMap() {
    return {
      "nom": nom,
    };
  }

  @override
  String toString() {
    return 'Niveau{id: $id, nom: $nom}';
  }
}

Future<void> insertNiveau(Niveau niveau) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'niveau',
    niveau.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Niveau?> getNiveauById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'niveau',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Niveau(
    id: maps.first['id'],
    nom: maps.first['nom'],
  );
}