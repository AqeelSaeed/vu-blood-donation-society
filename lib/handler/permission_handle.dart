import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Handler {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<bool> checkCameraPermission() async {
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      var result = await Permission.camera.request();
      return result.isGranted;
    } else if (cameraStatus.isLimited || cameraStatus.isGranted) {
      return true;
    } else if (cameraStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> checkStoragePermission() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      return await belowApiLevel32();
    } else {
      return await aboveApiLevel32();
    }
  }

  Future<bool> belowApiLevel32() async {
    log('belowApiLevel32');
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      var result = await Permission.storage.request();
      return result.isGranted;
    } else if (storageStatus.isLimited || storageStatus.isGranted) {
      return true;
    } else if (storageStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> aboveApiLevel32() async {
    var storageStatus = await Permission.photos.status;
    if (storageStatus.isDenied) {
      var result = await Permission.photos.request();
      return result.isGranted;
    } else if (storageStatus.isLimited || storageStatus.isGranted) {
      return true;
    } else if (storageStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}
