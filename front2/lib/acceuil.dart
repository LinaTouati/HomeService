import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
// Importer la classe PrestatairesScreen et le modèle Prestataire
import 'profilpresta.dart'; 
import'api_service.dart';  
import 'chargepresta-api.dart'; // AJOUTE CETTE LIGNE


class Demande {
  final int id;
  final String service;
  final String datepresta;
  final String heurepresta;
  final String etatpresta;
  final String prestataire;

  Demande({
    required this.id,
    required this.service,
    required this.datepresta,
    required this.heurepresta,
    required this.etatpresta,
    required this.prestataire,
  });

  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'],
      service: json['service'] ?? '',
      datepresta: json['datepresta'] ?? '',
      heurepresta: json['heurepresta'] ?? '',
      etatpresta: json['etatpresta'] ?? '',
      prestataire: json['prestataire'] ?? '',
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
  final String numTel; // AJOUTE CE CHAMP
  final String photoUrl;
  final int id;
  final String email;

  Prestataire({
    required this.nom,
    required this.prenom,
    required this.profession,
    required this.tarifHoraire,
    required this.description,
    required this.numTel, // AJOUTE CE CHAMP
    required this.photoUrl,
    required this.id,
    required this.email,
  });  
   // AJOUTE CE CONSTRUCTEUR
  factory Prestataire.fromJson(Map<String, dynamic> json) {
  return Prestataire(
    nom: json['nomp'] ?? '',
    prenom: json['prenomp'] ?? '',
    profession: json['categorie'] ?? '',
    tarifHoraire: double.tryParse(json['tarif_horaire'].toString()) ?? 0.0,
    description: json['description'] ?? '',
     numTel: json['numtel'] ?? '', // AJOUTE CE CHAMP
    photoUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
    id: json['id'], // ou la bonne source
    email: json['email'] ??  json['emailp'] ?? '',
  );
} 
}



// Classe pour gérer le thème de l'application
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Thème clair
  final ThemeData _lightTheme = ThemeData(
    primaryColor: const Color(0xFF00b894),
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF00b894),
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF00b894),
      secondary: const Color(0xFF55efc4),
    ),
  );

  // Thème sombre
  final ThemeData _darkTheme = ThemeData(
    primaryColor: const Color(0xFF00b894),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF00b894),
      secondary: const Color(0xFF55efc4),
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
    ),
    cardColor: const Color(0xFF1E1E1E),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: const Color(0xFF00b894),
      unselectedItemColor: Colors.grey,
    ),
  );
}

class AccueilContent extends StatefulWidget {
  const AccueilContent({super.key});

  @override
  State<AccueilContent> createState() => _AccueilContentState();
}

class _AccueilContentState extends State<AccueilContent> {
  int _selectedIndex = 0;
  String _selectedCategory = "Général"; 
   String? clientId;// new 
   String? clientName;//new 
   List<Demande> _demandes = [];  
   bool _isLoadingDemandes = false;
   Future<void> _fetchDemandes() async {
    if (clientId == null) return;
    setState(() => _isLoadingDemandes = true);
    try {
      final data = await ApiService.getHistoriqueDemandes(clientId!);
       setState(() {
         _demandes = data.map((e) => Demande.fromJson(e)).toList();
        });
    } catch (e) {
       setState(() => _demandes = []);
       print("Erreur lors du chargement de l'historique : $e");
    } finally {
       setState(() => _isLoadingDemandes = false);
      }
    }
           
   @override
  void initState() {//neww
    super.initState();
    _loadClientData(); // 🔥 Charge les infos du client au démarrage
  }  
  Future<void> _loadClientData() async {//neww
    final clientData = await ApiService.getClientInfo(); // 🔥 Nouvelle fonction API
    if (clientData != null) {
      setState(() {
        clientId = clientData['idc'];
        clientName = clientData['nom']; // 🔹 Récupération du nom !
      });
      await _fetchDemandes(); 
    }
  }
  final TextEditingController _searchController = TextEditingController();
  bool _notificationsEnabled = true;

  // Créer une instance du ThemeProvider
  final ThemeProvider _themeProvider = ThemeProvider();

  final List<String> _allCategories = [
    "Général",
    "Plomberie",
    "Électricité",
    "Nettoyage",
    "Déménagement",
    "Bricolage",
    "Assemblage",
    "Jardinage",
    "Peinture",
  ];

