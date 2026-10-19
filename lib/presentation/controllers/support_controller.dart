import 'package:alpha_field_app/imports.dart';
import 'package:image_picker/image_picker.dart';

class SupportController extends GetxController {
  final SupportRepository repo;
  final SyncAll _sync;
  SupportController(this.repo, this._sync);

  final notifications = <AppNotification>[].obs;
  final queue = <SyncItem>[].obs;

  @override
  void onInit() {
    reload();
    super.onInit();
  }

  void reload() {
    notifications.assignAll(repo.notifications());
    queue.assignAll(repo.syncQueue());
  }

  int get pending => queue.where((q) => q.status == 'pending').length;

  Future<void> syncNow() async {
    final n = pending;
    await _sync();
    reload();
    AppToast.show(n == 0 ? 'Everything is already synced' : '$n items synced ✓');
  }
}

/// Camera screen state (selfie / delivery photo).
class PhotoController extends GetxController {
  final path = ''.obs;

  Future<void> capture() async {
    final x = await ImagePicker().pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front, imageQuality: 70);
    if (x != null) path.value = x.path;
  }

  Future<void> refuse() async {
    final why = await AppDialogs.input(title: 'Contact refused the photo?', text: 'Pick an approved reason. Your manager will review it.', hint: 'Reason');
    if (why != null && why.isNotEmpty) {
      AppToast.show('Exception reason sent for manager review');
      Get.back(result: 'exception:$why');
    }
  }
}
