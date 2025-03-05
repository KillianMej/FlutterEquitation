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