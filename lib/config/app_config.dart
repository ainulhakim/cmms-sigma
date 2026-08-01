/// Application-wide configuration constants.
///
/// Replace placeholder values with your actual Supabase credentials
/// before building for production.
class AppConfig {
  AppConfig._();

  /// The display name of the application.
  static const String appName = 'CMMS SIGMA';

  /// The application version string.
  static const String appVersion = '1.0.3';

  /// Supabase project URL.
  static const String supabaseUrl = 'https://gfficbusjlvrifjlatvr.supabase.co';

  /// Supabase anonymous/public API key.
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdmZmljYnVzamx2cmlmamxhdHZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU1NDY0MDQsImV4cCI6MjEwMTEyMjQwNH0.cO702oVQVL7bTUon9gUOpeQAAw6EcKQvuuwcRB-ObCo';

  /// Local database name.
  static const String localDbName = 'cmms_sigma.db';

  /// Local database version.
  static const int localDbVersion = 1;

  /// QR scan timeout in seconds.
  static const int qrScanTimeoutSeconds = 30;

  /// Maximum image upload size in bytes (5 MB).
  static const int maxImageUploadSize = 5 * 1024 * 1024;

  /// Supported image formats for upload.
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  /// Sync interval in seconds (5 minutes).
  static const int syncIntervalSeconds = 300;

  /// Notification channel ID for work order alerts.
  static const String notificationChannelId = 'cmms_work_orders';

  /// Notification channel name for work order alerts.
  static const String notificationChannelName = 'Work Orders';
}
