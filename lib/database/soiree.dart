import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Soiree {
  final int? id;
  final int themeId;
  final DateTime date;
  final String? photo;
  final int valide;

  const Soiree({
    this.id,
    required this.themeId,
    required this.date,
    this.photo,
    this.valide = 0,
  });

  Map<String, Object?> toMap() {
    return {
      "theme_id": themeId,
      "date": date.toIso8601String(), // Convertir DateTime en chaîne de caractères
      "photo": photo,
      "valide": valide,
    };
  }

  @override
  String toString() {
    return 'Soiree{id: $id, theme_id: $themeId, date: $date, photo: $photo, valide: $valide}';
  }

  static Soiree fromMap(Map<String, dynamic> map) {
    return Soiree(
      id: map['id'],
      themeId: map['theme_id'],
      date: DateTime.parse(map['date']), // Convertir chaîne de caractères en DateTime
      photo: map['photo'],
      valide: map['valide'],
    );
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

  return Soiree.fromMap(maps.first);
}

Future<List<Soiree>> getSoiree() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query('soiree');

  return List.generate(maps.length, (i) {
    return Soiree.fromMap(maps[i]);
  });
}