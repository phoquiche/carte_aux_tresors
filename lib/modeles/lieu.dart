class Lieu{
  String idLieu;
  String idUtilisateur;
  String designation;
  double latitude;
  double longitude;
  String? img;
  String? adresse;
  String? dateVisite;


  Lieu({required this.idLieu, required this.idUtilisateur, required this.designation, required this.latitude, required this.longitude,this.img, this.adresse, this.dateVisite});

  getUid(){
    return idUtilisateur;
  }

  toMap(){
    return {
      'idLieu': idLieu,
      'idUtilisateur': idUtilisateur,
      'designation': designation,
      'latitude': latitude,
      'longitude': longitude,
      'img': img,
      'adresse': adresse,
      'dateVisite': dateVisite
    };
  }

   fromMap(Map<String, dynamic> map){
    idLieu = map['idLieu'];
    idUtilisateur = map['idUtilisateur'];
    designation = map['designation'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    img = map['img'];
    adresse = map['adresse'];
    dateVisite = map['dateVisite'];
  }
}