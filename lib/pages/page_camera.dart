import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'page_image.dart';
import 'package:carte_aux_tresors/modeles/lieu.dart';

class PageCamera extends StatefulWidget {
  final Lieu lieu;

  const PageCamera({required this.lieu});

  @override
  _PageCameraState createState() => _PageCameraState();
}

class _PageCameraState extends State<PageCamera> {
  late Lieu lieu;
  late CameraController _controleur;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  CameraPreview? apercuCamera;
  Image? image;

  @override
  void initState() {
    super.initState();
    lieu = widget.lieu;
    definirCamera();
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  Future<void> definirCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      camera = cameras.first;
      _controleur = CameraController(camera, ResolutionPreset.medium);
      await _controleur.initialize();
      setState(() {
        apercuCamera = CameraPreview(_controleur);
      });
    } else {
      print('Aucune caméra disponible');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prendre une photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () async {
              
                final chemin = join(
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );
                final XFile fichierImage = await _controleur.takePicture();
                fichierImage.saveTo(chemin);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageImage(
                      img: chemin,
                      lieu: lieu,
                    ),
                  ),
                );
            },
          ),
        ],
      ),
      body: apercuCamera != null
          ? Container(child: apercuCamera)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
