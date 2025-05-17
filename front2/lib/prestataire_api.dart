import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://localhost:3000";

Future<Map<String, dynamic>?> inscrirePrestataire({
  required String nomp,
  required String prenomp,
  required String numtel,
  required String emailp,
  required String mdp,
  required String dateNaiss,
  required String categorie,
  required String description,
  required double tarifHoraire,
}) async {
  try {
    final url = Uri.parse('$baseUrl/prestataire/register');

    final Map<String, dynamic> body = {
      "nomp": nomp,
      "prenomp": prenomp,
      "numtel": numtel,
      "emailp": emailp,
      "mdp": mdp,
      "date_naiss": dateNaiss,
      "categorie": categorie,
      "description": description,
      "tarif_horaire": tarifHoraire,
    };

    print("📡 Envoi vers : $url");
    print("📩 Données : ${jsonEncode(body)}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print("✅ Inscription réussie - Prestataire ID: ${responseData['prestataire']['id']}");
      return responseData;
    } else {
      print("❌ Erreur (${response.statusCode}) : ${response.body}");
      return null;
    }
  } catch (e) {
    print("❌ Exception lors de la requête : $e");
    return null;
  }
}
