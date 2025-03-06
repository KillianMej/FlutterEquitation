import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'home.dart';
import 'LoginPage.dart';

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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Fonction pour sélectionner une photo
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Section photo de profil
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.blueAccent),
                        onPressed: _pickImage,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Formulaire d'inscription
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: nomController,
                      label: "Nom",
                      icon: Icons.person,
                      validator: (value) => value!.isEmpty ? "Veuillez entrer un nom" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email,
                      validator: (value) => value!.isEmpty ? "Veuillez entrer un email" : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: passwordController,
                      label: "Mot de passe",
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) => value!.length < 6
                          ? "Le mot de passe doit avoir au moins 6 caractères"
                          : null,
                    ),
                    const SizedBox(height: 40),

                    // Bouton d'inscription
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
                              photo: _image != null ? basename(_image!.path) : '',
                              gerant: false,
                            );

                            try {
                              await insertUtilisateur(utilisateur);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Inscription réussie !")),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erreur lors de l'inscription : $e")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Couleur de fond du bouton
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Texte en blanc
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Vous avez un compte ? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: const Text(
                            "Se connecter",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget personnalisé pour les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }
}
