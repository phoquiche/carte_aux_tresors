import 'package:carte_aux_tresors/pages/page_camera.dart';
import 'package:flutter/material.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';
import 'package:carte_aux_tresors/modeles/gestion_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';


class Dialogue extends StatefulWidget {
  final bool estNouveau;
   Lieu? lieu;
  
   Dialogue({Key? key, required this.estNouveau, this.lieu}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DialogueState createState() => _DialogueState();
}
class _DialogueState extends State<Dialogue> {
  
  

  @override
  Widget build(BuildContext context) {
     supprimerLieu(String idLieu) {
      GestionFirestore.supprimerLieu(idLieu);
    }
    Widget afficherImage(Lieu lieu) {
  if (lieu.img != null && lieu.img!.isNotEmpty) {
    return Image.file(File(lieu.img!));
  } else {
    return Container();
  }
}


    if (widget.estNouveau){
      final TextEditingController nomController = TextEditingController();
      final TextEditingController latitudeController = TextEditingController();
      final TextEditingController longitudeController = TextEditingController();
    return AlertDialog(
      title: const Text('Ajouter un lieu'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: 'Nom du lieu'),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            final id = nomController.text;
            final latitude = double.tryParse(latitudeController.text);
            final longitude = double.tryParse(longitudeController.text);
            final uid = FirebaseAuth.instance.currentUser!.uid;

            if (id.isNotEmpty && latitude != null && longitude != null  ) {
              final lieu = Lieu(idLieu: id, idUtilisateur: uid, designation:  id, latitude: latitude,longitude: longitude,img: 'img', dateVisite: 'dateVisite');
              GestionFirestore.ajouterLieu(lieu);
              Navigator.of(context).pop();
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Erreur'),
                  content: const Text('Veuillez remplir tous les champs correctement.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
    }
    else if(!widget.estNouveau){
      final TextEditingController nomController = TextEditingController()..text = widget.lieu!.designation;
      final TextEditingController latitudeController = TextEditingController()..text = widget.lieu!.latitude.toString();
      final TextEditingController longitudeController = TextEditingController()..text = widget.lieu!.longitude.toString();
      return AlertDialog(
      title: const Text('Modifier un lieu'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: 'Nom du lieu'),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),

            afficherImage(widget.lieu!),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageCamera(lieu: widget.lieu!)),
                );
              },
              icon: const Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            final id = nomController.text;
            final latitude = double.tryParse(latitudeController.text);
            final longitude = double.tryParse(longitudeController.text);
            final uid = FirebaseAuth.instance.currentUser!.uid;

            if (id.isNotEmpty && latitude != null && longitude != null  ) {
              final lieu = Lieu(idLieu: id, idUtilisateur: uid, designation:  id, latitude: latitude,longitude: longitude,img: 'img', dateVisite: 'dateVisite');
              GestionFirestore.ajouterLieu(lieu);
              supprimerLieu(widget.lieu!.idLieu);
              Navigator.of(context).pop();
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Erreur'),
                  content: const Text('Veuillez remplir tous les champs correctement.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Modifier'),
        ),
      ],
    );

    }
    else{
      return const AlertDialog(
      );
    }

  }
 
    
    
  }
  
