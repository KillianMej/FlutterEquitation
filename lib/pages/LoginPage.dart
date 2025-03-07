import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../database/utilisateur.dart';
import 'Profile.dart';
import 'register.dart'; // Import de la page d'inscription
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
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
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
    );
  }

  Future<bool> _checkLogin(String username, String password) async {
    if (_database == null) return false;

    final List<Map<String, dynamic>> utilisateurs = await _database!.query(
      'utilisateur',
      where: "email = ? AND mot_de_passe = ?",
      whereArgs: [username, password], // Comparaison sans hachage
    );

    return utilisateurs.isNotEmpty;
  }

  Future<void> _saveUserInfo(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("id", userData["id"]);
    await prefs.setString("username", userData["username"] ?? ""); // Si null, stocke ""
    await prefs.setString("email", userData["email"] ?? ""); // Si null, stocke ""
    await prefs.setString("numero", userData["numero"] ?? ""); // Si null, stocke ""
    await prefs.setInt("age", userData["age"] ?? 0); // Si null, stocke 0
    await prefs.setString("ffe", userData["ffe"] ?? ""); // Si null, stocke ""
  }


// Méthode de connexion mise à jour
  void _login(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage(context, "Veuillez entrer un nom d'utilisateur et un mot de passe");
      return;
    }

    final List<Map<String, dynamic>> utilisateurs = await _database!.query(
      'utilisateur',
      where: "email = ? AND mot_de_passe = ?",
      whereArgs: [username, password],
    );

    if (utilisateurs.isNotEmpty) {
      // Enregistrer les infos utilisateur
      await _saveUserInfo(utilisateurs.first);
      // Aller à la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else {
      _showMessage(context, "Nom d'utilisateur ou mot de passe incorrect");
    }
  }


  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                      decoration: _inputDecoration("Email", Icons.person),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Mot de passe", Icons.lock),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        child: const Text("Se connecter", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 5, 5, 5))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Pas encore de compte ? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()),
                            );
                          },
                          child: const Text(
                            "S'inscrire",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
