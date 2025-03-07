import 'package:flutter/material.dart';
import 'nouvelle_soiree.dart';
import 'register.dart';
import 'Profile.dart';
import 'nouveau_Cours.dart';
import 'cheval.dart';
import 'nouveau_concours.dart';
import '../database/utilisateur.dart';
import '../database/cours.dart';
import '../database/concours.dart';
import '../database/soiree.dart';
import '../database/theme.dart' as db; // Ajout d'un alias "db"


class HomePage extends StatelessWidget {

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day
        .toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Nous avons 4 onglets
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Soirée"),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NouveauCours()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.music_note),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NouvelleSoiree()),
                );              },
            ),
            IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
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
              },
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey[50], // Fond bleu clair
        body: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Cours'),
                Tab(text: 'Concours'),
                Tab(text: 'Soirées'),
                Tab(text: 'Utilisateurs'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCoursTab(),
                  _buildConcoursTab(),
                  _buildSoireesTab(),
                  _buildUtilisateursTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Méthode pour construire l'onglet des cours
  Widget _buildCoursTab() {
    return FutureBuilder<List<Cours>>(
      future: getCours(), // Récupérer la liste des cours de la base de données
      builder: (context, snapshot) {
        print(getCours());
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucun cours trouvé"));
        }

        final coursList = snapshot.data!;
        print("courslist $coursList");
        return ListView.builder(
          itemCount: coursList.length,
          itemBuilder: (context, index) {
            final cours = coursList[index];
            return ListTile(
              title: Text("Cours ${cours.id}"),
              subtitle: Text("Date: ${_formatDate(cours.date)}"), // Afficher la date
              onTap: () {
                // Action lorsque l'utilisateur appuie sur un cours
              },
            );
          },
        );
      },
    );
  }

  // Méthode pour construire l'onglet des concours
  Widget _buildConcoursTab() {
    return FutureBuilder<List<Concours>>(
      future: getConcours(), // Récupérer la liste des concours de la base de données
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucun concours trouvé"));
        }

        final concoursList = snapshot.data!;
        return ListView.builder(
          itemCount: concoursList.length,
          itemBuilder: (context, index) {
            final concours = concoursList[index];
            return ListTile(
              title: Text(concours.nom), // Afficher le nom du concours
              subtitle: Text("Date: ${_formatDate(concours.date)}"), // Afficher la date
              onTap: () {
                // Action lorsque l'utilisateur appuie sur un concours
              },
            );
          },
        );
      },
    );
  }

  // Méthode pour construire l'onglet des soirées
  Widget _buildSoireesTab() {
    return FutureBuilder<List<Soiree>>(
      future: getSoiree(), // Récupérer la liste des soirées depuis la BDD
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucune soirée trouvée"));
        }

        final soireesList = snapshot.data!;
        return ListView.builder(
          itemCount: soireesList.length,
          itemBuilder: (context, index) {
            final soiree = soireesList[index];

            return FutureBuilder<db.Theme?>(
              future: db.getThemeById(soiree.themeId), // Récupérer le thème de la soirée
              builder: (context, themeSnapshot) {
                if (themeSnapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text("Chargement du thème..."),
                    subtitle: Text("Date: ${_formatDate(soiree.date)}"),
                  );
                } else if (themeSnapshot.hasError || !themeSnapshot.hasData) {
                  return ListTile(
                    title: Text("Thème introuvable"),
                    subtitle: Text("Date: ${_formatDate(soiree.date)}"),
                  );
                }

                final theme = themeSnapshot.data!;
                return ListTile(
                  title: Text(theme.nom), // Afficher le nom du thème de la soirée
                  subtitle: Text("Date: ${_formatDate(soiree.date)}"),
                  onTap: () {
                    // Action lorsque l'utilisateur appuie sur une soirée
                  },
                );
              },
            );
          },
        );
      },
    );
  }


  // Méthode pour construire l'onglet des utilisateurs
  Widget _buildUtilisateursTab() {
    return FutureBuilder<List<Utilisateur>>(
      future: getUtilisateurs(), // Récupérer la liste des utilisateurs de la base de données
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Aucun utilisateur trouvé"));
        }

        final utilisateursList = snapshot.data!;
        return ListView.builder(
          itemCount: utilisateursList.length,
          itemBuilder: (context, index) {
            final utilisateur = utilisateursList[index];
            return ListTile(
              title: Text(utilisateur.nom), // Afficher le nom de l'utilisateur
              subtitle: Text(utilisateur.email), // Afficher le rôle ou autre info
              onTap: () {
                // Action lorsque l'utilisateur appuie sur un utilisateur
              },
            );
          },
        );
      },
    );
  }
}

