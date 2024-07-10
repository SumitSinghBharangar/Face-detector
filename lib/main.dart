import 'package:face_app/screens/image_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FaceApp());
}

class FaceApp extends StatelessWidget {
  const FaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
