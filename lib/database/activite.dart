import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Activite {
  final int? id;
  final String titre;
  final String description;
  final DateTime date;
  final String type;

  Activite({
    this.id,
    required this.titre,
    required this.description,
    required this.date,
    required this.type,
  });

  // Convertir un objet en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  // Convertir un enregistrement SQLite en objet Activite
  factory Activite.fromMap(Map<String, dynamic> map) {
    return Activite(
      id: map['id'],
      titre: map['titre'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      type: map['type'],
    );
  }
}

// 🔹 Récupérer toutes les activités
Future<List<Activite>> getFluxActualite() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'activite',
    orderBy: 'date DESC',
  );

  await database.close();

  print("📋 Activités récupérées: ${maps.length}");

  return List.generate(maps.length, (i) => Activite.fromMap(maps[i]));
}

// ✅ Ajouter une activité
Future<void> ajouterActivite(Activite activite) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  int id = await database.insert(
    'activite',
    activite.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await database.close();

  print("✅ Activité ajoutée avec ID: $id");
}
