import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Specialite {
  final int? id;
  final String nom;

  const Specialite({
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
    return 'Specialite{id: $id, nom: $nom}';
  }
}

Future<void> insertSpecialite(Specialite specialite) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'specialites',
    specialite.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Specialite?> getSpecialiteById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'specialites',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Specialite(
    id: maps.first['id'],
    nom: maps.first['nom'],
  );
}

Future<List<Specialite>> getSpecialites() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query('specialites');

  return List.generate(maps.length, (i) {
    return Specialite(
      id: maps[i]['id'],
      nom: maps[i]['nom'],
    );
  });
}