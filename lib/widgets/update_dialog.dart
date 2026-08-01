import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../services/update_service.dart';

/// A dialog that shows when an app update is available.
/// Supports downloading and installing the update.
class UpdateDialog extends StatefulWidget {
  final UpdateInfo updateInfo;

  const UpdateDialog({super.key, required this.updateInfo});

  /// Show the update dialog and return true if the user initiated an update.
  static Future<bool?> show(BuildContext context, UpdateInfo updateInfo) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UpdateDialog(updateInfo: updateInfo),
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;
  String _statusText = '';
  String? _downloadedPath;
  String? _error;

  UpdateInfo get _updateInfo => widget.updateInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_isDownloading,
      child: AlertDialog(
        icon: Icon(
          _downloadedPath != null
              ? Icons.system_update
              : Icons.system_update_alt,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          _downloadedPath != null ? 'Siap Install' : 'Update Tersedia',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Version info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.new_releases, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'v${_updateInfo.latestVersion}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Changelog
            if (_updateInfo.changelog.isNotEmpty) ...[
              Text(
                _updateInfo.changelog,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Download progress
            if (_isDownloading) ...[
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                _statusText,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ],

            // Error message
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  textAlign: TextAlign.center,
                ),
              ),
            ],

            // Ready to install
            if (_downloadedPath != null) ...[
              const SizedBox(height: 8),
              Text(
                'Download selesai. Tekan Install untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
        actions: [
          if (!_isDownloading && _downloadedPath == null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nanti Saja'),
            ),
          if (_downloadedPath != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nanti Saja'),
            ),
          if (_downloadedPath != null)
            FilledButton.icon(
              onPressed: _installApk,
              icon: const Icon(Icons.install_mobile),
              label: const Text('Install'),
            ),
          if (_isDownloading)
            const SizedBox(),
          if (!_isDownloading && _downloadedPath == null && _error == null)
            FilledButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.download),
              label: const Text('Update Sekarang'),
            ),
          if (_error != null)
            FilledButton(
              onPressed: _startDownload,
              child: const Text('Coba Lagi'),
            ),
        ],
      ),
    );
  }

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _statusText = 'Menyiapkan download...';
      _error = null;
    });

    try {
      final path = await UpdateService.instance.downloadApk(
        updateInfo: _updateInfo,
        onProgress: (progress, received, total) {
          if (mounted) {
            final receivedMB = UpdateService.formatBytes(received);
            final totalMB = UpdateService.formatBytes(total);
            setState(() {
              _progress = progress;
              _statusText = '$receivedMB / $totalMB';
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadedPath = path;
          _progress = 1.0;
          _statusText = 'Download selesai!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _error = 'Gagal download: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _installApk() async {
    if (_downloadedPath == null) return;

    try {
      final result = await OpenFilex.open(_downloadedPath!);

      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka file: ${result.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
