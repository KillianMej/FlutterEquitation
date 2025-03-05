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