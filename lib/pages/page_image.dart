import 'package:flutter/material.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';
import 'package:carte_aux_tresors/modeles/gestion_firestore.dart';
import 'dart:io';

class PageImage extends StatelessWidget {
  final String img;
  final Lieu lieu;

  const PageImage({required this.img, required this.lieu});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo prise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              lieu.img = img;
              await GestionFirestore.ajouterLieu(lieu);
             
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Image.file(File(img)),
    );
  }
}
