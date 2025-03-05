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
  final bool gerant;

  const Utilisateur({
    this.id,
    required this.nom,
    required this.email,
    required this.mot_de_passe,
    required this.numero,
    required this.age,
    required this.ffe,
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
      "gerant": gerant ? 1 : 0
    };
  }

  @override
  String toString() {
    return 'Utilisateur{id: $id, nom: $nom, email: $email, mot_de_passe: $mot_de_passe, numero: $numero, age: $age, ffe: $ffe, gerant: $gerant}';
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