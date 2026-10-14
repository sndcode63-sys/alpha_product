import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_dialogs.dart';
import '../core/app_theme.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late List<List<Offset>> strokes;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    strokes = args is List<List<Offset>> ? args.map((e) => List<Offset>.from(e)).toList() : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Signature')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Customer se neeche box me signature karwao',
                style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onPanStart: (d) => setState(() => strokes.add([d.localPosition])),
                    onPanUpdate: (d) => setState(() => strokes.last.add(d.localPosition)),
                    child: CustomPaint(painter: SignaturePainter(strokes), size: Size.infinite),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => setState(strokes.clear), child: const Text('Clear')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (strokes.isEmpty) {
                        AppDialogs.snack('Signature', 'Pehle signature karo', type: SnackType.warning);
                        return;
                      }
                      Get.back(result: strokes);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final bool fit;
  SignaturePainter(this.strokes, {this.fit = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // fit=true: preview ke liye signature ko chhote box me scale karta hai
    double scale = 1, dx = 0, dy = 0;
    if (fit && strokes.isNotEmpty) {
      final pts = strokes.expand((e) => e).toList();
      final minX = pts.map((e) => e.dx).reduce((a, b) => a < b ? a : b);
      final maxX = pts.map((e) => e.dx).reduce((a, b) => a > b ? a : b);
      final minY = pts.map((e) => e.dy).reduce((a, b) => a < b ? a : b);
      final maxY = pts.map((e) => e.dy).reduce((a, b) => a > b ? a : b);
      final w = (maxX - minX).clamp(1, double.infinity);
      final h = (maxY - minY).clamp(1, double.infinity);
      scale = ((size.width - 24) / w).clamp(0, (size.height - 24) / h).toDouble();
      dx = (size.width - w * scale) / 2 - minX * scale;
      dy = (size.height - h * scale) / 2 - minY * scale;
    }
    Offset t(Offset o) => Offset(o.dx * scale + dx, o.dy * scale + dy);

    for (final s in strokes) {
      if (s.length == 1) {
        canvas.drawPoints(PointMode.points, [t(s.first)], paint);
        continue;
      }
      final path = Path()..moveTo(t(s.first).dx, t(s.first).dy);
      for (final p in s.skip(1)) {
        path.lineTo(t(p).dx, t(p).dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter old) => true;
}
