import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
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
  String? _nomConcours;
  String? _adresseConcours;
  DateTime? _selectedDate;
  String? _selectedNiveau = "Amateur";
  List<String> participants = [];  // Liste des participants
  String? _participant;  // Nom du participant à ajouter

  @override
  void initState() {
    super.initState();
  }

  // Fonction pour insérer un concours dans la base de données
  Future<int> insertConcours(Concours concours) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
    );

    // Insérer le concours et retourner l'ID de la ligne insérée
    return await database.insert(
      'concours',
      concours.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fonction pour insérer un participant dans la base de données
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

  // Enregistrement du concours
  Future<void> _saveConcours(BuildContext context) async {
    if (_selectedDate == null || _nomConcours == null || _adresseConcours == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tous les champs sont requis')),
        );
      }
      return;
    }

    int niveauId;
    switch (_selectedNiveau) {
      case "Amateur":
        niveauId = 1;
        break;
      case "Club1":
        niveauId = 2;
        break;
      case "Club2":
        niveauId = 3;
        break;
      case "Club3":
        niveauId = 4;
        break;
      case "Club4":
        niveauId = 5;
        break;
      default:
        niveauId = 1;
    }

    final concours = Concours(
      nom: _nomConcours!,
      adresse: _adresseConcours!,
      photo: "",
      date: _selectedDate!,
      niveauId: niveauId,
    );

    try {
      // Insérer le concours et récupérer son ID
      int concoursId = await insertConcours(concours);

      // ✅ Insérer les participants
      for (String participant in participants) {
        final newParticipant = Participant(
          concoursId: concoursId, // Utilisation de l'ID du concours
          utilisateurId: 1, // Remplacer par l'ID utilisateur réel
          commentaire: '',
        );
        await insertParticipant(newParticipant);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Concours et participants enregistrés avec succès')),
        );
        Navigator.of(context).pop(); // Ferme l'écran après l'enregistrement
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du concours')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Concours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _concoursFormKey,
          child: ListView(
            children: [
              // Nom du concours
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom du Concours',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  onChanged: (value) {
                    _nomConcours = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le nom du concours est requis';
                    }
                    return null;
                  },
                ),
              ),
              // Adresse du concours
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  onChanged: (value) {
                    _adresseConcours = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'adresse est requise';
                    }
                    return null;
                  },
                ),
              ),
              // Sélection de la date
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(_selectedDate == null
                      ? 'Sélectionner une date'
                      : 'Date sélectionnée: ${_formatDate(_selectedDate!)}'),
                ),
              ),
              // Sélection du niveau
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedNiveau,
                  items: niveaux.map((String niveau) {
                    return DropdownMenuItem<String>(
                      value: niveau,
                      child: Text(niveau),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNiveau = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Sélectionner le niveau',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Le niveau est requis';
                    }
                    return null;
                  },
                ),
              ),
              // Ajout d'un participant
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nom du Participant',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  ),
                  onChanged: (value) {
                    _participant = value;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_participant != null && _participant!.isNotEmpty) {
                    setState(() {
                      participants.add(_participant!);  // Ajouter un participant
                      _participant = '';  // Réinitialiser le champ
                    });
                  }
                },
                child: Text('Ajouter Participant'),
              ),
              // Liste des participants
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text('Liste des Participants:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...participants.map((participant) => ListTile(
                          title: Text(participant),
                        )),
                  ],
                ),
              ),
              // Bouton d'envoi
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_concoursFormKey.currentState!.validate() && _selectedDate != null) {
                      _saveConcours(context);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
                      }
                    }
                  },
                  child: Text("Envoyer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
