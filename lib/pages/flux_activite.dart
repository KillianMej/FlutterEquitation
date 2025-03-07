import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater la date
import '../database/activite.dart'; // Importation correcte

class ActivitePage extends StatefulWidget {
  @override
  _ActivitePageState createState() => _ActivitePageState();
}

class _ActivitePageState extends State<ActivitePage> {
  late Future<List<Activite>> _fluxActualiteFuture;

  @override
  void initState() {
    super.initState();
    _fluxActualiteFuture = getFluxActualite(); // Récupération des activités
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Date inconnue";
    return DateFormat('dd MMM yyyy à HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flux d'Actualité")),
      body: FutureBuilder<List<Activite>>(
        future: _fluxActualiteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur de chargement des données"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun événement récent"));
          }

          List<Activite> fluxActualites = snapshot.data!;

          return ListView.builder(
            itemCount: fluxActualites.length,
            itemBuilder: (context, index) {
              final flux = fluxActualites[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(flux.titre),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flux.description),
                      Text(
                        "Date: ${_formatDate(flux.date)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  leading: Icon(_getIconForType(flux.type)),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Action lorsqu'on clique sur un événement
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Cavalier':
        return Icons.person_add;
      case 'Concours':
        return Icons.event;
      case 'Cours':
        return Icons.schedule;
      case 'Soirée':
        return Icons.party_mode;
      default:
        return Icons.info;
    }
  }
}
