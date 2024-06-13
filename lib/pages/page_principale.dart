import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';
import 'package:carte_aux_tresors/modeles/gestion_firestore.dart';
import 'dialogue_lieu.dart';
import 'gerer_lieux.dart';

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PagePrincipaleState createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  static const CameraPosition position = CameraPosition(
    target: LatLng(37.33240905, -122.03051211),
    zoom: 12,
  );

  final List<Marker> _marqueurs = [];
  final List<Lieu> _lieux = [];
  _addMarker(LatLng position, String id, String titre) {
    
      if (id == "positionCourante") {
        _marqueurs.add(Marker(
          markerId: MarkerId(id),
          position: position,
          infoWindow: InfoWindow(title: titre),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      } else {
        _marqueurs.add(Marker(
          markerId: MarkerId(id),
          position: position,
          infoWindow: InfoWindow(title: titre),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }
    }
  

  Future<LatLng> _lirePositionActuelle() async {
    Location localisation = Location();
    bool serviceActif;
    PermissionStatus autorisationAccordee;
    LocationData donneesLocalisation;

    try {
      serviceActif = await localisation.serviceEnabled();
      if (!serviceActif) {
        serviceActif = await localisation.requestService();
        if (!serviceActif) {
          return position.target;
        }
      }

      autorisationAccordee = await localisation.hasPermission();
      if (autorisationAccordee == PermissionStatus.denied) {
        autorisationAccordee = await localisation.requestPermission();
        if (autorisationAccordee != PermissionStatus.granted) {
          return position.target;
        }
      }
      donneesLocalisation = await localisation.getLocation();
      return LatLng(
        donneesLocalisation.latitude ?? position.target.latitude,
        donneesLocalisation.longitude ?? position.target.longitude,
      );
    } catch (e) {
      return position.target;
    }
  }

  void _initialiserMarqueur() async {
    _marqueurs.clear(); 
    final LatLng positionActuelle = await _lirePositionActuelle();
    _addMarker(positionActuelle, "positionCourante", "Position actuelle");
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;
    setState(() {
      GestionFirestore.lireLieux().then((lieux) {
        setState(() {
          _lieux.clear();
          _lieux.addAll(lieux);
          for (Lieu lieu in _lieux) {
            if (lieu.idUtilisateur == uid ){
              _addMarker(LatLng(lieu.latitude, lieu.longitude), lieu.idLieu, lieu.designation);
            }
            else{
              continue;
            }
          }
        });
      });
    });
  }

  void deconnecter() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _initialiserMarqueur();
  }

  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Carte aux trésors'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return  Dialogue(estNouveau: true);
                  },
                );
                setState(() {
                  _initialiserMarqueur();
                });
              },
            ),
            //menu déroulant
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: Text('Refresh'),
                    value: 'Refresh',
                  ),
                  const PopupMenuItem(
                    child: Text('Details Lieu'),
                    value: 'details',
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 'refresh') {
                  _initialiserMarqueur();
                }
                else if (value == 'details') {
                  
              final value = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailLieux()),
              );
              setState(() {
                _initialiserMarqueur();
              });
                }
              },
            ),
          ]
        ),

        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GoogleMap(
            initialCameraPosition: position,
            markers: _marqueurs.toSet(),
          ),
        ),
      ),
    );
  }
}
