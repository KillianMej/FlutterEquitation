import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/database/concours.dart';
import 'package:flutter_app/pages/activitepage.dart';
import 'package:flutter_app/database/activite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/utilisateur.dart';
import 'pages/register.dart';
import 'pages/nouveau_Cours.dart';
import 'pages/nouvelle_soiree.dart';
import 'pages/home.dart';
import 'pages/nouveau_concours.dart';
import 'pages/activitepage.dart';

// 🔹 Déclaration d'une variable globale pour la base de données
Database? _database;

Future<void> initDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = join(await getDatabasesPath(), 'database.db');
  print("📂 La base de données sera créée à : $dbPath");

  // Initialisation ou ouverture de la base de données
  _database = await openDatabase(
    dbPath,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE utilisateur(id INTEGER PRIMARY KEY AUTOINCREMENT, nom VARCHAR(100) NOT NULL, email VARCHAR(255) UNIQUE NOT NULL, mot_de_passe VARCHAR(255) NOT NULL, numero VARCHAR(20), age INT, ffe VARCHAR(255),photo VARCHAR(255), gerant BOOLEAN)',
      );
      await db.execute(
        'CREATE TABLE cheval(id INTEGER PRIMARY KEY AUTOINCREMENT,photo VARCHAR(255),nom VARCHAR(100) NOT NULL,age INT,robe VARCHAR(50),race VARCHAR(100),sexe VARCHAR(1) NOT NULL,specialite_id INT,utilisateur_id INT)',
      );
      await db.execute(
          'CREATE TABLE specialites (id INTEGER PRIMARY KEY AUTOINCREMENT,nom VARCHAR(100) NOT NULL);'
      );
      await db.execute(
          'CREATE TABLE cours (id INTEGER PRIMARY KEY AUTOINCREMENT,terrain VARCHAR(8),date DATETIME NOT NULL,duree INT,specialite_id INT,valide INT)'
      );
      await db.execute(
          'CREATE TABLE concours (id INTEGER PRIMARY KEY AUTOINCREMENT,nom VARCHAR(100) NOT NULL,adresse VARCHAR(255),photo VARCHAR(255),date DATETIME NOT NULL,niveau_id INT)'
      );
      await db.execute(
          'CREATE TABLE niveau (id INTEGER PRIMARY KEY AUTOINCREMENT,nom VARCHAR(100) NOT NULL);'
      );
      await db.execute(
          'CREATE TABLE participant (id INTEGER PRIMARY KEY AUTOINCREMENT,cours_id INT,concours_id INT,soiree_id INT,utilisateur_id INT,commentaire TEXT)'
      );
      await db.execute(
        'CREATE TABLE soiree (id INTEGER PRIMARY KEY AUTOINCREMENT,theme_id INT, date DATETIME ,photo VARCHAR(255), valide INTEGER NOT NULL)'
      );
      await db.execute(
          'CREATE TABLE theme (id INTEGER PRIMARY KEY AUTOINCREMENT,nom VARCHAR(100) NOT NULL);'
      );
      await db.execute(
          'CREATE TABLE dp (id INTEGER PRIMARY KEY AUTOINCREMENT,cheval_id INT,utilisateur_id INT);'
      );
      await db.execute(
           'CREATE TABLE activite (id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, description TEXT, date DATETIME, type TEXT)'
      );
      await db.execute(
           'CREATE TABLE activite (id INTEGER PRIMARY KEY AUTOINCREMENT, titre TEXT, description TEXT, date DATETIME, type TEXT)'
      );

    },
    version: 1,
  );
  print("🚀 Base de données prête !");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDb();

  runApp(
    MaterialApp(
      home: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<String>? _futureUsers;

  @override
@override
void initState() {
  super.initState();
  // Appel à la fonction pour tester l'ajout et la récupération des activités
  _testerAjoutEtRecuperation();
  _futureUsers = _getUsers(11);
}


  Future<void> _insertInitialUser() async {
    final jaque = Utilisateur(
      nom: "Jaque",
      email: "jaque@gmail.com",
      mot_de_passe: "test",
      numero: "0606060606",
      age: 25,
      ffe: "123456",
      gerant: true,
    );

    await insertUtilisateur(jaque);
  }

  Future<String> _getUsers(int id) async {
    final user = await getUtilisateurById(id);
    if (user != null) {
      return user.toString();
    } else {
      return 'Utilisateur non trouvé';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'Accueil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Naviguer vers la page ActivitePage (Flux d'Actualité)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NouveauConcours()),
            );
          },
          child: Text("Voir les Activités"),
        ),
      ),
    );
  }
}

Future<void> _testerAjoutEtRecuperation() async {
  // 1️⃣ Ajouter une activité
  await ajouterActivite(
    Activite(
      titre: "Test Concours",
      description: "Ceci est un test d'ajout d'activité.",
      date: DateTime.now(),
      type: "Concours",
    ),
  );

  print("✅ Activité ajoutée avec succès !");

  // 2️⃣ Récupérer les activités pour vérifier
  List<Activite> activites = await getFluxActualite();

  print("📋 Liste des activités récupérées :");
  for (var activite in activites) {
    print(
        "🔹 ${activite.titre} - ${activite.description} - ${activite.date} - ${activite.type}");
  }
}


