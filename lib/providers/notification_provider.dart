// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationProvider with ChangeNotifier {
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialize() async {
//     // Request permissions
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
//     // Handle background messages
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
//   }

//   void _handleForegroundMessage(RemoteMessage message) {
//     _showLocalNotification(
//       title: message.notification?.title ?? 'New Notification',
//       body: message.notification?.body ?? '',
//     );
//   }

//   void _handleBackgroundMessage(RemoteMessage message) {
//   }

//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'moments_channel',
//       'Moments Notifications',
//       channelDescription: 'Notifications for Moments app',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   Future<void> showEventCreatedNotification(String eventTitle) async {
//     await _showLocalNotification(
//       title: 'Event Created!',
//       body: 'Your event "$eventTitle" has been created successfully.',
//     );
//   }

//   Future<void> showEventAlertNotification(String eventTitle, DateTime eventDate) async {
//     final timeUntilEvent = eventDate.difference(DateTime.now());
//     if (timeUntilEvent.inHours <= 24 && timeUntilEvent.inHours > 0) {
//       await _showLocalNotification(
//         title: 'Event Reminder',
//         body: 'Your event "$eventTitle" is starting in ${timeUntilEvent.inHours} hours!',
//       );
//     }
//   }

//   Future<void> showCommentNotification(String eventTitle, String commenterName) async {
//     await _showLocalNotification(
//       title: 'New Comment',
//       body: '$commenterName commented on your event "$eventTitle"',
//     );
//   }
// }









//floating notification

// providers/notification_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  bool _notificationsEnabled = true;
  int _unreadCount = 0;
  final List<Map<String, dynamic>> _notifications = [];

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  int get unreadCount => _unreadCount;
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> initialize() async {
    await _loadPreferences();
    await _requestPermissions();
    await _setupNotificationHandlers();
    await _loadNotifications();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _setupNotificationHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);
    
    // Handle notification when app is launched from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessageTap(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (!_notificationsEnabled) return;

    // Add to internal notifications list
    _addNotificationToList(message);

    // Show local notification for better visibility
    _showEnhancedLocalNotification(
      title: message.notification?.title ?? 'Moments',
      body: message.notification?.body ?? 'New notification',
      data: message.data,
    );
  }

  void _handleBackgroundMessageTap(RemoteMessage message) {
    debugPrint('Background message tapped: ${message.data}');
    // Handle navigation based on message data
    _handleNotificationNavigation(message.data);
  }

  void _addNotificationToList(RemoteMessage message) {
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': message.notification?.title ?? 'Moments',
      'body': message.notification?.body ?? 'New notification',
      'data': message.data,
      'timestamp': DateTime.now(),
      'isRead': false,
    };

    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
  }

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    final screen = data['screen'] ?? '';
    if (screen.isNotEmpty) {
      // You can use a navigation service or global navigator key here
      debugPrint('Navigate to: $screen');
      // Example: NavigationService.navigateTo(screen);
    }
  }

  Future<void> _showEnhancedLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (!_notificationsEnabled) return;

    final notificationType = data?['type'] ?? 'default';
    
    // Configure notification details based on type
    AndroidNotificationDetails androidDetails;
    
    if (['PRIVATE_EVENT_INVITATION', 'COMMENT_REPLY'].contains(notificationType)) {
      // High priority for important notifications
      androidDetails = const AndroidNotificationDetails(
        'moments_high_priority',
        'High Priority Notifications',
        channelDescription: 'Important notifications requiring immediate attention',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        playSound: true,
        icon: '@drawable/ic_notification',
        color: Color(0xFF25D366),
        category: AndroidNotificationCategory.social,
        visibility: NotificationVisibility.public,
        fullScreenIntent: false,
        autoCancel: true,
        timeoutAfter: 10000,
      );
    } else {
      // Regular notifications
      androidDetails = const AndroidNotificationDetails(
        'moments_events',
        'Moments Notifications',
        channelDescription: 'General notifications for Moments app',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        icon: '@drawable/ic_notification',
        color: Color(0xFF25D366),
        category: AndroidNotificationCategory.social,
        visibility: NotificationVisibility.public,
        autoCancel: true,
        timeoutAfter: 8000,
      );
    }

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
      payload: data?['screen'] ?? '',
    );
  }

  Future<void> _loadNotifications() async {
    // Load notifications from local storage or API
    // This is a placeholder - implement based on your needs
    try {
      // final notifications = await NotificationApi.getNotifications();
      // _notifications = notifications;
      // _unreadCount = notifications.where((n) => !n['isRead']).length;
      // notifyListeners();
    } catch (e) {
      debugPrint('Failed to load notifications: $e');
    }
  }

  // Public methods for the app to use
  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    await _savePreferences();
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1 && !_notifications[index]['isRead']) {
      _notifications[index]['isRead'] = true;
      _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification['isRead'] = true;
    }
    _unreadCount = 0;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  void removeNotification(String notificationId) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      if (!_notifications[index]['isRead']) {
        _unreadCount = (_unreadCount - 1).clamp(0, _notifications.length);
      }
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  // Utility methods for different notification types
  Future<void> showEventCreatedNotification(String eventTitle) async {
    await _showEnhancedLocalNotification(
      title: 'Event Created Successfully!',
      body: 'Your event "$eventTitle" is now live.',
      data: {'type': 'EVENT_CREATED'},
    );
  }

  Future<void> showEventReminderNotification(String eventTitle, DateTime eventDate) async {
    final timeUntilEvent = eventDate.difference(DateTime.now());
    if (timeUntilEvent.inHours <= 24 && timeUntilEvent.inHours > 0) {
      await _showEnhancedLocalNotification(
        title: 'Event Reminder',
        body: 'Your event "$eventTitle" is starting in ${timeUntilEvent.inHours} hours!',
        data: {'type': 'EVENT_REMINDER'},
      );
    }
  }

  Future<void> showCommentNotification(String eventTitle, String commenterName) async {
    await _showEnhancedLocalNotification(
      title: 'New Comment',
      body: '$commenterName commented on "$eventTitle"',
      data: {'type': 'COMMENT_CREATED'},
    );
  }

  Future<void> showInvitationNotification(String eventTitle, String inviterName) async {
    await _showEnhancedLocalNotification(
      title: 'Event Invitation',
      body: '$inviterName invited you to "$eventTitle"',
      data: {'type': 'PRIVATE_EVENT_INVITATION'},
    );
  }

  // Get FCM token for backend registration
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  // Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Failed to subscribe to topic $topic: $e');
    }
  }

  // Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Failed to unsubscribe from topic $topic: $e');
    }
  }
}