import 'package:flutter/material.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// ignore: depend_on_referenced_packages
// import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import 'package:face_app/widgets/face_painter.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  XFile? openImage;
  dynamic image;
  List<Face> _faces = [];

  void pickImage() async {
    openImage = null;
    openImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (openImage != null) {
      image = await decodeImageFromList(await openImage!.readAsBytes());
      setState(() {});
      detectFaces();
    }
  }

  void pickImageCamera() async {
    openImage = null;
    openImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (openImage != null) {
      image = await decodeImageFromList(await openImage!.readAsBytes());
      setState(() {});
      detectFaces();
    }
  }

  void detectFaces() async {
    final faces = await _faceDetector.processImage(
      InputImage.fromFilePath(openImage!.path),
    );
    _faces = [...faces];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Detector"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: image != null
                      ? CustomPaint(
                          painter: FacePainter(_faces, image),
                          size: Size(
                              image.width.toDouble(), image.height.toDouble()),
                        )
                      : const Center(
                          child: Text(
                            "Pick Image to detect faces",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ),
              ),
            ),
            Text(
              "Total Faces : ${_faces.length}",
              style: const TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickImage(),
        child: Icon(Icons.image),
      ),
    );
  }
}
