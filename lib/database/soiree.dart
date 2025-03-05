
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Soiree {
  final int? id;
  final int themeId;
  final String photo;
  final int valide;

  const Soiree({
    this.id,
    required this.themeId,
    required this.photo,
    this.valide = 0,
  });

  Map<String, Object?> toMap() {
    return {
      "theme_id": themeId,
      "photo": photo,
      "valide": valide,
    };
  }

  @override
  String toString() {
    return 'Soiree{id: $id, theme_id: $themeId, photo: $photo, valide: $valide}';
  }
}

Future<void> insertSoiree(Soiree soiree) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'soiree',
    soiree.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Soiree?> getSoireeById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'soiree',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Soiree(
    id: maps.first['id'],
    themeId: maps.first['theme_id'],
    photo: maps.first['photo'],
    valide: maps.first['valide'],
  );
}