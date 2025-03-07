import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'cheval.dart';
import '../database/theme.dart' as db_theme;
import '../database/soiree.dart';
import 'home.dart';
import 'nouveau_cours.dart';
import 'Profile.dart';

class NouvelleSoiree extends StatefulWidget {
  @override
  _NouvelleSoireeState createState() => _NouvelleSoireeState();
}

class _NouvelleSoireeState extends State<NouvelleSoiree> {
  final _soireeKey = GlobalKey<FormState>();
  int? _selectedThemeId;
  DateTime? _selectedDate;
  List<db_theme.Theme> themes = [];
  List<Soiree> soirees = [];

  @override
  void initState() {
    super.initState();
    _loadThemes();
    _loadSoiree();
  }

  // Chargement des themes
  Future<void> _loadThemes() async {
    themes = await db_theme.getThemes();
    if(themes.isNotEmpty){
      _selectedThemeId = 1;
    }
    setState(() {});
    print(themes);
  }

  Future<void> _loadSoiree() async {
    soirees = await getSoiree();
    setState(() {});
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

  Future<void> _saveSoiree() async {
    final soiree = Soiree(
      themeId: _selectedThemeId ?? 1,
      date: _selectedDate!
    );

    await insertSoiree(soiree);
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Soirée"),
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
              // Naviguer vers la page de profil (pour l'instant RegisterPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouveauCours()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () {
              // Naviguer vers la page de profil (pour l'instant RegisterPage
            },
          ),

          IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
              // Naviguer vers la page emploi du temps
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Emploi du temps")),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChevalPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: soirees.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text('Soirée ${themes[soirees[i].themeId - 1].nom}'),
              subtitle: Text('Date: ${_formatDate(soirees[i].date)}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _loadThemes();
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Créer une nouvelle soirée'),
              content: Form(
                key: _soireeKey,
                child: Column(
                  children: [
                    if (themes.isNotEmpty)
                      // Selection du themes
                      DropdownButtonFormField(
                        value: themes[0],
                        items: themes.map((db_theme.Theme theme) {
                          return DropdownMenuItem(
                            value: theme,
                            child: Text(theme.nom),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _selectedThemeId = value?.id;
                        },
                        validator: (value) => value == null ? 'Veuillez sélectionner un thème' : null
                      )
                    else
                      Text('Aucun thème disponible'),
                    // Selection de la date
                    ElevatedButton(
                      onPressed: () => {_selectDate(context)},
                      child: Text(_selectedDate == null
                          ? 'Sélectionner une date'
                          : 'Date sélectionnée: ${_formatDate(_selectedDate!)}'),
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_soireeKey.currentState!.validate() && _selectedThemeId != null) {
                            _saveSoiree();
                            _loadSoiree();
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Envoyer")),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}