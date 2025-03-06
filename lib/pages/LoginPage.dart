import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../database/utilisateur.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Database? _database;

@override
void initState() {
  super.initState();
  _initDatabase().then((_) => _printAllUsers());
}

// Afficher tous les utilisateurs de la base de données
Future<void> _printAllUsers() async {
  if (_database == null) {
    print("La base de données n'est pas encore initialisée !");
    return;
  }

  final List<Map<String, dynamic>> users = await _database!.query('utilisateur');
  print("Liste des utilisateurs : $users");
}

  // Initialisation de la base de données
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
    );
  }

// Vérifier si les informations de connexion sont valides
Future<bool> _checkLogin(String username, String password) async {
  if (_database == null) return false;

  print("Requête SQL : SELECT * FROM utilisateur WHERE email = ? AND mot_de_passe = ?");
  print("Params : [username, hashedPassword]");

  // Hacher le mot de passe saisi avant de faire la comparaison

  print("Tentative de connexion avec : $username / $password");

 final List<Map<String, dynamic>> utilisateurs = await _database!.query(
  'utilisateur',
  where: "email = ? AND mot_de_passe = ?",
  whereArgs: [username, password], // Comparaison sans hachage
);


  print("Résultat de la requête : $utilisateurs");

print(utilisateurs );
  // Si la requête retourne des résultats, l'utilisateur est authentifié
  if (utilisateurs.isNotEmpty) {
    print("Utilisateur trouvé !");
    return true;
  } else {
    print("Nom d'utilisateur ou mot de passe incorrect");
    return false;
  }
}



// Méthode de connexion
void _login(BuildContext context) async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();

  print("Utilisateur entré : $username");
  print("Mot de passe entré : $password");

  if (username.isEmpty || password.isEmpty) {
    _showMessage(context, "Veuillez entrer un nom d'utilisateur et un mot de passe");
    return;
  }

  bool isValid = await _checkLogin(username, password);

  if (isValid) {
    print("Connexion réussie !");
    _showMessage(context, "Connexion réussie !");
  } else {
    print("Nom d'utilisateur ou mot de passe incorrect");
    _showMessage(context, "Nom d'utilisateur ou mot de passe incorrect");
  }
}

  // Afficher un message avec un SnackBar
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Afficher la fenêtre de réinitialisation du mot de passe
  void _showResetPasswordDialog(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Réinitialiser le mot de passe"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: _inputDecoration("Nom d'utilisateur", Icons.person),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: _inputDecoration("Email", Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Annuler")),
            ElevatedButton(
              onPressed: () {
                if (usernameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  _showMessage(context, "Demande de réinitialisation envoyée");
                  Navigator.of(context).pop();
                } else {
                  _showMessage(context, "Nom d'utilisateur ou email incorrect");
                }
              },
              child: const Text("Envoyer"),
            ),
          ],
        );
      },
    );
  }

  // Décoration des champs de texte
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 106, 172, 248), Color(0xFF145DA0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Connexion", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: _inputDecoration("Nom d'utilisateur", Icons.person),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Mot de passe", Icons.lock),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showResetPasswordDialog(context),
                        child: const Text("Mot de passe oublié ?", style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        child: const Text("Se connecter", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
