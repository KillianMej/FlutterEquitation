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
