import 'package:flutter/material.dart';
import 'LoginPage.dart';

import 'home.dart';

class ProfilePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fond bleu clair
      appBar: AppBar(
        title: const Text("Profil"),
        foregroundColor: Colors.white, // Titre en blanc
        backgroundColor: Colors.blueAccent,
        actions: [
          // Icônes dans l'AppBar
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Action pour rediriger vers la page d'accueil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
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
            icon: const Icon(Icons.person_add),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );              },
              child: const Text("Se déconnecter"),
            ),
          ],
        ),
      ),
    );
  }
}
