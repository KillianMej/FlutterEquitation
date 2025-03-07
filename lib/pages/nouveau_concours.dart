import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../database/concours.dart';
import '../database/participant.dart';

class NouveauConcours extends StatefulWidget {
  @override
  _NouveauConcoursState createState() => _NouveauConcoursState();
}

class _NouveauConcoursState extends State<NouveauConcours> {
  final List<String> niveaux = ["Amateur", "Club1", "Club2", "Club3", "Club4"];
  final _concoursFormKey = GlobalKey<FormState>();
  String? _nomConcours, _adresseConcours, _selectedNiveau = "Amateur", _participant;
  DateTime? _selectedDate;
  List<String> participants = [];

  Future<int> insertConcours(Concours concours) async {
    final db = await openDatabase(join(await getDatabasesPath(), 'database.db'));
    return await db.insert('concours', concours.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertParticipant(Participant participant) async {
    final db = await openDatabase(join(await getDatabasesPath(), 'database.db'));
    await db.insert('participant', participant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _saveConcours(BuildContext context) async {
    if (_selectedDate == null || _nomConcours == null || _adresseConcours == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tous les champs sont requis')));
      return;
    }

    final niveauId = ["Amateur", "Club1", "Club2", "Club3", "Club4"].indexOf(_selectedNiveau!) + 1;
    final concours = Concours(nom: _nomConcours!, adresse: _adresseConcours!, photo: "", date: _selectedDate!, niveauId: niveauId);

    try {
      int concoursId = await insertConcours(concours);
      for (String participant in participants) {
        await insertParticipant(Participant(coursId: 1, concoursId: concoursId, utilisateurId: 1, commentaire: ''));
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Concours et participants enregistrés avec succès')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la création du concours')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null && picked != _selectedDate) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Concours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _concoursFormKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du Concours', border: OutlineInputBorder()),
                onChanged: (value) => _nomConcours = value,
                validator: (value) => value!.isEmpty ? 'Le nom du concours est requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Adresse', border: OutlineInputBorder()),
                onChanged: (value) => _adresseConcours = value,
                validator: (value) => value!.isEmpty ? 'L\'adresse est requise' : null,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate == null ? 'Sélectionner une date' : 'Date sélectionnée: ${_selectedDate!.toLocal()}'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedNiveau,
                items: niveaux.map((niveau) => DropdownMenuItem(value: niveau, child: Text(niveau))).toList(),
                onChanged: (value) => setState(() => _selectedNiveau = value),
                decoration: InputDecoration(labelText: 'Sélectionner le niveau', border: OutlineInputBorder()),
                validator: (value) => value == null ? 'Le niveau est requis' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom du Participant', border: OutlineInputBorder()),
                onChanged: (value) => _participant = value,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_participant != null && _participant!.isNotEmpty) {
                    setState(() {
                      participants.add(_participant!);
                      _participant = '';
                    });
                  }
                },
                child: Text('Ajouter Participant'),
              ),
              ...participants.map((participant) => ListTile(title: Text(participant))),
              ElevatedButton(
                onPressed: () {
                  if (_concoursFormKey.currentState!.validate() && _selectedDate != null) {
                    _saveConcours(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
                  }
                },
                child: Text("Envoyer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
