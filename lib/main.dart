//old working code with notification

// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.high,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 FCM Foreground Notification Listener
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//         android: AndroidNotificationDetails(
//           channelId,
//           'Moments Notifications',
//           channelDescription: 'This channel is used for Moments app notifications.',
//           importance: Importance.max,  
//           priority: Priority.high,      
//           icon: '@mipmap/moments',
//         ),
//       ),

//         // const NotificationDetails(
//         //   android: AndroidNotificationDetails(
//         //     channelId,
//         //     'Moments Notifications',
//         //     channelDescription: 'This channel is used for Moments app notifications.',
//         //     importance: Importance.max,
//         //     priority: Priority.high,
//         //     icon: '@mipmap/moments',
//         //   ),
//         // ),
//         payload: message.data['screen'] ?? '',
//       );
//     }
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();

//   // Initialize dynamic links
//   // await DynamicLinkService.initDynamicLinks(navigatorKey);
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//       ],
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         title: 'Moments',
//         theme: AppTheme.lightTheme,
//         home: const SplashScreen(),
//         routes: {
//           // '/': (context) => const SplashScreen(),
//           '/login': (context) => const LoginScreen(),
//           '/register': (context) => const RegisterScreen(),
//           '/home': (context) => const MyNavigationBar(),
//           '/profile': (context) => const ProfileScreen(),
//           '/edit-profile': (context) => const EditProfileScreen(),
//           '/create-event': (context) => const CreateEventScreen(),
//           '/event-calendar': (context) => const EventCalendarScreen(),
//           '/pinned-events': (context) => const PinnedEventsScreen(),
//           '/settings': (context) => const SettingsScreen(),
          
//           '/completed-events': (context) => const CompletedEventsPage(),
//           '/my-events-screen': (context) => const MyEventsPage(),
//           // 'edit-event': (context) => const EditEventPage(),

//         },
//         onGenerateRoute: (settings) {
//           if (settings.name == '/event-detail') {
//             final args = settings.arguments as Map<String, dynamic>?;
//             if (args != null && args.containsKey('eventToken')) {
//               return MaterialPageRoute(
//                 builder: (context) => EventDetailScreen(
//                   eventToken: args['eventToken'],
//                 ),
//               );
//             }
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }







//dark light theme added



// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:moments/providers/ThemeProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.high,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 FCM Foreground Notification Listener
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             channelId,
//             'Moments Notifications',
//             channelDescription: 'This channel is used for Moments app notifications.',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/moments',
//           ),
//         ),
//         payload: message.data['screen'] ?? '',
//       );
//     }
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add theme provider
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             navigatorKey: navigatorKey,
//             title: 'Moments',
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme, // Add dark theme
//             themeMode: themeProvider.themeMode, // Use theme provider
//             home: const SplashScreen(),
//             routes: {
//               '/login': (context) => const LoginScreen(),
//               '/register': (context) => const RegisterScreen(),
//               '/home': (context) => const MyNavigationBar(),
//               '/profile': (context) => const ProfileScreen(),
//               '/edit-profile': (context) => const EditProfileScreen(),
//               '/create-event': (context) => const CreateEventScreen(),
//               '/event-calendar': (context) => const EventCalendarScreen(),
//               '/pinned-events': (context) => const PinnedEventsScreen(),
//               '/settings': (context) => const SettingsScreen(),
//               '/completed-events': (context) => const CompletedEventsPage(),
//               '/my-events-screen': (context) => const MyEventsPage(),
//             },
//             onGenerateRoute: (settings) {
//               if (settings.name == '/event-detail') {
//                 final args = settings.arguments as Map<String, dynamic>?;
//                 if (args != null && args.containsKey('eventToken')) {
//                   return MaterialPageRoute(
//                     builder: (context) => EventDetailScreen(
//                       eventToken: args['eventToken'],
//                     ),
//                   );
//                 }
//               }
//               return null;
//             },
//           );
//         },
//       ),
//     );
//   }
// }




