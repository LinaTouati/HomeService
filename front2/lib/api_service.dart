import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // 🔹 Fonction pour inscrire un utilisateur
  static Future<Map<String, dynamic>?> inscrireUtilisateur({
    required String nom,
    required String prenom,
    required String numeroTelephone,
    required String email,
    required String motDePasse,
    required String dateNaissance,
    required String adresse,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/auth/register');

      final Map<String, dynamic> body = {
        "nom": nom,
        "prenom": prenom,
        "numero_telephone": numeroTelephone,
        "email": email,
        "mot_de_passe": motDePasse,
        "date_naissance": dateNaissance,
        "adresse": adresse,
      };

      print("📡 Envoi vers : $url");
      print("📩 Données envoyées : ${jsonEncode(body)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      print("📩 Réponse brute du serveur : ${response.body}"); // 🔥 Debug

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        if (responseData != null &&
            responseData.containsKey("user") &&
            responseData["user"].containsKey("idc")) {
          
          final String clientId = responseData["user"]["idc"].toString();
          print("✅ Inscription réussie - Client ID: $clientId");

          await saveClientId(clientId); // 🔥 Enregistrement de l'ID

          return responseData; // 🔥 Ajout du retour correct pour le frontend
        } else {
          print("⚠️ Impossible de récupérer l'ID du client. Vérifie la réponse du serveur !");
          return null;
        }
      } else {
        print("❌ Erreur (${response.statusCode}) : ${response.body}");
        return null;
      }
    } catch (error) {
      print("❌ Exception : $error");
      return null;
    }
  }

  // 🔹 Fonction pour enregistrer l'ID du client après inscription
  static Future<void> saveClientId(String clientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('client_id', clientId);
    print("📝 ID Client enregistré localement : $clientId");
  }

  // 🔹 Fonction pour récupérer l'ID du client
  static Future<String?> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('client_id');
  }

  // 🔹 Fonction pour récupérer les infos du client connecté
 static Future<Map<String, dynamic>?> getClientInfo() async {
  final String? clientId = await getClientId();

  if (clientId == null) {
    print("⚠️ Aucun client connecté.");
    return null;
  }

  try {
    final url = Uri.parse('$baseUrl/client/$clientId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("✅ Infos client récupérées !");
      final data = jsonDecode(response.body);

      // Vérifie que la réponse contient bien 'idc' et 'nom'
      if (data != null && data.containsKey('idc') && data.containsKey('nom')) {
        return {
          'idc': data['idc'].toString(),
          'nom': data['nom'].toString(),
        };
      } else {
        print("⚠️ Réponse inattendue du serveur : $data");
        return null;
      }
    } else {
      print("❌ Erreur (${response.statusCode}) : ${response.body}");
      return null;
    }
  } catch (error) {
    print("❌ Exception : $error");
    return null;
  }
}
   static Future<List<Map<String, dynamic>>> getHistoriqueDemandes(String clientId) async {
    final url = Uri.parse('$baseUrl/prestation/historique/$clientId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Réponse historique:  ${response.statusCode} - ${response.body}");
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Erreur lors du chargement de l\'historique');
    }
  }
  static Future<bool> annulerDemande(String clientId, int idDemande) async {
  final url = Uri.parse('http://localhost:3000/prestation/annuler/$clientId/$idDemande');
  final response = await http.put(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
}
