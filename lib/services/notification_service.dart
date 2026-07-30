import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'supabase_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Stream for handling notification taps
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _initialized = false;

  /// Initialize Firebase Messaging and local notifications
  Future<void> initialize() async {
    if (_initialized) return;

    // Request permissions
    await _requestPermissions();

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $_fcmToken');

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _updateFcmTokenOnServer(newToken);
    });

    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

    // Handle notification that launched the app
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpened(initialMessage);
    }

    _initialized = true;
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    final messaging = _firebaseMessaging;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    } else {
      // Android 13+ requires runtime permission
      await messaging.requestPermission();
    }
  }

  /// Update FCM token on the server
  Future<void> _updateFcmTokenOnServer(String token) async {
    try {
      final user = SupabaseService().currentUser;
      if (user != null) {
        await SupabaseService().updateFcmToken(user.id, token);
      }
    } catch (e) {
      debugPrint('Failed to update FCM token: $e');
    }
  }

  /// Handle foreground message - show local notification
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await _showLocalNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: jsonEncode(data),
      );
    }

    // Add to notification stream
    _notificationController.add(data);
  }

  /// Handle notification opened from background
  Future<void> _handleNotificationOpened(RemoteMessage message) async {
    final data = message.data;
    if (data.isNotEmpty) {
      _notificationController.add(data);
    }
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        _notificationController.add(data);
      } catch (_) {}
    }
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'cmms_sigma_channel',
      'CMMS SIGMA Notifications',
      channelDescription: 'Work order and maintenance notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Create notification channels for Android
  Future<void> createNotificationChannels() async {
    const androidChannel = AndroidNotificationChannel(
      'cmms_sigma_channel',
      'CMMS SIGMA Notifications',
      description: 'Work order and maintenance notifications',
      importance: Importance.high,
    );

    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      androidChannel,
    );
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    _fcmToken = null;
  }

  /// Dispose
  void dispose() {
    _notificationController.close();
  }
}