//floating notification added 


// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/providers/FloatingNotificationService.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:moments/providers/ThemeProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   // Create high priority notification channel for floating notifications
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.max, // Maximum importance
//     enableVibration: true,
//     enableLights: true,
//     ledColor: Color(0xFF6C63FF),
//     showBadge: true,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 Enhanced FCM Foreground Notification Listener with Floating Notifications
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null) {
//       // Show floating notification when app is in foreground
//       FloatingNotificationService.showFloatingNotification(
//         title: notification.title ?? 'New Notification',
//         body: notification.body ?? '',
//         imageUrl: android?.imageUrl,
//         onTap: () {
//           // Handle tap - navigate to relevant screen
//           final screen = message.data['screen'] ?? '';
//           if (screen.isNotEmpty) {
//             navigatorKey.currentState?.pushNamed('/$screen');
//           } else if (message.data['eventToken'] != null) {
//             navigatorKey.currentState?.pushNamed(
//               '/event-detail',
//               arguments: {'eventToken': message.data['eventToken']},
//             );
//           }
//         },
//       );

//       // Also show system notification for when app is not active
//       if (android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               channelId,
//               'Moments Notifications',
//               channelDescription: 'This channel is used for Moments app notifications.',
//               importance: Importance.max,
//               priority: Priority.high,
//               icon: '@mipmap/moments',
//               enableVibration: true,
//               enableLights: true,
//               ledColor: Color(0xFF6C63FF),
//               // Make it a heads-up notification
//               visibility: NotificationVisibility.public,
//               category: AndroidNotificationCategory.message,
//               fullScreenIntent: true, // This makes it more prominent
//             ),
//           ),
//           payload: message.data['screen'] ?? '',
//         );
//       }
//     }
//   });

//   // Handle notification tap when app is in background/terminated
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     debugPrint('🟢 App opened from notification: ${message.messageId}');
    
//     // Navigate to appropriate screen
//     final screen = message.data['screen'] ?? '';
//     if (screen.isNotEmpty) {
//       navigatorKey.currentState?.pushNamed('/$screen');
//     } else if (message.data['eventToken'] != null) {
//       navigatorKey.currentState?.pushNamed(
//         '/event-detail',
//         arguments: {'eventToken': message.data['eventToken']},
//       );
//     }
//   });
// }

// /// 🎯 Handle initial notification when app is opened from terminated state
// Future<void> handleInitialNotification() async {
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  
//   if (initialMessage != null) {
//     debugPrint('🟢 App opened from terminated state: ${initialMessage.messageId}');
    
//     // Wait a bit for the app to initialize
//     Timer(const Duration(seconds: 1), () {
//       final screen = initialMessage.data['screen'] ?? '';
//       if (screen.isNotEmpty) {
//         navigatorKey.currentState?.pushNamed('/$screen');
//       } else if (initialMessage.data['eventToken'] != null) {
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': initialMessage.data['eventToken']},
//         );
//       }
//     });
//   }
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     announcement: true,
//     carPlay: true,
//     criticalAlert: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();
//   await handleInitialNotification();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             navigatorKey: navigatorKey,
//             title: 'Moments',
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme,
//             themeMode: themeProvider.themeMode,
//             home: const SplashScreen(),
//             routes: {
//               '/login': (context) => const LoginScreen(),
//               '/register': (context) => const RegisterScreen(),
//               '/home': (context) => const MyNavigationBar(),
//               '/profile': (context) => const ProfileScreen(),
//               '/edit-profile': (context) => const EditProfileScreen(),
//               '/create-event': (context) => const CreateEventScreen(),
//               '/event-calendar': (context) => const EventCalendarScreen(),
//               '/pinned-events': (context) => const PinnedEventsScreen(),
//               '/settings': (context) => const SettingsScreen(),
//               '/completed-events': (context) => const CompletedEventsPage(),
//               '/my-events-screen': (context) => const MyEventsPage(),
//             },
//             onGenerateRoute: (settings) {
//               if (settings.name == '/event-detail') {
//                 final args = settings.arguments as Map<String, dynamic>?;
//                 if (args != null && args.containsKey('eventToken')) {
//                   return MaterialPageRoute(
//                     builder: (context) => EventDetailScreen(
//                       eventToken: args['eventToken'],
//                     ),
//                   );
//                 }
//               }
//               return null;
//             },
//           );
//         },
//       ),
//     );
//   }
// }

















//old 18-9-25 working code without notification

// import 'dart:async';
// import 'dart:typed_data';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// // 🔧 Background FCM handler (must be top-level)
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
  
//   // Show notification even when app is in background
//   if (message.notification != null) {
//     await showNotification(message);
//   }
// }

// // 🔧 Background notification response handler (must be top-level)
// @pragma('vm:entry-point')
// void backgroundNotificationHandler(NotificationResponse response) {
//   debugPrint('🟢 Background notification tapped: ${response.payload}');
//   // We can't directly call handleNotificationTap here since it's not static
//   // Instead, we'll use platform channels or isolate communication
//   // For now, just log the response
// }

// /// Handle notification tap
// void handleNotificationTap(NotificationResponse response) {
//   final payload = response.payload ?? '';
//   final actionId = response.actionId ?? '';
  
//   // Handle action buttons
//   if (actionId == 'view_event') {
//     if (payload.isNotEmpty && payload.startsWith('event-detail:')) {
//       final eventToken = payload.split(':')[1];
//       navigatorKey.currentState?.pushNamed(
//         '/event-detail',
//         arguments: {'eventToken': eventToken},
//       );
//     }
//   } 
//   // For regular notification tap
//   else if (payload.isNotEmpty && payload.startsWith('event-detail:')) {
//     final eventToken = payload.split(':')[1];
//     navigatorKey.currentState?.pushNamed(
//       '/event-detail',
//       arguments: {'eventToken': eventToken},
//     );
//   }
// }

// /// Show notification with floating/heads-up configuration
// Future<void> showNotification(RemoteMessage message) async {
//   RemoteNotification? notification = message.notification;
//   Map<String, dynamic> data = message.data;

//   if (notification != null) {
//     String payload = data['screen'] ?? '';
    
//     // Android notification details for floating notification
//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channelId,
//       'Moments Notifications',
//       channelDescription: 'This channel is used for Moments app notifications.',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker', // Required for heads-up
//       color: Colors.blue,
//       enableVibration: true,
//       vibrationPattern: Int64List.fromList(const [0, 250, 250, 250]),
//       playSound: true,
//       sound: const RawResourceAndroidNotificationSound('notification'),
//       icon: '@mipmap/moments',
//       fullScreenIntent: true, // This will show as floating notification
//       timeoutAfter: 5000, // Auto-dismiss after 5 seconds
//       category: AndroidNotificationCategory.event,
//       actions: const [
//         AndroidNotificationAction(
//           'view_event',
//           'View Event',
//           showsUserInterface: true,
//         ),
//         AndroidNotificationAction(
//           'dismiss',
//           'Dismiss',
//           cancelNotification: true,
//         ),
//       ],
//     );

//     // iOS notification details
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       categoryIdentifier: 'EVENT_CREATED',
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: 'default.aiff',
//     );

//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: androidNotificationDetails,
//         iOS: darwinNotificationDetails,
//       ),
//       payload: payload,
//     );
//   }
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     ),
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       handleNotificationTap(response);
//     },
//     // Remove the onDidReceiveBackgroundNotificationResponse parameter
//     // as it must be a static function
//   );

