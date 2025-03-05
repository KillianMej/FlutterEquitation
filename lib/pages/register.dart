import 'package:flutter/material.dart';
import '../database/utilisateur.dart'; // Assurez-vous que le chemin est correct

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomController,
                  decoration: InputDecoration(
                    labelText: "Nom",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Veuillez entrer un nom" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Veuillez entrer un email" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Mot de passe",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.length < 6
                      ? "Le mot de passe doit avoir au moins 6 caractères"
                      : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final utilisateur = Utilisateur(
                          nom: nomController.text,
                          email: emailController.text,
                          mot_de_passe: passwordController.text,
                          numero: '',
                          age: 0,
                          ffe: '',
                          gerant: false,
                        );

                        await insertUtilisateur(utilisateur);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Inscription réussie !")),
                        );
                        // Navigator.pop(context); // Retour à l'écran précédent
                      }
                    },
                    child: const Text("S'inscrire"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
