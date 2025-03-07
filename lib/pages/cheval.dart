import 'package:flutter/material.dart';
import 'nouveau_concours.dart';
import 'home.dart';
import 'nouveau_Cours.dart';
import 'nouvelle_soiree.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/cheval.dart'; // Assurez-vous que ce fichier contient la définition de 'Cheval'


class ChevalPage extends StatefulWidget {
  const ChevalPage({super.key});

  @override
  _ChevalPageState createState() => _ChevalPageState();
}

class _ChevalPageState extends State<ChevalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nomChevalController = TextEditingController();
  final TextEditingController _ageChevalController = TextEditingController();
  final TextEditingController _robeController = TextEditingController();
  final TextEditingController _raceController = TextEditingController();
  Sexe _selectedSexe = Sexe.M;

  List<Cheval> chevaux = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _chargerChevaux();
  }



  Future<void> _chargerChevaux() async {
    final prefs = await SharedPreferences.getInstance();
    int utilisateurId = prefs.getInt("id") ?? 0;

    if (utilisateurId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur : utilisateur non identifié.")),
      );
      return;
    }

    // Charger tous les chevaux de l'utilisateur depuis la base de données
    List<Cheval> listeChevaux = await getChevauxByUtilisateur(utilisateurId); // Remplacez par la fonction réelle
    setState(() {
      chevaux = listeChevaux;
    });
  }


  Future<void> _ajouterCheval() async {
    if (_nomChevalController.text.isEmpty ||
        _ageChevalController.text.isEmpty ||
        _robeController.text.isEmpty ||
        _raceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    int utilisateurId = prefs.getInt("id") ?? 0;

    if (utilisateurId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur : utilisateur non identifié.")),
      );
      return;
    }

    Cheval nouveauCheval = Cheval(
      photo: "",
      nom: _nomChevalController.text,
      age: int.parse(_ageChevalController.text),
      robe: _robeController.text,
      race: _raceController.text,
      sexe: _selectedSexe,
      specialiteId: 1,
      utilisateurId: utilisateurId,
    );

    await insertCheval(nouveauCheval); // Remplacez par votre fonction réelle

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cheval ajouté avec succès !")),
    );

    // Recharge la liste des chevaux
    _chargerChevaux();

    // Vide les champs du formulaire
    _nomChevalController.clear();
    _ageChevalController.clear();
    _robeController.clear();
    _raceController.clear();
  }

  Future<void> _modifierCheval(Cheval cheval) async {
    if (_nomChevalController.text.isEmpty ||
        _ageChevalController.text.isEmpty ||
        _robeController.text.isEmpty ||
        _raceController.text.isEmpty) {
      print("Cheval : $cheval");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    Cheval chevalModifie = Cheval(
      id: cheval.id,
      photo: cheval.photo,
      nom: _nomChevalController.text,
      age: int.parse(_ageChevalController.text),
      robe: _robeController.text,
      race: _raceController.text,
      sexe: _selectedSexe,
      specialiteId: cheval.specialiteId,
      utilisateurId: cheval.utilisateurId,
    );

    // Mettez à jour le cheval dans la base de données
    await updateCheval(chevalModifie); // Remplacez par votre fonction réelle

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cheval modifié avec succès !")),
    );

    // Recharge la liste des chevaux après modification
    _chargerChevaux();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              );
            },
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
              // Naviguer vers la page de profil (pour l'instant RegisterPage)
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: "Ajouter un cheval"),
                Tab(text: "Voir mes chevaux"),
                Tab(text: "Modifier un cheval"),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Ajouter un cheval
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField("Nom du cheval", _nomChevalController),
                        _buildTextField("Âge du cheval", _ageChevalController, isNumber: true),
                        _buildTextField("Robe", _robeController),
                        _buildTextField("Race", _raceController),
                        DropdownButton<Sexe>(
                          value: _selectedSexe,
                          items: Sexe.values.map((sexe) {
                            return DropdownMenuItem(value: sexe, child: Text(sexe.toString().split('.').last));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedSexe = value!);
                          },
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _ajouterCheval,
                          child: const Text("Ajouter le cheval"),
                        ),
                      ],
                    ),
                  ),
                  // Voir la liste des chevaux
                  chevaux.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: chevaux.length,
                    itemBuilder: (context, index) {
                      final cheval = chevaux[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        elevation: 5,
                        child: ListTile(
                          title: Text(cheval.nom),
                          subtitle: Text("Âge: ${cheval.age} - Race: ${cheval.race}"),
                          onTap: () {
                            _nomChevalController.text = cheval.nom;
                            _ageChevalController.text = cheval.age.toString();
                            _robeController.text = cheval.robe;
                            _raceController.text = cheval.race;
                            _selectedSexe = cheval.sexe;
                            _tabController.index = 2; // Passe à l'onglet "Modifier un cheval"
                          },
                        ),
                      );
                    },
                  ),
                  // Modifier un cheval
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField("Robe", _robeController),
                        _buildTextField("Race", _raceController),
                        DropdownButton<Sexe>(
                          value: _selectedSexe,
                          items: Sexe.values.map((sexe) {
                            return DropdownMenuItem(value: sexe, child: Text(sexe.toString().split('.').last));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedSexe = value!);
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            print("Liste des chevaux : $chevaux");
                            print("Valeur saisie - Nom: '${_nomChevalController.text}' - Âge: '${_ageChevalController.text}'");

                            final cheval = chevaux.firstWhere(
                                  (c) => c.nom.trim().toLowerCase() == _nomChevalController.text.trim().toLowerCase() &&
                                  c.age == int.tryParse(_ageChevalController.text),
                              orElse: () {
                                print("Aucun cheval trouvé avec ces critères !");
                                return Cheval(
                                  id: 0,
                                  photo: '',
                                  nom: '',
                                  age: 0,
                                  robe: '',
                                  race: '',
                                  sexe: Sexe.M,
                                  specialiteId: 1,
                                  utilisateurId: 0,
                                );
                              },
                            );

                            if (cheval.id == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Erreur : cheval introuvable.")),
                              );
                              return;
                            }

                            _modifierCheval(cheval);
                          },
                          child: const Text("Modifier le cheval"),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