//   // Create a high importance channel for floating notifications
//   final AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.high, // Changed to high for heads-up
//     enableVibration: true,
//     vibrationPattern: Int64List.fromList(const [0, 250, 250, 250]),
//     playSound: true,
//     sound: const RawResourceAndroidNotificationSound('notification'),
//     showBadge: true,
//     ledColor: Colors.blue,
//     enableLights: true,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
  
// }

// /// 🎧 FCM Foreground Notification Listener
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     debugPrint('🔄 [Foreground FCM] Message received: ${message.messageId}');
//     showNotification(message);
//   });
  
//   // Handle notification when app is opened from terminated state
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message != null && message.data['screen'] != null) {
//       final payload = message.data['screen'];
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     }
//   });
  
//   // Handle notification when app is in background
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     if (message.data['screen'] != null) {
//       final payload = message.data['screen'];
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     }
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();

//   // Initialize dynamic links
//   // await DynamicLinkService.initDynamicLinks(navigatorKey);
  
//   // Request notification permissions
//   NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     provisional: false, // Set to true if you want to request provisional permission (iOS)
//   );
  
//   debugPrint('📱 User granted permission: ${settings.authorizationStatus}');
  
//   // Get FCM token
//   String? token = await FirebaseMessaging.instance.getToken();
//   debugPrint('📱 FCM Token: $token');
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//       ],
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         title: 'Moments',
//         theme: AppTheme.lightTheme,
//         home: const SplashScreen(),
//         routes: {
//           '/login': (context) => const LoginScreen(),
//           '/register': (context) => const RegisterScreen(),
//           '/home': (context) => const MyNavigationBar(),
//           '/profile': (context) => const ProfileScreen(),
//           '/edit-profile': (context) => const EditProfileScreen(),
//           '/create-event': (context) => const CreateEventScreen(),
//           '/event-calendar': (context) => const EventCalendarScreen(),
//           '/pinned-events': (context) => const PinnedEventsScreen(),
//           '/settings': (context) => const SettingsScreen(),
//           '/completed-events': (context) => const CompletedEventsPage(),
//           '/my-events-screen': (context) => const MyEventsPage(),
//         },
//         onGenerateRoute: (settings) {
//           if (settings.name == '/event-detail') {
//             final args = settings.arguments as Map<String, dynamic>?;
//             if (args != null && args.containsKey('eventToken')) {
//               return MaterialPageRoute(
//                 builder: (context) => EventDetailScreen(
//                   eventToken: args['eventToken'],
//                 ),
//               );
//             }
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }











