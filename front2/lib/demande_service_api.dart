import 'dart:convert';
import 'package:http/http.dart' as http;

class DemandeServiceApi {
  static Future<bool> demanderPrestation({
    required String date,
    required String heure,
    required int idClient,
    required int idPrestat,
    required String adresse, 
     required String etatpresta, // AJOUTE CE PARAMÈTRE
  }) async {
    final url = 'http://localhost:3000/prestation/demander';
    print('Envoi POST $url');
    print('Body envoyé : ${jsonEncode({
      "datepresta": date,
      "heurepresta": heure,
      "idc": idClient,
      "idprestat": idPrestat,
      "adresse": adresse, 
      "etatpresta": etatpresta, // AJOUTE ICI
    })}');
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "datepresta": date,
        "heurepresta": heure,
        "idc": idClient,
        "idprestat": idPrestat,
        "adresse": adresse,
        "etatpresta": etatpresta,   // ✅ il faut l'ajouter ici aussi
      }),
    );
    print('Status code reçu : ${response.statusCode}');
    print('Réponse brute : ${response.body}');
    return response.statusCode == 201;
  }
}