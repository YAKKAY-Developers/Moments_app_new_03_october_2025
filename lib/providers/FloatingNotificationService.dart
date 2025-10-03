import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:moments/main.dart';

class FloatingNotificationService {
  static OverlayEntry? _overlayEntry;
  // ignore: unused_field
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  // Set the navigator key (call this from your main.dart)
  static void setNavigatorKey(GlobalKey<NavigatorState> key) {
    // Use the key passed from main
  }

  // Show floating notification
  static void showFloatingNotification({
    required String title,
    required String body,
    String? imageUrl,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Remove existing notification if any
    hideFloatingNotification();

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingNotificationWidget(
        title: title,
        body: body,
        imageUrl: imageUrl,
        onTap: onTap,
        onDismiss: hideFloatingNotification,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Auto-dismiss after duration
    Timer(duration, () {
      hideFloatingNotification();
    });
  }

  // Hide floating notification
  static void hideFloatingNotification() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Handle FCM message and show floating notification
  static void handleFCMMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showFloatingNotification(
        title: notification.title ?? 'New Notification',
        body: notification.body ?? '',
        imageUrl: notification.android?.imageUrl,
        onTap: () {
          hideFloatingNotification();
          // Handle navigation based on message data
          final screen = message.data['screen'] ?? '';
          if (screen.isNotEmpty) {
            navigatorKey.currentState?.pushNamed('/$screen');
          }
        },
      );
    }
  }
}

class FloatingNotificationWidget extends StatefulWidget {
  final String title;
  final String body;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const FloatingNotificationWidget({
    super.key,
    required this.title,
    required this.body,
    this.imageUrl,
    this.onTap,
    this.onDismiss,
  });

  @override
  State<FloatingNotificationWidget> createState() => _FloatingNotificationWidgetState();
}

class _FloatingNotificationWidgetState extends State<FloatingNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onTap,
              onPanUpdate: (details) {
                // Swipe up to dismiss
                if (details.delta.dy < -5) {
                  _dismiss();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2D2D2D)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // App icon or notification icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.notifications,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.notifications,
                              color: Color(0xFF6C63FF),
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    // Notification content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.body,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Dismiss button
                    IconButton(
                      onPressed: _dismiss,
                      icon: Icon(
                        Icons.close,
                        size: 20,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}