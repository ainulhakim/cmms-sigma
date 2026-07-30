import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════
// Enum Definitions
// ══════════════════════════════════════════════════════════════════════════

/// Represents the lifecycle status of a work order.
enum WorkOrderStatus {
  /// Work order has been created but not yet started.
  open('Open'),

  /// Work is currently being performed.
  inProgress('In Progress'),

  /// Work has been paused, pending parts or information.
  onHold('On Hold'),

  /// Work has been completed successfully.
  completed('Completed'),

  /// Work order has been cancelled before completion.
  cancelled('Cancelled');

  final String label;
  const WorkOrderStatus(this.label);

  /// Returns the status from its string representation (case-insensitive).
  static WorkOrderStatus fromString(String value) {
    return WorkOrderStatus.values.firstWhere(
      (s) => s.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => WorkOrderStatus.open,
    );
  }

  /// Display-friendly color for this status.
  Color get color {
    switch (this) {
      case WorkOrderStatus.open:
        return const Color(0xFF1E88E5);
      case WorkOrderStatus.inProgress:
        return const Color(0xFFF57C00);
      case WorkOrderStatus.onHold:
        return const Color(0xFF757575);
      case WorkOrderStatus.completed:
        return const Color(0xFF388E3C);
      case WorkOrderStatus.cancelled:
        return const Color(0xFFD32F2F);
    }
  }

  /// Icon data for this status.
  IconData get icon {
    switch (this) {
      case WorkOrderStatus.open:
        return Icons.radio_button_unchecked;
      case WorkOrderStatus.inProgress:
        return Icons.directions_run;
      case WorkOrderStatus.onHold:
        return Icons.pause_circle_outline;
      case WorkOrderStatus.completed:
        return Icons.check_circle_outline;
      case WorkOrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }
}

/// The type of maintenance being performed.
enum MaintenanceType {
  /// Reactive repair after a failure.
  corrective('Corrective'),

  /// Scheduled routine maintenance.
  preventive('Preventive'),

  /// Condition-based monitoring and maintenance.
  predictive('Predictive'),

  /// Emergency / urgent unscheduled repair.
  emergency('Emergency'),

  /// Planned overhaul or major service.
  planned('Planned');

  final String label;
  const MaintenanceType(this.label);

  /// Returns the maintenance type from its string representation.
  static MaintenanceType fromString(String value) {
    return MaintenanceType.values.firstWhere(
      (t) => t.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => MaintenanceType.corrective,
    );
  }

  /// Color associated with this maintenance type.
  Color get color {
    switch (this) {
      case MaintenanceType.corrective:
        return const Color(0xFFE53935);
      case MaintenanceType.preventive:
        return const Color(0xFF1E88E5);
      case MaintenanceType.predictive:
        return const Color(0xFF8E24AA);
      case MaintenanceType.emergency:
        return const Color(0xFFFF6F00);
      case MaintenanceType.planned:
        return const Color(0xFF43A047);
    }
  }

  /// Icon associated with this maintenance type.
  IconData get icon {
    switch (this) {
      case MaintenanceType.corrective:
        return Icons.build_outlined;
      case MaintenanceType.preventive:
        return Icons.schedule_outlined;
      case MaintenanceType.predictive:
        return Icons.trending_up_outlined;
      case MaintenanceType.emergency:
        return Icons.warning_amber_outlined;
      case MaintenanceType.planned:
        return Icons.calendar_month_outlined;
    }
  }
}

/// Tracks the synchronization state of local data with the remote server.
enum SyncStatus {
  /// Data is in sync with the server.
  synced('Synced'),

  /// Local changes are pending upload to the server.
  pendingSync('Pending Sync'),

  /// Data is currently being synchronized.
  syncing('Syncing'),

  /// Synchronization failed.
  failed('Failed'),

  /// No network connection available.
  offline('Offline');

  final String label;
  const SyncStatus(this.label);

  /// Returns [SyncStatus] from its string representation.
  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
      (s) => s.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => SyncStatus.pendingSync,
    );
  }

  /// Color associated with this sync status.
  Color get color {
    switch (this) {
      case SyncStatus.synced:
        return const Color(0xFF388E3C);
      case SyncStatus.pendingSync:
        return const Color(0xFFF57C00);
      case SyncStatus.syncing:
        return const Color(0xFF1E88E5);
      case SyncStatus.failed:
        return const Color(0xFFD32F2F);
      case SyncStatus.offline:
        return const Color(0xFF757575);
    }
  }

  /// Icon associated with this sync status.
  IconData get icon {
    switch (this) {
      case SyncStatus.synced:
        return Icons.cloud_done_outlined;
      case SyncStatus.pendingSync:
        return Icons.cloud_upload_outlined;
      case SyncStatus.syncing:
        return Icons.sync_outlined;
      case SyncStatus.failed:
        return Icons.cloud_off_outlined;
      case SyncStatus.offline:
        return Icons.wifi_off_outlined;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════
// General Constants
// ══════════════════════════════════════════════════════════════════════════

/// Standard date format used throughout the app.
const String dateFormat = 'yyyy-MM-dd';

/// Standard date-time format used throughout the app.
const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

/// Standard time format.
const String timeFormat = 'HH:mm';

/// Maximum length for text fields.
const int maxTextFieldLength = 500;

/// Default page size for paginated lists.
const int defaultPageSize = 20;

/// Minimum password length.
const int minPasswordLength = 6;
