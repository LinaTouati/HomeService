import 'package:flutter/material.dart';
import 'profilpresta.dart';

class PrestatairesScreen extends StatelessWidget {
  final String prestation;
  final List<Prestataire> prestataires;

  const PrestatairesScreen({
    super.key,
    required this.prestation,
    required this.prestataires,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prestataires - $prestation')),
      body: ListView.builder(
        itemCount: prestataires.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final prestataire = prestataires[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: InkWell(
              onTap: () {
                // Naviguer vers ProviderProfileScreen au lieu de PrestaDetailsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProviderProfileScreen(
                          name: prestataire.prenom,
                          surname: prestataire.nom,
                          profession: prestataire.profession,
                          description: prestataire.description,
                          hourlyRate: prestataire.tarifHoraire,
                          imageUrl: prestataire.photoUrl,
                          // Valeurs par défaut pour les autres champs
                          
                          phone:prestataire.numTel,
                          email:
                              "${prestataire.prenom.toLowerCase()}.${prestataire.nom.toLowerCase()}@example.com",
                          rating: 4.8,
                          reviewCount: 120,
                          isVerified: true,
                        ),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(prestataire.photoUrl),
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${prestataire.prenom} ${prestataire.nom}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              prestataire.profession,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.euro,
                                  size: 16,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${prestataire.tarifHoraire.toStringAsFixed(0)}€/h',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[700],
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4.0),
                                const Text(
                                  '4.8',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Modèle de données pour un prestataire
class Prestataire {
  final String nom;
  final String prenom;
  final String profession;
  final double tarifHoraire;
  final String description;
  final String photoUrl;
  final String numTel; // AJOUTE CE CHAMP

  Prestataire({
    required this.nom,
    required this.prenom,
    required this.profession,
    required this.tarifHoraire,
    required this.description,
    required this.photoUrl,
    required this.numTel, // AJOUTE CE CHAMP 
  });
}

// Exemple de données (à remplacer par tes données réelles)
List<Prestataire> nettoyagePrestataires = [
  Prestataire(
    nom: 'Dupont',
    prenom: 'Jean',
    profession: 'Nettoyeur professionnel',
    tarifHoraire: 25.0,
    description: 'Spécialisé dans le nettoyage résidentiel et commercial.',
    photoUrl: 'https://via.placeholder.com/150/00BCD4/FFFFFF?Text=JD',
    numTel: '0600000000', // AJOUTE CE CHAMP
  ),
  Prestataire(
    nom: 'Lefevre',
    prenom: 'Sophie',
    profession: 'Technicienne de surface',
    tarifHoraire: 20.0,
    description: 'Offre des services de nettoyage efficaces et rapides.',
    photoUrl: 'https://via.placeholder.com/150/FFC107/000000?Text=SL',
    numTel: '0600000000', // AJOUTE CE CHAMP
  ),
  Prestataire(
    nom: 'Garcia',
    prenom: 'Carlos',
    profession: 'Agent de propreté',
    tarifHoraire: 22.0,
    description: 'Expérience dans le nettoyage post-rénovation.',
    photoUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?Text=CG',
    numTel: '0600000000', // AJOUTE CE CHAMP
  ),
  // ... d'autres prestataires pour le nettoyage
];