//old working code with notification

// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.high,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 FCM Foreground Notification Listener
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//         android: AndroidNotificationDetails(
//           channelId,
//           'Moments Notifications',
//           channelDescription: 'This channel is used for Moments app notifications.',
//           importance: Importance.max,  
//           priority: Priority.high,      
//           icon: '@mipmap/moments',
//         ),
//       ),

//         // const NotificationDetails(
//         //   android: AndroidNotificationDetails(
//         //     channelId,
//         //     'Moments Notifications',
//         //     channelDescription: 'This channel is used for Moments app notifications.',
//         //     importance: Importance.max,
//         //     priority: Priority.high,
//         //     icon: '@mipmap/moments',
//         //   ),
//         // ),
//         payload: message.data['screen'] ?? '',
//       );
//     }
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();

//   // Initialize dynamic links
//   // await DynamicLinkService.initDynamicLinks(navigatorKey);
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//       ],
//       child: MaterialApp(
//         navigatorKey: navigatorKey,
//         title: 'Moments',
//         theme: AppTheme.lightTheme,
//         home: const SplashScreen(),
//         routes: {
//           // '/': (context) => const SplashScreen(),
//           '/login': (context) => const LoginScreen(),
//           '/register': (context) => const RegisterScreen(),
//           '/home': (context) => const MyNavigationBar(),
//           '/profile': (context) => const ProfileScreen(),
//           '/edit-profile': (context) => const EditProfileScreen(),
//           '/create-event': (context) => const CreateEventScreen(),
//           '/event-calendar': (context) => const EventCalendarScreen(),
//           '/pinned-events': (context) => const PinnedEventsScreen(),
//           '/settings': (context) => const SettingsScreen(),
          
