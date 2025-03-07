import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Utilisateur {
  final int? id;
  final String nom;
  final String email;
  final String mot_de_passe;
  final String numero;
  final int age;
  final String ffe;
  final String? photo;
  final bool gerant;

  const Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.mot_de_passe,
    required this.numero,
    required this.age,
    required this.ffe,
    this.photo,
    required this.gerant
  });

  Map<String, Object?> toMap() {
    return {
      "nom": nom,
      "email": email,
      "mot_de_passe": mot_de_passe,
      "numero": numero,
      "age": age,
      "ffe": ffe,
      "photo": photo,
      "gerant": gerant ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'Utilisateur{id: $id, nom: $nom, email: $email, mot_de_passe: $mot_de_passe, numero: $numero, age: $age, ffe: $ffe,photo: $photo, gerant: $gerant}';
  }
}

Future<void> insertUtilisateur(Utilisateur utilisateur) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'utilisateur',
    utilisateur.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Utilisateur?> getUtilisateurById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'utilisateur',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Utilisateur(
    id: maps.first['id'],
    nom: maps.first['nom'],
    email: maps.first['email'],
    mot_de_passe: maps.first['mot_de_passe'],
    numero: maps.first['numero'],
    age: maps.first['age'],
    ffe: maps.first['ffe'],
    photo: maps.first['photo'],
    gerant: maps.first['gerant'] == 1,
  );
}

Future<List<Utilisateur>> getUtilisateurs() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query('utilisateur');

  // Convertir les résultats de la requête en une liste d'objets Utilisateur
  return List.generate(maps.length, (i) {
    return Utilisateur(
      id: maps[i]['id'],
      nom: maps[i]['nom'],
      email: maps[i]['email'],
      mot_de_passe: maps[i]['mot_de_passe'],
      numero: maps[i]['numero'],
      age: maps[i]['age'],
      ffe: maps[i]['ffe'],
      photo: maps[i]['photo'],
      gerant: maps[i]['gerant'] == 1,
    );
  });
}
