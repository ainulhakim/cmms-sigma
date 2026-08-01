import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Information about an available update.
class UpdateInfo {
  final String latestVersion;
  final String downloadUrl;
  final String changelog;
  final String fileName;

  UpdateInfo({
    required this.latestVersion,
    required this.downloadUrl,
    required this.changelog,
    required this.fileName,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      latestVersion: json['latest_version'] ?? '0.0.0',
      downloadUrl: json['download_url'] ?? '',
      changelog: json['changelog'] ?? '',
      fileName: json['file_name'] ?? 'app.apk',
    );
  }
}

/// Service for checking and downloading app updates.
class UpdateService {
  UpdateService._();
  static final UpdateService instance = UpdateService._();

  /// Base URL for the download server.
  static const String _baseUrl = 'https://ai-null.ainulhakim.com';

  /// Endpoint to check for latest version.
  static const String _versionUrl = '$_baseUrl/api/version';

  final Dio _dio = Dio();

  /// Check the server for a newer version.
  /// Returns [UpdateInfo] if a newer version is available, null otherwise.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await _dio.get(
        _versionUrl,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        final updateInfo = UpdateInfo.fromJson(response.data);
        final currentVersion = await _getCurrentVersion();

        debugPrint('📱 Current version: $currentVersion');
        debugPrint('📱 Latest version: ${updateInfo.latestVersion}');

        if (_isNewer(updateInfo.latestVersion, currentVersion)) {
          return updateInfo;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Update check failed: $e');
    }
    return null;
  }

  /// Get the current installed app version from package info.
  Future<String> _getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Compare two semantic version strings.
  /// Returns true if [latest] is newer than [current].
  bool _isNewer(String latest, String current) {
    final latestParts = latest.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();

    // Pad shorter list with zeros
    while (latestParts.length < 3) latestParts.add(0);
    while (currentParts.length < 3) currentParts.add(0);

    for (var i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }

  /// Download the APK file with progress tracking.
  /// Returns the path to the downloaded file.
  /// [onProgress] is called with download progress (0.0 to 1.0).
  Future<String> downloadApk({
    required UpdateInfo updateInfo,
    required void Function(double progress, int received, int total)? onProgress,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${updateInfo.fileName}';

    // Remove old APK if it exists
    final existingFile = File(filePath);
    if (await existingFile.exists()) {
      await existingFile.delete();
    }

    await _dio.download(
      '${updateInfo.downloadUrl}',
      filePath,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          final progress = received / total;
          onProgress?.call(progress, received, total);
        }
      },
      options: Options(
        receiveTimeout: const Duration(minutes: 5),
      ),
    );

    debugPrint('✅ APK downloaded to: $filePath');
    return filePath;
  }

  /// Trigger installation of the downloaded APK file.
  /// Uses OpenFilex to open the APK with the system installer.
  Future<void> installApk(String apkPath) async {
    try {
      // Use open_filex or install_plugin to trigger installation
      // For now, we'll use a method channel approach via the update screen
      debugPrint('📦 Ready to install APK: $apkPath');
    } catch (e) {
      debugPrint('❌ Failed to install APK: $e');
      rethrow;
    }
  }

  /// Format bytes into human-readable string.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