//           '/completed-events': (context) => const CompletedEventsPage(),
//           '/my-events-screen': (context) => const MyEventsPage(),
//           // 'edit-event': (context) => const EditEventPage(),

//         },
//         onGenerateRoute: (settings) {
//           if (settings.name == '/event-detail') {
//             final args = settings.arguments as Map<String, dynamic>?;
//             if (args != null && args.containsKey('eventToken')) {
//               return MaterialPageRoute(
//                 builder: (context) => EventDetailScreen(
//                   eventToken: args['eventToken'],
//                 ),
//               );
//             }
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }







//dark light theme added



// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:moments/providers/ThemeProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.high,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 FCM Foreground Notification Listener
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             channelId,
//             'Moments Notifications',
//             channelDescription: 'This channel is used for Moments app notifications.',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/moments',
//           ),
//         ),
//         payload: message.data['screen'] ?? '',
//       );
//     }
//   });
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add theme provider
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             navigatorKey: navigatorKey,
//             title: 'Moments',
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme, // Add dark theme
//             themeMode: themeProvider.themeMode, // Use theme provider
//             home: const SplashScreen(),
//             routes: {
//               '/login': (context) => const LoginScreen(),
//               '/register': (context) => const RegisterScreen(),
//               '/home': (context) => const MyNavigationBar(),
//               '/profile': (context) => const ProfileScreen(),
//               '/edit-profile': (context) => const EditProfileScreen(),
//               '/create-event': (context) => const CreateEventScreen(),
//               '/event-calendar': (context) => const EventCalendarScreen(),
//               '/pinned-events': (context) => const PinnedEventsScreen(),
//               '/settings': (context) => const SettingsScreen(),
//               '/completed-events': (context) => const CompletedEventsPage(),
//               '/my-events-screen': (context) => const MyEventsPage(),
//             },
//             onGenerateRoute: (settings) {
//               if (settings.name == '/event-detail') {
//                 final args = settings.arguments as Map<String, dynamic>?;
//                 if (args != null && args.containsKey('eventToken')) {
//                   return MaterialPageRoute(
//                     builder: (context) => EventDetailScreen(
//                       eventToken: args['eventToken'],
//                     ),
//                   );
//                 }
//               }
//               return null;
//             },
//           );
//         },
//       ),
//     );
//   }
// }




//floating notification added 


// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moments/providers/FloatingNotificationService.dart';
// import 'package:moments/screens/events/completed_events_page.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/events/my_events_screen.dart';
// import 'package:moments/providers/ThemeProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'providers/auth_provider.dart';
// import 'providers/notification_provider.dart';
// import 'screens/splash_screen.dart';
// import 'screens/auth/login_screen.dart';
// import 'screens/auth/register_screen.dart';
// import 'screens/profile/profile_screen.dart';
// import 'screens/profile/editprofile_screen.dart';
// import 'screens/events/create_event_screen.dart';
// import 'screens/events/event_detail_screen.dart';
// import 'screens/events/pinned_events_screen.dart';
// import 'screens/settings/settings_screen.dart';
// import 'widgets/navigation_bar.dart';
// import 'utils/theme.dart';

// // Global navigator key
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// // Notification plugin
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel ID constant
// const String channelId = 'moments_channel';

// /// 🔧 Background FCM handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
// }

// /// 🔔 Initialize local notifications
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/moments');

//   const InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       debugPrint('🟢 Notification tapped: ${response.payload}');
//       final payload = response.payload ?? '';
//       if (payload.startsWith('event-detail:')) {
//         final eventToken = payload.split(':')[1];
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': eventToken},
//         );
//       }
//     },
//   );

//   // Create high priority notification channel for floating notifications
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     channelId,
//     'Moments Notifications',
//     description: 'This channel is used for Moments app notifications.',
//     importance: Importance.max, // Maximum importance
//     enableVibration: true,
//     enableLights: true,
//     ledColor: Color(0xFF6C63FF),
//     showBadge: true,
//   );

//   final androidPlatform =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>();

