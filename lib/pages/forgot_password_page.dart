import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _nomController = TextEditingController();  // Renommé de _usernameController à _nomController
  final _newPasswordController = TextEditingController();
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

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();
    String nom = _nomController.text.trim();  // Utilise le nom plutôt que le username
    String newPassword = _newPasswordController.text.trim();

    if (email.isEmpty || nom.isEmpty || newPassword.isEmpty) {
      _showMessage(context, "Veuillez remplir tous les champs");
      return;
    }

    // Recherche dans la base de données avec l'email et le nom
    final List<Map<String, dynamic>> utilisateurs = await _database!.query(
      'utilisateur',
      where: "email = ? AND nom = ?",  // Utilisation de 'nom' au lieu de 'username'
      whereArgs: [email, nom],  // Passe le nom au lieu du username
    );

    if (utilisateurs.isNotEmpty) {
      // Met à jour le mot de passe dans la base de données
      await _database!.update(
        'utilisateur',
        {'mot_de_passe': newPassword},
        where: "email = ? AND nom = ?",  // Utilisation de 'nom' ici aussi
        whereArgs: [email, nom],  // Passe le nom et l'email
      );

      _showMessage(context, "Mot de passe réinitialisé avec succès !");
      Navigator.pop(context); // Retour à la page de connexion
    } else {
      _showMessage(context, "Aucun compte trouvé avec ces informations");
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Réinitialisation du mot de passe")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Entrez votre email et votre nom d'utilisateur pour réinitialiser votre mot de passe."),
            const SizedBox(height: 10),
            TextField(
              controller: _nomController,  // Utilise _nomController ici
              decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _resetPassword(context), // Ajout du contexte
              child: const Text("Réinitialiser le mot de passe"),
            ),
          ],
        ),
      ),
    );
  }
}
