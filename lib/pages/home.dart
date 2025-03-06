import 'package:flutter/material.dart';
import 'register.dart'; // Importer la page de profil qui est pour l'instant RegisterPage
import 'Profile.dart';
import 'nouveau_Cours.dart'; // Importer la page d'emploi du temps si elle existe

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
            icon: const Icon(Icons.schedule),
            onPressed: () {
              // Naviguer vers la page emploi du temps
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Emploi du temps")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Naviguer vers la page de profil (pour l'instant RegisterPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
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
