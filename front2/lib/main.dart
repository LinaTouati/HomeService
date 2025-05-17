import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_application_1/bienvenue.dart';
import 'package:shimmer/main.dart';
import 'devenirpresta.dart';
import 'bienvenue.dart';
import 'accueilpresta.dart';
import 'inscriptionpresta2.dart';
import 'listepresta.dart';
import 'profilpresta.dart';
import 'acceuil.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // active useulement en debug
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      title: 'Home Service',
      home: AccueilContent(),
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 34, 31, 230)),
      initialRoute: '/homeScreen',
      routes: {
        '/homeScreen': (context) => const HomeScreen(),
        '/inscriptionPresta': (context) => const InscriptionPresta(),
        '/accueilPresta': (context) => const AccueilPresta(prestataireId:"ID_EXEMPLE"),
      },
      // Pour la deuxième page d'inscription, nous utilisons onGenerateRoute car elle nécessite des arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/inscriptionPresta2') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => InscriptionPresta2(userData: args),
          );
        }
        return null;
      },
    );
  }
}
