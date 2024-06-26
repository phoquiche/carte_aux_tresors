import 'package:carte_aux_tresors/pages/page_principale.dart';
import 'package:flutter/material.dart';
import 'package:carte_aux_tresors/pages/page_connexion.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async  {
  runApp(const MainApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PageConnexion(),
          
  
      
    );
  }
}
