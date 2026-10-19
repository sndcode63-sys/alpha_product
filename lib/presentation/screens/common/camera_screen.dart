import 'package:alpha_field_app/imports.dart';

/// Used for attendance selfie, meeting selfie and delivery photo.
/// Returns the image path (or "exception:<reason>") via Get.back(result: ...).
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<PhotoController>() ? Get.find<PhotoController>() : Get.put(PhotoController());
    final purpose = (Get.arguments as String?) ?? 'Photo';

    return Obx(() {
      final p = controller.path.value;
      return AppScaffold(
        title: purpose,
        footer: Column(mainAxisSize: MainAxisSize.min, children: [
          if (p.isEmpty) PrimaryButton('Open camera', controller.capture) else ...[
            PrimaryButton('Use photo', () => Get.back(result: p)),
            const SizedBox(height: 8),
            PrimaryButton('Retake', controller.capture, ghost: true),
          ],
          TextButton(onPressed: controller.refuse, child: const Text('Contact refused? Choose an exception reason')),
        ]),
        children: [
          Container(
            height: 380,
            decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(18), image: p.isEmpty ? null : DecorationImage(image: FileImage(File(p)), fit: BoxFit.cover)),
            alignment: Alignment.center,
            child: p.isEmpty ? const Text('Camera preview appears here', style: TextStyle(color: Colors.white70)) : null,
          ),
          const Text('Make sure the contact person agrees to the photo.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
        ],
      );
    });
  }
}
