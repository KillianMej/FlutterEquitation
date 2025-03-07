import 'package:flutter/material.dart';
import 'package:flutter_app/pages/cheval.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'nouveau_cours.dart';
import 'nouvelle_soiree.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Database? _database;
  int? id;
  String username = "";
  String numero = "";
  String age = "";
  String ffeProfile = "";
  String email = "";

  bool isEditingPhone = false;
  bool isEditingAge = false;
  bool isEditingFFE = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _ffeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadUserInfo();
  }

  // Initialiser la base de données
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      version: 1,
    );
  }

  // Charger les informations depuis SharedPreferences
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? "Non défini";
      numero = prefs.getString("numero") ?? "";
      age = prefs.getInt("age")?.toString() ?? "";
      ffeProfile = prefs.getString("ffe") ?? "";
      id = prefs.getInt("id") ?? 0;

      print("id : $id");


      _phoneController.text = numero;
      _ageController.text = age;
      _ffeController.text = ffeProfile;
    });
  }

  // Enregistrer dans la base de données et SharedPreferences
  Future<void> _saveUserInfo(String field, String value) async {
    if (_database == null) return;

    final prefs = await SharedPreferences.getInstance();

    String dbField;
    if (field == "numero") {
      dbField = "numero"; // Correction ici
    } else if (field == "age") {
      dbField = "age";
    } else if (field == "ffe") {
      dbField = "ffe"; // Correction ici
    } else {
      return;
    }

    await _database!.update(
      'utilisateur',
      {dbField: value},
      where: "id = ?", // Utilisez l'id ici
      whereArgs: [id],  // Utilisez id comme argument
    );

    // Mettre à jour SharedPreferences
    if (field == "numero") {
      await prefs.setString("numero", value);
    } else if (field == "age") {
      await prefs.setInt("age", int.tryParse(value) ?? 0);
    } else if (field == "ffe") {
      await prefs.setString("ffe", value);
    }

    // Mettre à jour l'affichage
    setState(() {
      if (field == "numero") {
        numero = value;
        isEditingPhone = false;
      } else if (field == "age") {
        age = value;
        isEditingAge = false;
      } else if (field == "ffe") {
        ffeProfile = value;
        isEditingFFE = false;
      }
    });
  }


  // Déconnexion
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Accueil"),
        foregroundColor: Colors.white, // Titre en blanc
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // Naviguer vers la page de profil (pour l'instant RegisterPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouveauCours()),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () {
              // Naviguer vers la page de profil (pour l'instant RegisterPage)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NouvelleSoiree()),
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
              // Naviguer vers la page de profil (pour l'instant RegisterPage)

            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildEditableField("Numéro de téléphone", Icons.phone, numero, _phoneController, () {
              setState(() => isEditingPhone = true);
            }, isEditingPhone, "numero"),
            _buildEditableField("Âge", Icons.cake, age, _ageController, () {
              setState(() => isEditingAge = true);
            }, isEditingAge, "age"),
            _buildEditableField("Profil FFE", Icons.info, ffeProfile, _ffeController, () {
              setState(() => isEditingFFE = true);
            }, isEditingFFE, "ffe"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Se déconnecter"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour gérer l'affichage / modification des champs
  Widget _buildEditableField(String label, IconData icon, String value,
      TextEditingController controller, VoidCallback onEdit, bool isEditing, String field) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: isEditing
                  ? TextField(
                controller: controller,
                keyboardType: field == "age" ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
                  : Text(value.isNotEmpty ? value : "Non défini", style: const TextStyle(fontSize: 16)),
            ),
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit, color: isEditing ? Colors.green : Colors.blue),
              onPressed: isEditing
                  ? () => _saveUserInfo(field, controller.text)
                  : onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
