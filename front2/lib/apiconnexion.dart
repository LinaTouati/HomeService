import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://localhost:3000";

// Dans votre fichier Dart (api_service.dart)
Future<Map<String, dynamic>?> connecterUtilisateur({
  required String email,
  required String motDePasse,
}) async {
  try {
    // Modification ici - enlevez '/user' pour matcher votre route Express
    final url = Uri.parse('$baseUrl/login'); 
    
    print("🌐 Tentative de connexion vers: ${url.toString()}");
    print("📩 Données envoyées: {email: $email, motDePasse: ****}");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email.trim().toLowerCase(),
        "mot_de_passe": motDePasse,
      }),
    ).timeout(const Duration(seconds: 10));

    print("📩 Réponse reçue: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Échec de la connexion');
    }
  } catch (e) {
    print("❌ Erreur de connexion: $e");
    rethrow;
  }
}