//   await androidPlatform?.createNotificationChannel(channel);
// }

// /// 🎧 Enhanced FCM Foreground Notification Listener with Floating Notifications
// void setupFCMListener() {
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null) {
//       // Show floating notification when app is in foreground
//       FloatingNotificationService.showFloatingNotification(
//         title: notification.title ?? 'New Notification',
//         body: notification.body ?? '',
//         imageUrl: android?.imageUrl,
//         onTap: () {
//           // Handle tap - navigate to relevant screen
//           final screen = message.data['screen'] ?? '';
//           if (screen.isNotEmpty) {
//             navigatorKey.currentState?.pushNamed('/$screen');
//           } else if (message.data['eventToken'] != null) {
//             navigatorKey.currentState?.pushNamed(
//               '/event-detail',
//               arguments: {'eventToken': message.data['eventToken']},
//             );
//           }
//         },
//       );

//       // Also show system notification for when app is not active
//       if (android != null) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               channelId,
//               'Moments Notifications',
//               channelDescription: 'This channel is used for Moments app notifications.',
//               importance: Importance.max,
//               priority: Priority.high,
//               icon: '@mipmap/moments',
//               enableVibration: true,
//               enableLights: true,
//               ledColor: Color(0xFF6C63FF),
//               // Make it a heads-up notification
//               visibility: NotificationVisibility.public,
//               category: AndroidNotificationCategory.message,
//               fullScreenIntent: true, // This makes it more prominent
//             ),
//           ),
//           payload: message.data['screen'] ?? '',
//         );
//       }
//     }
//   });

//   // Handle notification tap when app is in background/terminated
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     debugPrint('🟢 App opened from notification: ${message.messageId}');
    
//     // Navigate to appropriate screen
//     final screen = message.data['screen'] ?? '';
//     if (screen.isNotEmpty) {
//       navigatorKey.currentState?.pushNamed('/$screen');
//     } else if (message.data['eventToken'] != null) {
//       navigatorKey.currentState?.pushNamed(
//         '/event-detail',
//         arguments: {'eventToken': message.data['eventToken']},
//       );
//     }
//   });
// }

// /// 🎯 Handle initial notification when app is opened from terminated state
// Future<void> handleInitialNotification() async {
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  
//   if (initialMessage != null) {
//     debugPrint('🟢 App opened from terminated state: ${initialMessage.messageId}');
    
//     // Wait a bit for the app to initialize
//     Timer(const Duration(seconds: 1), () {
//       final screen = initialMessage.data['screen'] ?? '';
//       if (screen.isNotEmpty) {
//         navigatorKey.currentState?.pushNamed('/$screen');
//       } else if (initialMessage.data['eventToken'] != null) {
//         navigatorKey.currentState?.pushNamed(
//           '/event-detail',
//           arguments: {'eventToken': initialMessage.data['eventToken']},
//         );
//       }
//     });
//   }
// }

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await initializeNotifications();
  
//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     announcement: true,
//     carPlay: true,
//     criticalAlert: true,
//   );
  
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   setupFCMListener();
//   await handleInitialNotification();

//   runApp(const MomentsApp());
// }

// class MomentsApp extends StatelessWidget {
//   const MomentsApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             navigatorKey: navigatorKey,
//             title: 'Moments',
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme,
//             themeMode: themeProvider.themeMode,
//             home: const SplashScreen(),
//             routes: {
//               '/login': (context) => const LoginScreen(),
//               '/register': (context) => const RegisterScreen(),
//               '/home': (context) => const MyNavigationBar(),
//               '/profile': (context) => const ProfileScreen(),
//               '/edit-profile': (context) => const EditProfileScreen(),
//               '/create-event': (context) => const CreateEventScreen(),
//               '/event-calendar': (context) => const EventCalendarScreen(),
//               '/pinned-events': (context) => const PinnedEventsScreen(),
//               '/settings': (context) => const SettingsScreen(),
//               '/completed-events': (context) => const CompletedEventsPage(),
//               '/my-events-screen': (context) => const MyEventsPage(),
//             },
//             onGenerateRoute: (settings) {
//               if (settings.name == '/event-detail') {
//                 final args = settings.arguments as Map<String, dynamic>?;
//                 if (args != null && args.containsKey('eventToken')) {
//                   return MaterialPageRoute(
//                     builder: (context) => EventDetailScreen(
//                       eventToken: args['eventToken'],
//                     ),
//                   );
//                 }
//               }
//               return null;
//             },
//           );
//         },
//       ),
//     );
//   }
// }







import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:moments/screens/events/completed_events_page.dart';
import 'package:moments/screens/events/event_calendar_screen.dart';
import 'package:moments/screens/events/my_events_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/editprofile_screen.dart';
import 'screens/events/create_event_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'screens/events/pinned_events_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'widgets/navigation_bar.dart';
import 'utils/theme.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Channel ID constants
const String momentsChannelId = 'moments_events';
const String highPriorityChannelId = 'moments_high_priority';

// Background FCM handler (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔄 [Background FCM] Message: ${message.messageId}');
  
  if (message.notification != null) {
    await showEnhancedNotification(message);
  }
}

