import 'dart:io';
import 'package:on_audio_query/on_audio_query.dart';

class PermissionService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    bool hasPermission = await _audioQuery.permissionsStatus();

    if (!hasPermission) {
      hasPermission = await _audioQuery.permissionsRequest();
    }

    return hasPermission;
  }

  Future<bool> requestAudioPermission() async {
    return requestStoragePermission();
  }
}