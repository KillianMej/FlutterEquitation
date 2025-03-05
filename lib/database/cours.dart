import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum Terrain { carriere, manege }

class Cours {
  final int? id;
  final Terrain terrain;
  final DateTime date;
  final int duree;
  final int specialiteId;
  final int valide;

  const Cours({
    this.id,
    required this.terrain,
    required this.date,
    required this.duree,
    required this.specialiteId,
    this.valide = 0,
  });

  Map<String, Object?> toMap() {
    return {
      "terrain": terrain.index,
      "date": date.toIso8601String(),
      "duree": duree,
      "specialite_id": specialiteId,
      "valide": valide,
    };
  }

  @override
  String toString() {
    return 'Cours{id: $id, terrain: $terrain, date: $date, duree: $duree, specialite_id: $specialiteId, valide: $valide}';
  }
}

Future<void> insertCours(Cours cours) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'cours',
    cours.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
