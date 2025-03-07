import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'Profile.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../database/specialite.dart';
import '../database/cours.dart';
import 'nouvelle_soiree.dart';
import 'home.dart';
import 'cheval.dart';
import 'nouveau_concours.dart';

class NouveauCours extends StatefulWidget {
  @override
  _NouveauCoursState createState() => _NouveauCoursState();
}

class _NouveauCoursState extends State<NouveauCours> {
  final List<String> terrains = ["Carriere", "Manege"];
  final _coursformKey = GlobalKey<FormState>();
  String? _selectedTerrain = "Carriere";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedSpecialiteId = "1";
  List<Specialite> specialites = [];
  


  @override
  void initState() {
    super.initState();
    _loadSpecialites();
  }

  // Chargement des specialites
  Future<void> _loadSpecialites() async {
    specialites = await getSpecialites();
    setState(() {});
  }

  // Enregistrement du cours
  Future<void> _saveCours() async {
    if (_selectedDate == null || _selectedTime == null) {
      // Gérer le cas où la date ou l'heure n'est pas sélectionnée
      return;
    }

    final cours = Cours(
      terrain: _selectedTerrain == "Carriere" ? Terrain.carriere : Terrain.manege,
      date: _selectedDate!,
      duree: _selectedTime!.hour * 60 + _selectedTime!.minute,
      specialiteId: int.parse(_selectedSpecialiteId!),
    );
    await insertCours(cours);
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

Future<void> _selectTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(), 
    initialEntryMode: TimePickerEntryMode.input,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    }
  );

  if (pickedTime != null && pickedTime != _selectedTime) {
    setState(() {
      _selectedTime = pickedTime;
    });
  }
}

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Accueil"),
          foregroundColor: Colors.white, // Titre en blanc
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.book),
              onPressed: () {
                // Naviguer vers la page de profil (pour l'instant RegisterPage
              },
            ),

            IconButton(
              icon: const Icon(Icons.music_note),
              onPressed: () {
                // Naviguer vers la page de profil (pour l'instant RegisterPage)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NouvelleSoiree()),
                );
              },
            ),

           IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              // Naviguer vers la page emploi du temps
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouveauConcours()),
              );
            },
          ),

            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChevalPage()),  // Utilisez ChevalPage() pour naviguer
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                // Naviguer vers la page de profil (pour l'instant RegisterPage)

              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text("Nouveau Cours"),
              Form(
                key: _coursformKey,
                child: Column(
                  children: [
                    // Selection du terrain
                    DropdownButtonFormField(
                      value: terrains[0],
                      items: terrains.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedTerrain = value;
                      },
                    ),
                    // Bouton de selection de date
                    ElevatedButton(
                      onPressed: () => {_selectDate(context)},
                      child: Text(_selectedDate == null
                          ? 'Sélectionner une date'
                          : 'Date sélectionnée: ${_formatDate(_selectedDate!)}'),
                    ),
                    // Bouton de selection de l'heure
                    ElevatedButton(
                      onPressed: () => {_selectTime(context)},
                      child: Text(_selectedTime == null ? 'Selectionner une heure' : 'Heure sélectionnée: ${_selectedTime?.format(context)}'),
                    ),
                    // Selection de la specialite
                    DropdownButtonFormField<Specialite>(
                      value: specialites.isNotEmpty ? specialites[0] : null,
                      items: specialites.map((Specialite specialite) {
                        return DropdownMenuItem<Specialite>(
                          value: specialite,
                          child: Text(specialite.nom),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedSpecialiteId = value?.id.toString();
                      },
                      decoration: InputDecoration(
                        labelText: 'Sélectionner une spécialité',
                      ),
                    ),
                    // Bouton d'envoie
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_coursformKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
                              _saveCours();
                            }
                          },
                          child: const Text("Envoyer")),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}