import 'package:flutter/material.dart';
import 'acceuil.dart';
import 'api_service.dart'; 
import'connexion.dart';

class Inscriptionclient extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Inscriptionclient({Key? key, required this.userData}) : super(key: key);

  @override
  InscriptionClientState createState() => InscriptionClientState();
}

class InscriptionClientState extends State<Inscriptionclient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 🔹 Fonction pour gérer l'inscription
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await ApiService.inscrireUtilisateur(
          nom: widget.userData['nom'],
          prenom: widget.userData['prenom'],
          numeroTelephone: widget.userData['numero_telephone'],
          email: widget.userData['email'],
          motDePasse: _passwordController.text,
          dateNaissance: widget.userData['date_naissance'],
          adresse: "",
        );

        print("📩 Réponse brute reçue du serveur : $response"); // 🔥 Debugging

        setState(() {
          _isLoading = false;
        });

        if (response != null && response.containsKey("user") && response["user"].containsKey("idc")) {
          final String clientId = response["user"]["idc"].toString(); // 🔥 Correction de l'accès à l'ID
          print("✅ Inscription réussie - Client ID: $clientId");
          _showSuccessDialog(clientId);
        } else {
          print("⚠️ La structure de `response` ne contient pas `user` ou `idc`. Vérifie les données !");
          _showErrorDialog("Échec de l'inscription. Vérifiez la réponse du serveur !");
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print("❌ Exception capturée : $error"); // 🔥 Debugging
        _showErrorDialog("Une erreur s'est produite : $error");
      }
    }
  }

  // 🔹 Affichage du succès d'inscription
  void _showSuccessDialog(String clientId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Inscription réussie !'),
          content: Text(
            'Votre compte a été créé avec succès.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()), // ✅
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Définissez votre mot de passe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Créer un mot de passe sécurisé pour votre compte',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'Mot de passe',
                    hint: 'Entrez votre mot de passe',
                    obscureText: _obscurePassword,
                    toggleObscure: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez un mot de passe';
                      }
                      if (value.length < 8) {
                        return 'Le mot de passe doit contenir au minimum 8 caractères';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Le mot de passe doit contenir au minimum une majuscule';
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Le mot de passe doit contenir au minimum un chiffre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirmer mot de passe',
                    hint: 'Confirmez votre mot de passe',
                    obscureText: _obscureConfirmPassword,
                    toggleObscure: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirmez votre mot de passe';
                      }
                      if (value != _passwordController.text) {
                        return 'Les mots de passe ne correspondent pas';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Critères de mot de passe:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        _PasswordRequirement(text: 'Au minimum 8 caractères'),
                        _PasswordRequirement(
                          text: 'Au minimun une lettre en majuscule (A-Z)',
                        ),
                        _PasswordRequirement(
                          text: 'Au minimum un chiffre(0-9)',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 34, 31, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'S\'inscrire',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccueilContent(),
                        ),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Avez-vous déja un compte? ",
                        style: TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Se connecter",
                            style: TextStyle(
                              color: Color.fromARGB(255, 34, 31, 230),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _navigateToHome,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 34, 31, 230),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Retour',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 34, 31, 230),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback toggleObscure,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleObscure,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 34, 31, 230),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16),
          validator: validator,
        ),
      ],
    );
  }
}

class _PasswordRequirement extends StatelessWidget {
  final String text;

  const _PasswordRequirement({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}