// Background notification response handler
@pragma('vm:entry-point')
void backgroundNotificationHandler(NotificationResponse response) {
  debugPrint('🟢 Background notification tapped: ${response.payload}');
}

/// Handle notification tap with proper navigation
void handleNotificationTap(NotificationResponse response) {
  final payload = response.payload ?? '';
  final actionId = response.actionId ?? '';
  
  debugPrint('🟢 Notification tapped - Payload: $payload, Action: $actionId');
  
  if (payload.isNotEmpty) {
    _navigateFromPayload(payload);
  }
}

/// Navigate based on payload
void _navigateFromPayload(String payload) {
  if (payload.isEmpty) return;
  
  try {
    if (payload.startsWith('event_detail:')) {
      final eventToken = payload.split(':')[1];
      navigatorKey.currentState?.pushNamed(
        '/event-detail',
        arguments: {'eventToken': eventToken},
      );
    } else if (payload.startsWith('profile:')) {
      navigatorKey.currentState?.pushNamed('/profile');
    }
  } catch (e) {
    debugPrint('❌ Navigation error: $e');
  }
}

/// Show enhanced notification with proper configuration
Future<void> showEnhancedNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  Map<String, dynamic> data = message.data;

  if (notification != null) {
    String payload = data['screen'] ?? '';
    String notificationType = data['type'] ?? 'default';    

    // Determine channel and importance
    String channelId;
    Importance importance;
    Priority priority;
    
    if (['PRIVATE_EVENT_INVITATION', 'COMMENT_REPLY'].contains(notificationType)) {
      channelId = highPriorityChannelId;
      importance = Importance.max;
      priority = Priority.max;
    } else {
      channelId = momentsChannelId;
      importance = Importance.high;
      priority = Priority.high;
    }

    // Create Android notification details
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      'Moments Notifications',
      channelDescription: 'Notifications for Moments app events and interactions',
      importance: importance,
      priority: priority,
      
      // Essential for heads-up notifications
      ticker: 'Moments',
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      
      // Visual enhancements
      color: const Color(0xFF25D366),
      colorized: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
      
      // Sound configuration (commented out to avoid resource issues)
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('notification'),
      
      // Icon configuration
      icon: '@mipmap/moments', // Using app icon as fallback
      // largeIcon: const DrawableResourceAndroidBitmap('@mipmap/moments'),
      
      // Heads-up notification settings
      fullScreenIntent: false,
      category: AndroidNotificationCategory.social,
      visibility: NotificationVisibility.public,
      
      // Auto-cancel and timeout
      autoCancel: true,
      timeoutAfter: 15000, // 15 seconds
      
      // Group notifications
      groupKey: 'moments_notifications',
      setAsGroupSummary: false,
      
      // Style for expanded notification
      styleInformation: BigTextStyleInformation(
        notification.body ?? '',
        htmlFormatBigText: false,
        contentTitle: notification.title,
        htmlFormatContentTitle: false,
        summaryText: 'Moments App',
        htmlFormatSummaryText: false,
      ),
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'MOMENTS_CATEGORY',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      _generateNotificationId(message),
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );

    debugPrint('🔔 Enhanced notification shown: ${notification.title}');
  }
}

