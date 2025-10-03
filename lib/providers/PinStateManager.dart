// import 'package:flutter/foundation.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';

// /// Centralized pin state management to ensure consistency across the app
// class PinStateManager extends ChangeNotifier {
//   static final PinStateManager _instance = PinStateManager._internal();
//   factory PinStateManager() => _instance;
//   PinStateManager._internal();

//   // Track pinned events by their event tokens
//   final Set<String> _pinnedEventTokens = <String>{};
  
//   // Track events currently being pinned/unpinned
//   final Set<String> _pinningInProgress = <String>{};

//   /// Get all pinned event tokens
//   Set<String> get pinnedEventTokens => Set.unmodifiable(_pinnedEventTokens);

//   /// Check if an event is pinned
//   bool isPinned(String eventToken) {
//     return _pinnedEventTokens.contains(eventToken);
//   }

//   /// Check if an event is currently being pinned/unpinned
//   bool isPinning(String eventToken) {
//     return _pinningInProgress.contains(eventToken);
//   }

//   /// Initialize with pinned events from server
//   Future<void> initializePinnedEvents(String userToken) async {
//     try {
//       final pinnedEvents = await NetworkService.getPinnedEvents(userToken);
//       _pinnedEventTokens.clear();
//       _pinnedEventTokens.addAll(pinnedEvents.map((e) => e.eventToken));
      
//       if (kDebugMode) {
//         print('🔄 PinStateManager initialized with ${_pinnedEventTokens.length} pinned events');
//       }
      
//       notifyListeners();
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Failed to initialize pinned events: $e');
//       }
//     }
//   }

//   /// Toggle pin status for an event
//   Future<bool> togglePin(String eventToken, String userToken) async {
//     // Prevent multiple simultaneous operations
//     if (_pinningInProgress.contains(eventToken)) {
//       return isPinned(eventToken);
//     }

//     _pinningInProgress.add(eventToken);
//     notifyListeners();

//     try {
//       final newPinStatus = await NetworkService.togglePinEvent(eventToken, userToken);
      
//       if (newPinStatus) {
//         _pinnedEventTokens.add(eventToken);
//       } else {
//         _pinnedEventTokens.remove(eventToken);
//       }

//       if (kDebugMode) {
//         print('✅ Pin toggled: $eventToken is now ${newPinStatus ? 'pinned' : 'unpinned'}');
//       }

//       return newPinStatus;
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Failed to toggle pin for $eventToken: $e');
//       }
//       rethrow;
//     } finally {
//       _pinningInProgress.remove(eventToken);
//       notifyListeners();
//     }
//   }

//   /// Update pin status without making API call (for optimistic updates)
//   void updatePinStatus(String eventToken, bool isPinned) {
//     if (isPinned) {
//       _pinnedEventTokens.add(eventToken);
//     } else {
//       _pinnedEventTokens.remove(eventToken);
//     }
//     notifyListeners();
//   }

//   /// Apply pin status to a list of events
//   List<EventModel> applyPinStatus(List<EventModel> events) {
//     return events.map((event) {
//       return event.copyWith(isPinned: isPinned(event.eventToken));
//     }).toList();
//   }

//   /// Get only pinned events from a list
//   List<EventModel> getOnlyPinnedEvents(List<EventModel> events) {
//     return events.where((event) => isPinned(event.eventToken)).toList();
//   }

//   /// Clear all pin state (useful for logout)
//   void clear() {
//     _pinnedEventTokens.clear();
//     _pinningInProgress.clear();
//     notifyListeners();
//   }

//   /// Refresh pin status for specific events
//   Future<void> refreshPinStatus(List<String> eventTokens, String userToken) async {
//     try {
//       final pinStatuses = await NetworkService.checkMultiplePinnedStatus(
//         userToken, 
//         eventTokens,
//       );
      
//       // Update local state based on server response
//       for (final entry in pinStatuses.entries) {
//         if (entry.value) {
//           _pinnedEventTokens.add(entry.key);
//         } else {
//           _pinnedEventTokens.remove(entry.key);
//         }
//       }
      
//       if (kDebugMode) {
//         print('🔄 Refreshed pin status for ${eventTokens.length} events');
//       }
      
//       notifyListeners();
//     } catch (e) {
//       if (kDebugMode) {
//         print('❌ Failed to refresh pin status: $e');
//       }
//     }
//   }

//   /// Get count of pinned events
//   int get pinnedCount => _pinnedEventTokens.length;

//   /// Debug method to print current state
//   void debugPrintState() {
//     if (kDebugMode) {
//       print('📌 PinStateManager State:');
//       print('   - Pinned events: ${_pinnedEventTokens.length}');
//       print('   - Pinning in progress: ${_pinningInProgress.length}');
//       print('   - Pinned tokens: ${_pinnedEventTokens.take(5).join(', ')}${_pinnedEventTokens.length > 5 ? '...' : ''}');
//     }
//   }
// }