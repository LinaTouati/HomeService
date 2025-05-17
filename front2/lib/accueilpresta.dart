import 'package:flutter/material.dart';
import 'demande.dart';
class AccueilPresta extends StatelessWidget {
  const AccueilPresta({Key? key, required this.prestataireId}) : super(key: key);
  final String prestataireId; 

  @override
  Widget build(BuildContext context) {  
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Prestataire'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 85, 46, 192),
        elevation: 0, 
         
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue sur votre espace prestataire',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vous êtes maintenant inscrit en tant que prestataire de services.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Carte de profil
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromARGB(255, 85, 46, 192),
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Votre profil est complet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vous pouvez maintenant recevoir des demandes de services',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Options
              _buildOptionCard(
                icon: Icons.work,
                title: 'Mes services',
                description: 'Gérer vos services et disponibilités',
                onTap: () {},
              ),

              const SizedBox(height: 16),

              _buildOptionCard(
                icon: Icons.message,
                title: 'Messages',
                description: 'Consulter vos messages et demandes',
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                 );
                },
              ),

              const SizedBox(height: 16),

              _buildOptionCard(
                icon: Icons.settings,
                title: 'Paramètres',
                description: 'Modifier vos informations personnelles',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 85, 46, 192).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color.fromARGB(255, 85, 46, 192),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
