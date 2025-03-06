import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/loginpage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database/utilisateur.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'pages/nouveau_Cours.dart';  // Importer si vous avez une page pour l'emploi du temps

Future<void> initDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final dbPath = join(await getDatabasesPath(), 'database.db');
  print("📂 La base de données sera créée à : $dbPath");

  final database = await openDatabase(
    join(await getDatabasesPath(), 'database.db'),
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
          'CREATE TABLE soiree (id INTEGER PRIMARY KEY AUTOINCREMENT,theme_id INT,photo VARCHAR(255))'
      );
      await db.execute(
          'CREATE TABLE theme (id INTEGER PRIMARY KEY AUTOINCREMENT,nom VARCHAR(100) NOT NULL);'
      );
      await db.execute(
          'CREATE TABLE dp (id INTEGER PRIMARY KEY AUTOINCREMENT,cheval_id INT,utilisateur_id INT);'
      );
    },
    version: 1,
  );
  print("🚀 Base de données prête !");
}

void main() async {
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
  void initState() {
    super.initState();
    _insertInitialUser();
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
      backgroundColor: Colors.blueGrey[50], // Fond bleu clair
      appBar: AppBar(
        title: const Text("Page d'accueil"),
        foregroundColor: Colors.white, // Titre en blanc
        backgroundColor: Colors.blueAccent,
        actions: [
          // Icônes dans l'AppBar
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              // Action pour rediriger vers la page d'accueil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Accueil")),
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
              // Naviguer vers la page d'inscription (RegisterPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: _futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('User: ${snapshot.data}');
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page Register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Go to Register"),
            ),
          ],
        ),
      ),
    );
  }
}
