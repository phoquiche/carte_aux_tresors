import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'page_principale.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({super.key});

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  String? _idUtilisateur;
  String? _mdpUtilisateur;
  String? _emailUtilisateur;

  bool _estConnectable = true;
  String? _message;

  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMdp = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtEmail = TextEditingController();
    txtMdp = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              saisirEmail(),
              const SizedBox(height: 20),
              saisirMdp(),
              const SizedBox(height: 10),
              boutonPrincipal(),
              boutonSecondaire(),
              const SizedBox(height: 20),
              messageValidation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget saisirEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          hintText: 'Adresse mail',
          icon: Icon(Icons.mail),
        ),
      ),
    );
  }

  Widget saisirMdp() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: txtMdp,
        keyboardType: TextInputType.visiblePassword,
        decoration: const InputDecoration(
          hintText: 'Mot de passe',
          icon: Icon(Icons.lock),
        ),
      ),
    );
  }

  Widget boutonPrincipal() {
    return ElevatedButton(
      onPressed: () {
        soumettre();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 3,
        backgroundColor: Colors.blue,
      ),
      child: Text(_estConnectable ? 'Se connecter' : 'S\'inscrire'),
    );
  }

  Widget boutonSecondaire() {
    return TextButton(
      onPressed: () {
        setState(() {
          _estConnectable = !_estConnectable;
        });
      },
      child: Text(_estConnectable ? 'S\'inscrire' : 'Se connecter'),
    );
  }

  Widget messageValidation() {
    if (_message != null) {
      return Text(
        _message!,
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future soumettre() async {
    setState(() {
      _message = "";
    });
    try {
      if (_estConnectable) {
        _emailUtilisateur = txtEmail.text;
        _mdpUtilisateur = txtMdp.text;
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailUtilisateur ?? "",
          password: _mdpUtilisateur ?? "",
        );
        _idUtilisateur = credential.user?.uid;
      } else {
        _emailUtilisateur = txtEmail.text;
        _mdpUtilisateur = txtMdp.text;
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailUtilisateur ?? "",
                password: _mdpUtilisateur ?? "");
        _idUtilisateur = credential.user?.uid;
      }
      if (_idUtilisateur != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PagePrincipale()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message;
      });
    }
  }
}