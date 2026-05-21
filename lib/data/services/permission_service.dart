import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<Map<Permission, PermissionStatus>> requestMobilePermissions() {
    final mobile =
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    if (kIsWeb || !mobile) {
      return Future.value({});
    }
    return [
      Permission.camera,
      Permission.photos,
      Permission.notification,
    ].request();
  }
}
