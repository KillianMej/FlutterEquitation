import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Participant {
  final int? id;
  final int? coursId;
  final int? concoursId;
  final int? soireeId;
  final int utilisateurId;
  final String commentaire;

  const Participant({
    this.id,
    this.coursId,
    this.concoursId,
    this.soireeId,
    required this.utilisateurId,
    required this.commentaire,
  }); 

  Map<String, Object?> toMap() {
    return {
      "cours_id": coursId,
      "concours_id": concoursId,
      "soiree_id": soireeId,
      "utilisateur_id": utilisateurId,
      "commentaire": commentaire,
    };
  }

  @override
  String toString() {
    return 'Participant{id: $id, cours_id: $coursId, concours_id: $concoursId, soiree_id: $soireeId, utilisateur_id: $utilisateurId, commentaire: $commentaire}';
  }
}

Future<void> insertParticipant(Participant participant) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  await database.insert(
    'participant',
    participant.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<Participant?> getParticipantById(int id) async{
  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
  );

  final List<Map<String, dynamic>> maps = await database.query(
    'participant',
    where: 'id = ?',
    whereArgs: [id],
  );

  if (maps.isEmpty) {
    return null;
  }

  return Participant(
    id: maps.first['id'],
    coursId: maps.first['cours_id'],
    concoursId: maps.first['concours_id'],
    soireeId: maps.first['soiree_id'],
    utilisateurId: maps.first['utilisateur_id'],
    commentaire: maps.first['commentaire'],
  );
}