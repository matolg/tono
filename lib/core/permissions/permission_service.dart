import 'package:permission_handler/permission_handler.dart';

abstract final class PermissionService {
  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> get hasMicrophonePermission async =>
      (await Permission.microphone.status).isGranted;
}