/// Generate unique notification ID
int _generateNotificationId(RemoteMessage message) {
  return message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

/// Initialize enhanced local notifications
Future<void> initializeEnhancedNotifications() async {
  // Android initialization with app icon
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/moments');

  // iOS initialization
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    requestCriticalPermission: false,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: handleNotificationTap,
  );

  await _createNotificationChannels();
}

/// Create notification channels with proper configuration
Future<void> _createNotificationChannels() async {
  final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlatform != null) {
    // High priority channel
    final AndroidNotificationChannel highPriorityChannel = AndroidNotificationChannel(
      highPriorityChannelId,
      'High Priority Notifications',
      description: 'Important notifications requiring immediate attention',
      importance: Importance.max,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 250, 500]),
      playSound: true,
      showBadge: true,
      ledColor: const Color(0xFFFF5733),
      enableLights: true,
    );

    // Regular priority channel
    final AndroidNotificationChannel regularChannel = AndroidNotificationChannel(
      momentsChannelId,
      'Moments Notifications',
      description: 'General notifications for Moments app',
      importance: Importance.high,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
      playSound: true,
      showBadge: true,
      ledColor: const Color(0xFF25D366),
      enableLights: true,
    );

    await androidPlatform.createNotificationChannel(highPriorityChannel);
    await androidPlatform.createNotificationChannel(regularChannel);
    
    debugPrint('✅ Notification channels created');
  }
}

/// Setup FCM listeners with proper error handling
void setupEnhancedFCMListener() {
  // Foreground message listener
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('🔄 [Foreground FCM] Message: ${message.messageId}');
    debugPrint('📱 Title: ${message.notification?.title}');
    debugPrint('📱 Body: ${message.notification?.body}');
    debugPrint('📱 Data: ${message.data}');
    
    showEnhancedNotification(message);
  });
  
  // Handle notification when app is opened from terminated state
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      debugPrint('🚀 App opened from terminated state via notification');
      _handleInitialMessage(message);
    }
  });
  
  // Handle notification when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('🔄 App opened from background via notification');
    _handleInitialMessage(message);
  });
}

/// Handle initial message navigation with delay
void _handleInitialMessage(RemoteMessage message) {
  final screen = message.data['screen'] ?? '';
  if (screen.isNotEmpty) {
    // Add delay to ensure app is fully initialized
    Future.delayed(const Duration(milliseconds: 1000), () {
      _navigateFromPayload(screen);
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize enhanced notifications
  await initializeEnhancedNotifications();
  
  // Request comprehensive permissions
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  
  debugPrint('📱 Notification permission status: ${settings.authorizationStatus}');
  
  // Get and log FCM token
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('📱 FCM Token: $token');
  } catch (e) {
    debugPrint('❌ Failed to get FCM token: $e');
  }
  
  // Setup handlers and listeners
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupEnhancedFCMListener();

  runApp(const MomentsApp());
}

class MomentsApp extends StatelessWidget {
  const MomentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Moments',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const MyNavigationBar(),
          '/profile': (context) => const ProfileScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/create-event': (context) => const CreateEventScreen(),
          '/event-calendar': (context) => const EventCalendarScreen(),
          '/pinned-events': (context) => const PinnedEventsScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/completed-events': (context) => const CompletedEventsPage(),
          '/my-events-screen': (context) => const MyEventsPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/event-detail') {
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('eventToken')) {
              return MaterialPageRoute(
                builder: (context) => EventDetailScreen(
                  eventToken: args['eventToken'],
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}