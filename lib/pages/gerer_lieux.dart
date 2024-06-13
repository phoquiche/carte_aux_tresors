import 'package:carte_aux_tresors/pages/dialogue_lieu.dart';
import 'package:flutter/material.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';
import 'package:carte_aux_tresors/modeles/gestion_firestore.dart';
import 'page_principale.dart';  
import 'package:firebase_auth/firebase_auth.dart';

class DetailLieux extends StatefulWidget {


  const DetailLieux({Key? key}) : super(key: key);

  @override
  _DetailLieuxState createState() => _DetailLieuxState();
}

class _DetailLieuxState extends State<DetailLieux>{
  final _lieux = <Lieu>[];
  void getLieuUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    final lieux = await GestionFirestore.lireLieux();
    setState(() {
      _lieux.clear();
      _lieux.addAll(lieux.where((lieu) => lieu.idUtilisateur == uid));
    });
  }
  @override
  void initState() {
    super.initState();
    getLieuUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail des lieux'),
      ),
      body: ListView.builder(
        itemCount: _lieux.length,
        itemBuilder: (context, index) {
          return Dismissible(
        key: Key(_lieux[index].idLieu),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: Icon(Icons.delete, color: Colors.white),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16.0),
        ),
        onDismissed: (direction) {
          setState(() {
            GestionFirestore.supprimerLieu(_lieux[index].idLieu);
            _lieux.removeAt(index);
          });
        },
        child: ListTile(
          title: Text(_lieux[index].designation),
          subtitle: Text('Latitude: ${_lieux[index].latitude} - Longitude: ${_lieux[index].longitude}'),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialogue(estNouveau: false, lieu: _lieux[index]);
            },
          ).then((_) {
            getLieuUser();
          });
            },
          ),
        ),
          );
        },
      ),
      );
  }
}