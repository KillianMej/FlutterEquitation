import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Concours {
  final int? id;
  final String nom;
  final String? adresse;
  final String photo;
  final DateTime date;
  final int niveauId;

  const Concours({
    this.id,
    required this.nom,
    required this.adresse,
    required this.photo,
    required this.date,
    required this.niveauId,
  });

  Map<String, Object?> toMap() {
    return {
      "nom": nom,
      "adresse": adresse,
      "photo": photo,
      "date": date.toIso8601String(),
      "niveau_id": niveauId,
    };
  }

  @override
  String toString() {
    return 'Concours{id: $id, nom: $nom, adresse: $adresse, photo: $photo, date: $date, niveau_id: $niveauId}';
  }
}

Future<void> insertConcours(Concours concours) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'concours',
    concours.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Concours?> getConcoursById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'concours',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Concours(
    id: maps.first['id'],
    nom: maps.first['nom'],
    adresse: maps.first['adresse'],
    photo: maps.first['photo'],
    date: DateTime.parse(maps.first['date']),
    niveauId: maps.first['niveau_id'],
  );
}

  Future<List<Concours>> getConcours() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
    );

    final List<Map<String, dynamic>> maps = await database.query('concours');

    return List.generate(maps.length, (i) {
      return Concours(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        adresse: maps[i]['adresse'],
        photo: maps[i]['photo'],
        date: DateTime.parse(maps[i]['date']),
        niveauId: maps[i]['niveau_id'],
      );
    });
  }



