import 'dart:convert';
import 'package:http/http.dart' as http;
import 'acceuil.dart'; // Pour la classe Prestataire

class ChargePrestaApi {
  static Future<List<Prestataire>> fetchPrestataires({String? categorie}) async {
    // Mets l'URL de ton backend ici
    final url = categorie == null
        ? 'http://localhost:3000/prestataire/prestataires'
        : 'http://localhost:3000/prestataire/prestataires?categorie=$categorie';

    print('URL appelée: $url'); // <-- Ajout du print 

    final response = await http.get(Uri.parse(url));
    print('Status code: ${response.statusCode}'); // <-- Ajout du print
    print('Réponse: ${response.body}'); // <-- Ajout du print

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Prestataire.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des prestataires');
    }
  }
}