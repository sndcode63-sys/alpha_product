import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'signature_screen.dart';

/// Full-screen photo / signature viewer (pinch to zoom).
/// arguments: {'title': String, 'strokes': List<List<Offset>>? }
class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map;
    final strokes = args['strokes'] as List<List<Offset>>?;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(args['title'] as String? ?? 'Preview'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: strokes != null
              ? Container(
                  margin: const EdgeInsets.all(16),
                  height: 240,
                  width: double.infinity,
                  color: Colors.white,
                  child: CustomPaint(painter: SignaturePainter(strokes, fit: true)),
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.image_outlined, size: 120, color: Colors.white54),
                    SizedBox(height: 12),
                    Text('Photo yahan dikhegi (API se image URL lagao)', style: TextStyle(color: Colors.white70)),
                  ],
                ),
        ),
      ),
    );
  }
}
