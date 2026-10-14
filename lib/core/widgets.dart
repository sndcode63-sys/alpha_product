import 'package:flutter/material.dart';

import 'app_theme.dart';

String two(int n) => n.toString().padLeft(2, '0');

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '${two(h)}:${two(d.minute)} ${d.hour >= 12 ? 'PM' : 'AM'}';
}

String fmtDate(DateTime d) {
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${two(d.day)} ${m[d.month - 1]} ${d.year}';
}

String fmtClock(Duration d) => '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';

String fmtHm(Duration d) => '${d.inHours}h ${two(d.inMinutes % 60)}m';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const StatusChip(this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const InfoRow(this.icon, this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const StatTile(this.icon, this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.muted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

/// Camera/photo placeholder (selfie, delivery proof). Replace onTap with image_picker later.
class PhotoBox extends StatelessWidget {
  final bool taken;
  final String emptyLabel;
  final String takenLabel;
  final IconData icon;
  final VoidCallback onTap;

  const PhotoBox({
    super.key,
    required this.taken,
    required this.onTap,
    this.emptyLabel = 'Tap to capture',
    this.takenLabel = 'Photo captured',
    this.icon = Icons.camera_alt_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final color = taken ? AppColors.success : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(taken ? Icons.check_circle : icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(taken ? takenLabel : emptyLabel, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            if (taken) const Text('Tap to retake', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

/// Map placeholder. Swap with google_maps_flutter when you wire real location.
class MapPlaceholder extends StatelessWidget {
  final double height;
  final bool showRoute;
  const MapPlaceholder({super.key, this.height = 200, this.showRoute = true});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _MapPainter(showRoute)),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final bool route;
  _MapPainter(this.route);

  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFE6F0FB));
    final road = Paint()..color = Colors.white..strokeWidth = 12;
    final thin = Paint()..color = Colors.white..strokeWidth = 5;
    for (var i = 1; i <= 3; i++) {
      canvas.drawLine(Offset(0, s.height * i / 4), Offset(s.width, s.height * i / 4), i == 2 ? road : thin);
      canvas.drawLine(Offset(s.width * i / 4, 0), Offset(s.width * i / 4, s.height), i == 2 ? road : thin);
    }
    if (route) {
      final path = Path()
        ..moveTo(s.width * .12, s.height * .8)
        ..cubicTo(s.width * .3, s.height * .2, s.width * .55, s.height * .9, s.width * .88, s.height * .25);
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(s.width * .12, s.height * .8), 9, Paint()..color = AppColors.success);
      canvas.drawCircle(Offset(s.width * .12, s.height * .8), 4, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(s.width * .88, s.height * .25), 9, Paint()..color = AppColors.danger);
      canvas.drawCircle(Offset(s.width * .88, s.height * .25), 4, Paint()..color = Colors.white);
    } else {
      final c = Offset(s.width / 2, s.height / 2);
      canvas.drawCircle(c, 26, Paint()..color = AppColors.primary.withOpacity(0.18));
      canvas.drawCircle(c, 12, Paint()..color = AppColors.primary);
      canvas.drawCircle(c, 5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.route != route;
}
