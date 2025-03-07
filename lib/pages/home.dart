import 'package:flutter/material.dart';
import 'package:flutter_app/database/concours.dart';
import 'nouvelle_soiree.dart';
import 'register.dart'; // Importer la page de profil qui est pour l'instant RegisterPage
import 'Profile.dart';
import 'nouveau_Cours.dart'; // Importer la page d'emploi du temps si elle existe
import 'cheval.dart';
import 'Profile.dart';
import 'nouveau_concours.dart';  // Importer la page Nouveau Concours
import 'flux_activite.dart';     // Importer la page Flux Activité

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fond bleu clair
      appBar: AppBar(
        title: const Text("Accueil"),
        foregroundColor: Colors.white, // Titre en blanc
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
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
              // Ajouter une action si nécessaire
            },
          ),
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // Naviguer vers la page Nouveau Cours
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouveauCours()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () {
              // Naviguer vers la page Nouvelle Soirée
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouvelleSoiree()),
              );
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
            icon: const Icon(Icons.schedule),
            onPressed: () {
              // Afficher un message pour l'emploi du temps
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
            icon: const Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page Cheval
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChevalPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              // Naviguer vers la page Nouveau Concours
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Concours()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              // Naviguer vers la page Flux d'Activités
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ActivitePage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Bienvenue sur la page d'accueil !",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
