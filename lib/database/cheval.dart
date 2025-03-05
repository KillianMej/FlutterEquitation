import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

enum Sexe { M, F }

class Cheval {
  final int? id;
  final String photo;
  final String nom;
  final int age;
  final String robe;
  final String race;
  final Sexe sexe;
  final int specialiteId;
  final int utilisateurId;

  const Cheval({
    this.id,
    required this.photo,
    required this.nom,
    required this.age,
    required this.robe,
    required this.race,
    required this.sexe,
    required this.specialiteId,
    required this.utilisateurId,
  });

  Map<String, Object?> toMap() {
    return {
      "photo": photo,
      "nom": nom,
      "age": age,
      "robe": robe,
      "race": race,
      "sexe": sexe,
      "specialite_id": specialiteId,
      "utilisateur_id": utilisateurId,
    };
  }

  @override
  String toString() {
    return 'Cheval{id: $id, photo: $photo, nom: $nom, age: $age, robe: $robe,race: $race, sexe: $sexe, specialite_id: $specialiteId, utilisateur_id: $utilisateurId}';
  }
}

Future<void> insertCheval(Cheval cheval) async{
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'cheval',
    cheval.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Cheval?> getChevalById(int id) async{
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'cheval',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Cheval(
    id: maps.first['id'],
    photo: maps.first['photo'],
    nom: maps.first['nom'],
    age: maps.first['age'],
    robe: maps.first['robe'],
    race: maps.first['race'],
    sexe: maps.first['sexe'] == 'M' ? Sexe.M : Sexe.F,
    specialiteId: maps.first['specialite_id'],
    utilisateurId: maps.first['utilisateur_id'],
  );
}