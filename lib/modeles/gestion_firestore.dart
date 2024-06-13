import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';



class GestionFirestore{
  static Future<void> ajouterLieu(Lieu lieu) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection('lieux').doc(lieu.idLieu).set(lieu.toMap());
  }

  static Future<void> supprimerLieu(String idLieu) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection('lieux').doc(idLieu).delete();
  }

  static Future<List<Lieu>> lireLieux() async {
    await Firebase.initializeApp();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('lieux').get();
    List<Lieu> lieux = [];
    querySnapshot.docs.forEach((doc) {
      Lieu lieu = Lieu( idLieu: '1', idUtilisateur: '1', designation: '1', latitude: 1, longitude: 1, img: '1', dateVisite: "1");
      lieu.fromMap(doc.data() as Map<String, dynamic>);
      lieux.add(lieu);
    });
    return lieux;
  }
}