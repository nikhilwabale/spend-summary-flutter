import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestCorePermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.locationWhenInUse,
      Permission.notification,
    ].request();
  }
}