  // Updated service data with icons and image URLs
  final Map<String, List<Map<String, dynamic>>> _allServices = {
    "Les plus demandés": [
      {
        "title": "Nettoyage",
        "category": "Nettoyage",
        "icon": Icons.cleaning_services,
        "image":
            "https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=300",
        "rating": 4.8,
        "price": "Dès 25€/h",
      },
      {
        "title": "Plomberie",
        "category": "Plomberie",
        "icon": Icons.plumbing,
        "image":
            "https://images.unsplash.com/photo-1607472586893-edb57bdc0e39?q=80&w=300",
        "rating": 4.7,
        "price": "Dès 40€/h",
      },
    ],
    "Ameublement": [
      {
        "title": "Déménagement",
        "category": "Déménagement",
        "icon": Icons.local_shipping,
        "image":
            "https://images.unsplash.com/photo-1600518464441-9306b00c4ea4?q=80&w=300", // Image modifiée
        "rating": 4.6,
        "price": "Dès 35€/h",
      },
      {
        "title": "Bricolage",
        "category": "Bricolage",
        "icon": Icons.handyman,
        "image":
            "https://images.unsplash.com/photo-1581244277943-fe4a9c777189?q=80&w=300",
        "rating": 4.5,
        "price": "Dès 30€/h",
      },
      {
        "title": "Assemblage",
        "category": "Assemblage",
        "icon": Icons.build,
        "image":
            "https://images.unsplash.com/photo-1530124566582-a618bc2615dc?q=80&w=300",
        "rating": 4.7,
        "price": "Dès 28€/h",
      },
    ],
    "Entretien": [
      {
        "title": "Jardinage",
        "category": "Jardinage",
        "icon": Icons.yard,
        "image":
            "https://images.unsplash.com/photo-1599629954294-14df9f8291b7?q=80&w=300", // Image modifiée
        "rating": 4.8,
        "price": "Dès 32€/h",
      },
      {
        "title": "Peinture",
        "category": "Peinture",
        "icon": Icons.format_paint,
        "image":
            "https://images.unsplash.com/photo-1562259929-b4e1fd3aef09?q=80&w=300",
        "rating": 4.6,
        "price": "Dès 35€/h",
      },
      {
        "title": "Électricité",
        "category": "Électricité",
        "icon": Icons.electrical_services,
        "image":
            "https://images.unsplash.com/photo-1621905251918-48416bd8575a?q=80&w=300",
        "rating": 4.9,
        "price": "Dès 45€/h",
      },
    ],
  };

  

  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedCategory == "Général") {
      return _allServices.values.expand((list) => list).toList();
    } else {
      return _allServices.values
          .expand((list) => list)
          .where((service) => service["category"] == _selectedCategory)
          .toList();
    }
  }

  // Get icon for category
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Plomberie':
        return Icons.plumbing;
      case 'Électricité':
        return Icons.electrical_services;
      case 'Nettoyage':
        return Icons.cleaning_services;
      case 'Déménagement':
        return Icons.local_shipping;
      case 'Bricolage':
        return Icons.handyman;
      case 'Assemblage':
        return Icons.build;
      case 'Jardinage':
        return Icons.yard;
      case 'Peinture':
        return Icons.format_paint;
      default:
        return Icons.home_repair_service;
    }
  }

  Widget _buildServiceCard(Map<String, dynamic> service, BuildContext context) {
    final String title = service["title"]!;
    final isDark = _themeProvider.isDarkMode;

    return Container(
      width: 180,
      height: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
  // Affiche un loader pendant le chargement
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );
  try {
    // Charge dynamiquement les prestataires depuis l'API
    final prestataires = await ChargePrestaApi.fetchPrestataires(categorie: service["category"]);
    Navigator.pop(context); // Ferme le loader
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrestatairesScreen(
          prestation: title,
          prestataires: prestataires,
        ),
      ),
    );
  } catch (e) {
    Navigator.pop(context); // Ferme le loader
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors du chargement des prestataires")),
    );
  }
},
          
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: service["image"],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      height: 120,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isDark ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      height: 120,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(
                        service["icon"] ?? Icons.image_outlined,
                        size: 40,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
              ),
            ),

            // Service details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        service["rating"].toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        service["price"],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
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
    );
  }

  Widget _buildCategoryChip(String category) {
    final bool isSelected = _selectedCategory == category;
    final isDark = _themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : isDark
                  ? const Color(0xFF2A2A2A)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 18,
              color:
                  isSelected
                      ? Colors.white
                      : isDark
                      ? Colors.grey[400]
                      : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: GoogleFonts.poppins(
                color:
                    isSelected
                        ? Colors.white
                        : isDark
                        ? Colors.grey[300]
                        : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccueil() {
    final isDark = _themeProvider.isDarkMode;

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        // Header with greeting and search
        Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    clientName == null ? "Bonjour 👋" : "Bonjour, $clientName 👋",//new
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Show notifications
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Quel service recherchez-vous aujourd'hui ?",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un service....',
                    hintStyle: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.grey[400] : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                      onPressed: () {
                        // Voice search
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),

        // Categories
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catégories",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _allCategories.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildCategoryChip(_allCategories[index]);
                  },
                ),
              ),
            ],
          ),
        ),

        // Services by category
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                _allServices.keys.map((key) {
                  final List<Map<String, dynamic>> currentSectionServices =
                      _filteredServices
                          .where(
                            (service) =>
                                _allServices[key]?.contains(service) ?? false,
                          )
                          .toList();

                  if (currentSectionServices.isNotEmpty ||
                      _selectedCategory == "Général") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              key,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to all services in this category
                              },
                              child: Text(
                                "Voir tous",
                                style: GoogleFonts.poppins(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _selectedCategory == "Général"
                                    ? _allServices[key]!.length
                                    : currentSectionServices.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final service =
                                  _selectedCategory == "Général"
                                      ? _allServices[key]![index]
                                      : currentSectionServices[index];
                              return _buildServiceCard(service, context);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMessagerie() {
    final isDark = _themeProvider.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 80,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            "Messagerie",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Vos conversations apparaîtront ici",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorique() {
  final isDark = _themeProvider.isDarkMode;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Text(
          "Mes demandes",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      Expanded(
        child: _isLoadingDemandes
            ? Center(child: CircularProgressIndicator())
            : _demandes.isEmpty
                ? Center(child: Text("Aucune demande trouvée."))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _demandes.length,
                    itemBuilder: (context, index) {
                      final demande = _demandes[index];
                      

                     

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(
                            Icons.assignment_turned_in,
                            color: Theme.of(context).primaryColor,
                            size: 36,
                          ),
                          title: Text(
                            demande.service,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prestataire : ${demande.prestataire}",
                                style: GoogleFonts.poppins(
                                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                "Date : ${demande.datepresta.substring(0, 10)} – ${demande.heurepresta.substring(0,5)}",
                                style: GoogleFonts.poppins(
                                 color: isDark ? Colors.grey[400] : Colors.grey[700],
                                 fontSize: 13,
                                ),
                              ),

                              Text(
                                "etat prestation : ${demande.etatpresta}",
                                style: GoogleFonts.poppins(
                                  color: demande.etatpresta == "Validée"
                                      ? Colors.green
                                      : (demande.etatpresta== "En attente"
                                          ? Colors.orange
                                          : demande.etatpresta == "Annulée"
                                              ? Colors.red
                                              : Colors.grey),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              if (demande.etatpresta != "Annulée" && demande.etatpresta != "Validée")
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    icon: Icon(Icons.cancel, color: Colors.red),
                                    label: Text("Annuler", style: TextStyle(color: Colors.red)),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Annuler la demande"),
                                          content: Text("Voulez-vous vraiment annuler cette demande ?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Non"),
                                              onPressed: () => Navigator.pop(context, false),
                                            ),
                                            TextButton(
                                              child: Text("Oui"),
                                              onPressed: () => Navigator.pop(context, true),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        final ok = await ApiService.annulerDemande(clientId!, demande.id);
                                        if (ok) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Demande annulée.")),
                                          );
                                          await _fetchDemandes();
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Erreur lors de l'annulation.")),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    ],
  );
}

  // Méthode pour afficher une boîte de dialogue de confirmation
  void _showLogoutConfirmationDialog() {
    final isDark = _themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          title: Row(
            children: [
              Icon(Icons.logout, color: Theme.of(context).primaryColor),
              const SizedBox(width: 10),
              Text(
                "Déconnexion",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            "Êtes-vous sûr de vouloir vous déconnecter ?",
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique de déconnexion
                Navigator.of(context).pop();
                // Rediriger vers la page de connexion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                "Confirmer",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour afficher une boîte de dialogue de confirmation de suppression de compte
  void _showDeleteAccountConfirmationDialog() {
    final isDark = _themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                "Supprimer mon compte",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: Text(
            "Cette action est irréversible. Toutes vos données seront définitivement supprimées. Êtes-vous sûr de vouloir continuer ?",
            style: GoogleFonts.poppins(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Annuler",
                style: GoogleFonts.poppins(
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique de suppression de compte
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Rediriger vers la page de connexion
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                "Supprimer",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfil() {
    final isDark = _themeProvider.isDarkMode;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      children: [
        // En-tête du profil
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/men/32.jpg',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                clientName ?? "Utilisateur inconnu",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "alex.dupont@example.com",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),

        // Options du profil
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildProfileOption(
                Icons.person_outline,
                "Informations personnelles",
                onTap: () {
                  // Navigation vers les informations personnelles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PersonalInformationScreen(
                            themeProvider: _themeProvider,
                          ),
                    ),
                  );
                },
              ),
              _buildDivider(),
              _buildProfileOption(
                Icons.payment_outlined,
                "Moyens de paiement",
                onTap: () {
                  // Navigation vers les moyens de paiement
                },
              ),
              _buildDivider(),
              _buildProfileOption(
                Icons.description_outlined,
                "Conditions générales",
                onTap: () {
                  // Navigation vers les conditions générales
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Paramètres
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  "Mode sombre",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                secondary: Icon(
                  _themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).primaryColor,
                ),
                value: _themeProvider.isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _themeProvider.toggleTheme();
                  });
                  // Appliquer le thème à l'application
                },
              ),
              _buildDivider(),
              _buildProfileOption( 
                Icons.notifications_outlined,
                "Gérer mes notifications",
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
                onTap: () {
                  // Navigation vers les paramètres de notification
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Déconnexion
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    isDark
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _buildProfileOption(
            Icons.logout,
            "Se déconnecter",
            textColor: const Color.fromARGB(255, 250, 37, 22),
            iconColor: const Color.fromARGB(255, 250, 37, 22),
            onTap: _showLogoutConfirmationDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    final isDark = _themeProvider.isDarkMode;

    return Divider(
      height: 1,
      thickness: 1,
      indent: 70,
      endIndent: 20,
      color: isDark ? Colors.grey[800] : Colors.grey[200],
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title, {
    Function()? onTap,
    Widget? trailing,
    Color? textColor,
    Color? iconColor,
  }) {
    final isDark = _themeProvider.isDarkMode;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: textColor ?? (isDark ? Colors.white : Colors.black),
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Appliquer le thème
    final theme = _themeProvider.themeData;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildAccueil(),
            _buildMessagerie(),
            _buildHistorique(),
            _buildProfil(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color:
                _themeProvider.isDarkMode
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) async {
              setState(() {
                _selectedIndex = index;
              });
              if (index == 2) {
               await _fetchDemandes();
             }
             
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                _themeProvider.isDarkMode
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor:
                _themeProvider.isDarkMode ? Colors.grey[600] : Colors.grey,
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  size: 24,
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1 ? Icons.message : Icons.message_outlined,
                  size: 24,
                ),
                label: 'Messagerie',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2 ? Icons.history : Icons.history_outlined,
                  size: 24,
                ),
                label: 'Historique',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3 ? Icons.person : Icons.person_outlined,
                  size: 24,
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
        // Le bouton flottant a été supprimé
      ),
    );
  }
}

// Écran d'informations personnelles
class PersonalInformationScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const PersonalInformationScreen({Key? key, required this.themeProvider})
    : super(key: key);

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  // Contrôleurs pour les champs de texte
  final TextEditingController _firstNameController = TextEditingController(
    text: "Alex",
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: "Dupont",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "alex.dupont@example.com",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "********",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "06 12 34 56 78",
  );
  final TextEditingController _addressController = TextEditingController(
    text: "123 Rue de Paris, 75001 Paris",
  );

  // Date de naissance
  DateTime _birthDate = DateTime(1990, 1, 1);

  // Afficher ou masquer le mot de passe
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeProvider.isDarkMode;
    final theme = widget.themeProvider.themeData;

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Informations personnelles",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo de profil
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/men/32.jpg',
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Modifier la photo",
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Formulaire d'informations personnelles
              Text(
                "Informations de base",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Nom et prénom
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: "Prénom",
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _lastNameController,
                      label: "Nom",
                      icon: Icons.person_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Mot de passe
              _buildTextField(
                controller: _passwordController,
                label: "Mot de passe",
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Date de naissance
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date de naissance",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _birthDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null && picked != _birthDate) {
                                setState(() {
                                  _birthDate = picked;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "${_birthDate.day.toString().padLeft(2, '0')}/${_birthDate.month.toString().padLeft(2, '0')}/${_birthDate.year}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Numéro de téléphone
              _buildTextField(
                controller: _phoneController,
                label: "Numéro de téléphone",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Adresse
              _buildTextField(
                controller: _addressController,
                label: "Adresse",
                icon: Icons.location_on_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 30),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logique de modification des informations
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Informations mises à jour avec succès",
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.save_outlined),
                      label: Text(
                        "Modifier informations",
                        style: GoogleFonts.poppins(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bouton supprimer mon compte
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    // Afficher la boîte de dialogue de confirmation
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              isDark ? const Color(0xFF2A2A2A) : Colors.white,
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Supprimer mon compte",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            "Cette action est irréversible. Toutes vos données seront définitivement supprimées. Êtes-vous sûr de vouloir continuer ?",
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Annuler",
                                style: GoogleFonts.poppins(
                                  color:
                                      isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Logique de suppression de compte
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                // Rediriger vers la page de connexion
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text(
                                "Supprimer",
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  label: Text(
                    "Supprimer mon compte",
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    final isDark = widget.themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          icon: Icon(icon, color: isDark ? Colors.grey[400] : Colors.grey[600]),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

// Classe PrestatairesScreen
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
                          idPrestat: prestataire.id,
                          email: prestataire.email,
                          
                          phone: prestataire.numTel,
                         
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