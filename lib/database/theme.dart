import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Theme {
  final int? id;
  final String nom;

  const Theme({
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
    return 'Theme{id: $id, nom: $nom}';
  }
}

Future<void> insertTheme(Theme theme) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'theme',
    theme.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Theme?> getThemeById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'theme',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Theme(
    id: maps.first['id'],
    nom: maps.first['nom'],
  );
}

Future<List<Theme>> getThemes() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query('theme');

  return List.generate(maps.length, (i) {
    return Theme(
      id: maps[i]['id'],
      nom: maps[i]['nom'],
    );
  });
}