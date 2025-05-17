import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'demande_service_api.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

// Écran de profil du prestataire
class ProviderProfileScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String profession;
  
  
  final String phone;
  final String email;
  final String description;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final double hourlyRate;
  final bool isVerified;
  final int? idPrestat;

  const ProviderProfileScreen({
    Key? key,
    required this.name,
    required this.surname,
    required this.profession,
    
    
    this.phone = "+213 555 12 34 56",
    required this.email,
    required this.description,
    this.rating = 4.9,
    this.reviewCount = 185,
    required this.imageUrl,
    required this.hourlyRate,
    this.isVerified = true,
    this.idPrestat, // plus de "required 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil du Prestataire'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section with Blue Gradient
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$name $surname',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profession,
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (isVerified)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.verified, color: Colors.greenAccent),
                        SizedBox(width: 4),
                        Text(
                          'Prestataire Vérifié',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Contact Information Section with Blue Accents
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations de Contact',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      ListTile(
                        leading: Icon(
                          Icons.phone_outlined,
                          color: Colors.blue[500],
                        ),
                        title: const Text('Téléphone'),
                        subtitle: Text(phone),
                        contentPadding: EdgeInsets.zero,
                      ),
                      Divider(thickness: 1, color: Colors.blue[200]),
                      ListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          color: Colors.blue[500],
                        ),
                        title: const Text('Email'),
                        subtitle: Text(email),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // About Section with Rating and Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'À Propos de Moi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 24,
                            ignoreGestures: true,
                            itemBuilder:
                                (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '($reviewCount avis)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tarif horaire: ${hourlyRate.toStringAsFixed(2)} €',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Request Service Button navigates to the form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ServiceRequestFormScreen(
                            providerName: '$name $surname',
                            providerImage: imageUrl,
                            profession: profession,
                            hourlyRate: hourlyRate,
                            idPrestat: idPrestat!, // PAS null, PAS 0
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Demander un Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Formulaire de demande de service
class ServiceRequestFormScreen extends StatefulWidget {
  final String providerName;
  final String providerImage;
  final String profession;
  final double hourlyRate; 
   final int idPrestat; // Ajoute ceci  

  const ServiceRequestFormScreen({
    Key? key,
    required this.providerName,
    this.providerImage = "https://randomuser.me/api/portraits/men/32.jpg",
    this.profession = "Prestataire de service",
    this.hourlyRate = 45.0, 
    required this.idPrestat, // Ajoute ceci  
  }) : super(key: key);

  @override
  _ServiceRequestFormScreenState createState() =>
      _ServiceRequestFormScreenState();
}

class _ServiceRequestFormScreenState extends State<ServiceRequestFormScreen> {
  // Contrôleurs et variables d'état
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TextEditingController serviceDetailsController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedDuration = "2 heures";
  bool isUrgent = false;
  int selectedPaymentMethod = 0;
  bool acceptTerms = false;

  // Options pour la durée estimée
  final List<String> durations = [
    "1 heure",
    "2 heures",
    "3 heures",
    "4 heures",
    "Journée complète",
  ];

  // Méthodes de paiement
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Carte bancaire", "icon": Icons.credit_card},
    {"name": "Espèces", "icon": Icons.money},
    {"name": "PayPal", "icon": Icons.account_balance_wallet},
  ];

  // Calculer le coût estimé
  double get estimatedCost {
    if (selectedDuration == "Journée complète") {
      return widget.hourlyRate * 8; // Journée de 8 heures
    } else {
      int hours = int.parse(selectedDuration.split(" ")[0]);
      return widget.hourlyRate * hours;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Demande de Service',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Header curved background
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(widget.providerImage),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.providerName,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.profession,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "${widget.hourlyRate.toStringAsFixed(0)}€/heure",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Section title
                _buildSectionTitle("Détails du service"),

                const SizedBox(height: 16),

                // Service description
                TextField(
                  controller: serviceDetailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Décrivez le service dont vous avez besoin',
                    hintText:
                        'Ex: J\'ai besoin d\'aide pour réparer ma prise électrique qui ne fonctionne plus...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue[700]!,
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                  ),
                ),

                const SizedBox(height: 24),

                // Section title
                _buildSectionTitle("Adresse"),

                const SizedBox(height: 16),

                // Address field
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Adresse complète',
                    hintText: 'Ex: 123 Rue de Paris, 75001 Paris',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue[700]!,
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.blue[700]),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.blue[700],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Section title
                _buildSectionTitle("Date et heure"),

                const SizedBox(height: 16),

                // Date and time selection
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedDate == null
                                      ? 'Choisir une date'
                                      : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(selectedDate!),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        selectedDate == null
                                            ? Colors.grey[600]
                                            : Colors.black,
                                  ),
          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedTime == null
                                      ? 'Choisir une heure'
                                      : selectedTime!.format(context),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        selectedTime == null
                                            ? Colors.grey[600]
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Section title
                _buildSectionTitle("Durée estimée"),

                const SizedBox(height: 16),

                // Duration selection
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: durations.length,
                    itemBuilder: (context, index) {
                      final duration = durations[index];
                      final isSelected = selectedDuration == duration;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDuration = duration;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[700] : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.blue[700]!
                                      : Colors.grey[300]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              duration,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Urgency toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUrgent ? Colors.red[50] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUrgent ? Colors.red[300]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.priority_high,
                        color: isUrgent ? Colors.red : Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service urgent',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: isUrgent ? Colors.red : Colors.black,
                              ),
                            ),
                            Text(
                              'Priorité dans les 24h (+15% de frais)',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isUrgent,
                        onChanged: (value) {
                          setState(() {
                            isUrgent = value;
                          });
                        },
                        activeColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section title
                _buildSectionTitle("Méthode de paiement"),

                const SizedBox(height: 16),

                // Payment methods
                Column(
                  children: List.generate(
                    paymentMethods.length,
                    (index) => RadioListTile(
                      title: Row(
                        children: [
                          Icon(paymentMethods[index]["icon"], size: 24),
                          const SizedBox(width: 12),
                          Text(
                            paymentMethods[index]["name"],
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),
                      value: index,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value as int;
                        });
                      },
                      activeColor: Colors.blue[700],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Price estimation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimation du coût',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tarif horaire',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            '${widget.hourlyRate.toStringAsFixed(0)}€/h',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Durée estimée',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            selectedDuration,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (isUrgent) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Supplément urgence (15%)',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            Text(
                              '+${(estimatedCost * 0.15).toStringAsFixed(0)}€',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total estimé',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${(isUrgent ? estimatedCost * 1.15 : estimatedCost).toStringAsFixed(0)}€',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Le montant final peut varier en fonction de la durée réelle du service',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Terms and conditions
                Row(
                  children: [
                    Checkbox(
                      value: acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptTerms = value!;
                        });
                      },
                      activeColor: Colors.blue[700],
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'J\'accepte les ',
                          style: GoogleFonts.poppins(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'conditions générales',
                              style: GoogleFonts.poppins(
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' et la '),
                            TextSpan(
                              text: 'politique de confidentialité',
                              style: GoogleFonts.poppins(
                                color: Colors.blue[700],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
           onPressed: () async {
  if (selectedDate != null &&
      selectedTime != null &&
      serviceDetailsController.text.isNotEmpty &&
      addressController.text.isNotEmpty &&
      acceptTerms) {
    // Formatage des données
    final dateStr = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final heureStr = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}:00";

    // Récupère l'id du client connecté
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? idClient = prefs.getInt('user_id');
    if (idClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté')),
      );
      return;
    }

    // Vérifie l'id du prestataire
    final int idPrestat = widget.idPrestat;
    if (idPrestat == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : id du prestataire manquant')),
      );
      return;
    }

    // Debug print
    print('Envoi demande avec : date=$dateStr, heure=$heureStr, idc=$idClient, idPrestat=$idPrestat, adresse=${addressController.text}');

    final success = await DemandeServiceApi.demanderPrestation(
      date: dateStr,
      heure: heureStr,
      idClient: idClient,
      idPrestat: idPrestat,
      adresse: addressController.text,
      etatpresta: "en attente", // AJOUTE CETTE LIGNE
    );

    if (success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 16),
              Text(
                'Demande envoyée !',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Votre demande a été envoyée à ${widget.providerName}. Vous recevrez une confirmation prochainement.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Retour à l\'accueil',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de l\'envoi de la demande',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } else {
    // Afficher un message d'erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Veuillez remplir tous les champs obligatoires et accepter les conditions',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Confirmer la demande',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }
}
