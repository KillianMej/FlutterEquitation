import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dp {
  final int? id;
  final int chevalId;
  final int utilisateurId;

  const Dp({
    this.id,
    required this.chevalId,
    required this.utilisateurId,
  });

  Map<String, Object?> toMap() {
    return {
      "cheval_id": chevalId,
      "utilisateur_id": utilisateurId,
    };
  }

  @override
  String toString() {
    return 'Dp{id: $id, cheval_id: $chevalId, utilisateur_id: $utilisateurId}';
  }
}

Future<void> insertDp(Dp dp) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'dp',
    dp.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Dp?> getDpById(int id) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'dp',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Dp(
    id: maps.first['id'],
    chevalId: maps.first['cheval_id'],
    utilisateurId: maps.first['utilisateur_id'],
  );
}