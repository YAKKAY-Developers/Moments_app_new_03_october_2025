//working 13-8-25

// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/widgets/event_card.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<EventModel> _allEvents = [];
//   List<EventModel> _pinnedEvents = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.trim().toLowerCase();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadEvents() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final results = await Future.wait([
//         NetworkService.getAllEvents(),
//         NetworkService.getPinnedEvents(authProvider.user!.userToken),
//         NetworkService.getInvitedEvents(),
//       ]);

//       List<EventModel> allEvents = results[0];
//       final pinnedEvents = results[1];
//       final invitedEvents = results[2];

//       // Mark invited events
//       final invitedEventIds = invitedEvents.map((e) => e.id).toSet();
//       allEvents = allEvents.map((event) {
//         return event.copyWith(isInvited: invitedEventIds.contains(event.id));
//       }).toList();

//       // Mark pinned events
//       final pinnedEventIds = pinnedEvents.map((e) => e.id).toSet();
//       final updatedEvents = allEvents.map((event) {
//         return event.copyWith(isPinned: pinnedEventIds.contains(event.id));
//       }).toList();

//       if (!mounted) return;
//       setState(() {
//         _allEvents = updatedEvents;
//         _pinnedEvents = pinnedEvents;
//         _isLoading = false;
//       });
      
//       if (kDebugMode) {
//         print("All events loaded: ${_allEvents.length}");
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to load events: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _togglePinEvent(EventModel event) async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       if (authProvider.user == null) return;

//       final success = await NetworkService.togglePinEvent(
//         event.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (!mounted) return;

//       if (success) {
//         setState(() {
//           if (event.isPinned) {
//             _pinnedEvents.removeWhere((e) => e.id == event.id);
//           } else {
//             _pinnedEvents.add(event.copyWith(isPinned: true));
//           }
//           _allEvents = _allEvents.map((e) {
//             if (e.id == event.id) {
//               return e.copyWith(isPinned: !e.isPinned);
//             }
//             return e;
//           }).toList();
//         });
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update pin status: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();

//     return Scaffold(
//       body: Column(
//         children: [
//           _buildHeader(authProvider),
//           _buildSearchBar(),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _loadEvents,
//               child: _buildContent(),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.pushNamed(context, '/create-event'),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildHeader(AuthProvider authProvider) {
//     final user = authProvider.user;
//     final profileImage = (user != null && user.photo != null && user.photo!.isNotEmpty)
//         ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//         : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                 backgroundImage: profileImage,
//                 child: (user == null || user.photo == null || user.photo!.isEmpty)
//                     ? Icon(
//                         Icons.person,
//                         size: 20,
//                         color: Theme.of(context).primaryColor,
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Welcome,',
//                     style: TextStyle(
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     user?.name ?? 'Guest',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.all(4),
//             child: Image.asset(
//               'assets/images/moments1.png',
//               height: 50,
//               width: 50,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: SizedBox(
//         height: 40,
//         child: TextField(
//           controller: _searchController,
//           style: const TextStyle(fontSize: 14),
//           decoration: InputDecoration(
//             hintText: 'Search events...',
//             prefixIcon: const Icon(Icons.search, size: 20),
//             suffixIcon: _searchQuery.isNotEmpty
//                 ? IconButton(
//                     icon: const Icon(Icons.clear, size: 20),
//                     onPressed: () {
//                       _searchController.clear();
//                     },
//                   )
//                 : null,
//             filled: true,
//             fillColor: Theme.of(context)
//                 .colorScheme
//                 .surfaceContainerHighest
//                 .withOpacity(0.1),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 8,
//               horizontal: 12,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_hasError) {
//       return _buildErrorWidget();
//     }

//     // Get recently commented events (those with hasRecentComment: true)
//     final recentlyCommentedEvents = _allEvents.where((event) {
//       return event.latestComment != null && 
//              (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);
//     }).toList();

//     // Sort by last activity (newest first)
//     recentlyCommentedEvents.sort((a, b) {
//       final aTime = a.lastActivity ?? DateTime(0);
//       final bTime = b.lastActivity ?? DateTime(0);
//       return bTime.compareTo(aTime);
//     });

//     // Combine events - recently commented first, then others
//     final combinedEvents = [
//       ...recentlyCommentedEvents,
//       ..._allEvents.where((event) => !recentlyCommentedEvents.contains(event))
//     ];

//     final filteredEvents = combinedEvents.where((event) {
//       return _searchQuery.isEmpty ||
//           event.title.toLowerCase().contains(_searchQuery) ||
//           event.description.toLowerCase().contains(_searchQuery);
//     }).toList();

//     if (filteredEvents.isEmpty) {
//       return _buildEmptyWidget(
//           message: _searchQuery.isEmpty
//               ? null
//               : 'No events found for your search');
//     }

//     return ListView.builder(
//       itemCount: filteredEvents.length,
//       itemBuilder: (context, index) {
//         final event = filteredEvents[index];
//         final isRecentlyCommented = recentlyCommentedEvents.contains(event);

//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//           child: ModernEventCard(
//             event: event,
//             onTap: () => _navigateToEventDetail(event),
//             onPinPressed: () => _togglePinEvent(event),
//             isPinned: event.isPinned,
//             highlightComment: isRecentlyCommented,
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 48, color: Colors.red),
//           const SizedBox(height: 16),
//           const Text('Failed to load events', style: TextStyle(fontSize: 18)),
//           const SizedBox(height: 8),
//           ElevatedButton(
//             onPressed: _loadEvents,
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyWidget({String? message}) {
//     final theme = Theme.of(context);
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.event_note,
//               size: 80, color: theme.colorScheme.primary.withOpacity(0.3)),
//           const SizedBox(height: 16),
//           Text(
//             message ?? 'No events yet',
//             style: TextStyle(
//               fontSize: 18,
//               color: theme.colorScheme.onSurface.withOpacity(0.6),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           if (message == null) ...[
//             const SizedBox(height: 8),
//             Text(
//               'Create your first event to get started',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: theme.colorScheme.onSurface.withOpacity(0.5),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   void _navigateToEventDetail(EventModel event) {
//     Navigator.pushNamed(
//       context,
//       '/event-detail',
//       arguments: {'eventToken': event.eventToken},
//     );
//   }
// }














import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:moments/widgets/event_card.dart';
import 'package:provider/provider.dart';

// Updated HomeScreen with private event handling

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<EventModel> _allEvents = [];
  List<EventModel> _pinnedEvents = [];
  final Set<String> _pinningInProgress = {};
  final Set<String> _pinnedEventTokens = {};
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedFilterIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Updated filter options to show private events
  final List<String> _filterOptions = ['All', 'Today', 'This Week', 'Pinned', 'Private Events'];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Load all events (now includes privacy filtering on backend)
      final results = await Future.wait([
        NetworkService.getAllEvents(), // This now handles private event visibility
        NetworkService.getPinnedEvents(authProvider.user!.userToken),
        NetworkService.getInvitedEvents(), // Get events user is invited to
      ]);

      List<EventModel> allEvents = results[0];
      final pinnedEvents = results[1];
      final invitedEvents = results[2];

      // Create sets for efficient lookup
      final invitedEventIds = invitedEvents.map((e) => e.id).toSet();
      
      // Clear and update the pinned event tokens set
      _pinnedEventTokens.clear();
      _pinnedEventTokens.addAll(pinnedEvents.map((e) => e.eventToken));

      // Update events with invitation and pin status
      allEvents = allEvents.map((event) {
        final isPinned = _pinnedEventTokens.contains(event.eventToken);
        return event.copyWith(
          isInvited: invitedEventIds.contains(event.id),
          isPinned: isPinned,
        );
      }).toList();

      if (!mounted) return;
      
      setState(() {
        _allEvents = allEvents;
        _pinnedEvents = pinnedEvents;
        _isLoading = false;
        _hasError = false;
      });
      
      if (kDebugMode) {
        print("✅ Events loaded successfully:");
        print("   - All events: ${_allEvents.length}");
        print("   - Pinned events: ${_pinnedEvents.length}");
        print("   - Private events: ${_allEvents.where((e) => e.isPrivate).length}");
        print("   - Invited events: ${invitedEvents.length}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load events: $e');
    }
  }

  // Enhanced filtering with private events
  List<EventModel> _getFilteredEvents() {
    List<EventModel> events = [];

    switch (_selectedFilterIndex) {
      case 0: // All
        events = _allEvents;
        break;
      case 1: // Today
        final today = DateTime.now();
        events = _allEvents.where((event) {
          return event.date.year == today.year &&
                 event.date.month == today.month &&
                 event.date.day == today.day;
        }).toList();
        break;
      case 2: // This Week
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        events = _allEvents.where((event) {
          return event.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                 event.date.isBefore(weekEnd.add(const Duration(days: 1)));
        }).toList();
        break;
      case 3: // Pinned
        events = _pinnedEvents;
        break;
      case 4: // Private Events
        events = _allEvents.where((event) => event.isPrivate).toList();
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      events = events.where((event) {
        return event.title.toLowerCase().contains(_searchQuery) ||
               event.description.toLowerCase().contains(_searchQuery) ||
               event.category.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return events;
  }

  // Your existing methods (_togglePinEvent, _showSuccessSnackBar, etc.)...

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    if (!authProvider.isAuthenticated) {
      Future.microtask(() {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const SizedBox.shrink();
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildModernHeader(authProvider, theme),
          _buildSearchSection(theme),
          _buildFilterChips(theme),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadEvents,
              color: theme.primaryColor,
              backgroundColor: Colors.white,
              child: _buildContent(theme),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/create-event'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            label: const Text(
              'Create',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading your events...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    if (_hasError) {
      return _buildErrorWidget(theme);
    }

    final filteredEvents = _getFilteredEvents();

    if (filteredEvents.isEmpty) {
      String? emptyMessage;
      switch (_selectedFilterIndex) {
        case 4: // Private Events
          emptyMessage = 'No private events found';
          break;
        default:
          emptyMessage = _searchQuery.isEmpty ? null : 'No events found for your search';
      }
      
      return _buildEmptyWidget(
        theme: theme,
        message: emptyMessage,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          final isRecentlyCommented = event.latestComment != null && 
                                    (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);
          final isPinning = _pinningInProgress.contains(event.eventToken);
          final isPinned = _pinnedEventTokens.contains(event.eventToken);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ModernEventCard(
              event: event.copyWith(isPinned: isPinned),
              onTap: () => _navigateToEventDetail(event),
              onPinPressed: () => _togglePinEvent(event),
              isPinned: isPinned,
              isPinning: isPinning,
              highlightComment: isRecentlyCommented,
            ),
          );
        },
      ),
    );
  }

  // Your existing methods...
  
  Future<void> _togglePinEvent(EventModel event) async {
    if (_pinningInProgress.contains(event.eventToken)) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    setState(() {
      _pinningInProgress.add(event.eventToken);
    });

    try {
      final newPinStatus = await NetworkService.togglePinEvent(
        event.eventToken,
        authProvider.user!.userToken,
      );

      if (!mounted) return;

      setState(() {
        if (newPinStatus) {
          _pinnedEventTokens.add(event.eventToken);
        } else {
          _pinnedEventTokens.remove(event.eventToken);
        }

        _allEvents = _allEvents.map((e) {
          if (e.eventToken == event.eventToken) {
            return e.copyWith(isPinned: newPinStatus);
          }
          return e;
        }).toList();

        if (newPinStatus) {
          if (!_pinnedEvents.any((e) => e.eventToken == event.eventToken)) {
            final updatedEvent = event.copyWith(isPinned: true);
            _pinnedEvents.add(updatedEvent);
          }
        } else {
          _pinnedEvents.removeWhere((e) => e.eventToken == event.eventToken);
        }
      });

      _showSuccessSnackBar(
        newPinStatus 
          ? 'Event pinned successfully!' 
          : 'Event unpinned successfully!',
      );
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Failed to update pin status: $e');
    } finally {
      setState(() {
        _pinningInProgress.remove(event.eventToken);
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildModernHeader(AuthProvider authProvider, ThemeData theme) {
    final user = authProvider.user;
    final profileImage = (user != null && user.photo != null && user.photo!.isNotEmpty)
        ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
        : const AssetImage('assets/images/profile.png') as ImageProvider;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  backgroundImage: profileImage,
                  child: (user == null || user.photo == null || user.photo!.isEmpty)
                      ? Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: theme.primaryColor,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_getGreeting()},',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.name ?? 'Guest',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/pinned-events'),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.push_pin_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  Widget _buildSearchSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Search events, categories...',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search_rounded,
                size: 24,
                color: theme.primaryColor,
              ),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filterOptions.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedFilterIndex == index;
            final isPrivateFilter = index == 4; // Private Events filter
            
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isPrivateFilter) ...[
                      Icon(
                        Icons.lock_rounded,
                        size: 14,
                        color: isSelected ? Colors.white : theme.primaryColor,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      _filterOptions[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : theme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                selectedColor: isPrivateFilter ? Colors.orange : theme.primaryColor,
                elevation: isSelected ? 2 : 0,
                shadowColor: (isPrivateFilter ? Colors.orange : theme.primaryColor).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    color: isSelected 
                        ? (isPrivateFilter ? Colors.orange : theme.primaryColor)
                        : theme.primaryColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load your events. Please try again.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadEvents,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget({required ThemeData theme, String? message}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                message == 'No private events found' ? Icons.lock_outline_rounded : Icons.event_note_rounded,
                size: 64,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message ?? 'No events yet',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message == 'No private events found'
                  ? 'You haven\'t been invited to any private events'
                  : message == null 
                      ? 'Create your first event to get started'
                      : 'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (message == null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/create-event'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToEventDetail(EventModel event) {
    Navigator.pushNamed(
      context,
      '/event-detail',
      arguments: {'eventToken': event.eventToken},
    );
  }
}





// //claude ai 25-8-25
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/widgets/event_card.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   List<EventModel> _allEvents = [];
//   List<EventModel> _pinnedEvents = [];
//   final Set<String> _pinningInProgress = {}; // Track events being pinned/unpinned
//   final Set<String> _pinnedEventTokens = {}; // Keep track of pinned event tokens
//   bool _isLoading = true;
//   bool _hasError = false;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   int _selectedFilterIndex = 0;
//   late AnimationController _fabAnimationController;
//   late Animation<double> _fabAnimation;

//   final List<String> _filterOptions = ['All', 'Today', 'This Week', 'Pinned'];

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.trim().toLowerCase();
//       });
//     });
    
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fabAnimation = CurvedAnimation(
//       parent: _fabAnimationController,
//       curve: Curves.elasticOut,
//     );
//     _fabAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _fabAnimationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadEvents() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       // Load all events and pinned events in parallel
//       final results = await Future.wait([
//         NetworkService.getAllEvents(),
//         NetworkService.getPinnedEvents(authProvider.user!.userToken),
//         NetworkService.getInvitedEvents(),
//       ]);

//       List<EventModel> allEvents = results[0];
//       final pinnedEvents = results[1];
//       final invitedEvents = results[2];

//       // Create sets for efficient lookup
//       final invitedEventIds = invitedEvents.map((e) => e.id).toSet();
//       // ignore: unused_local_variable
//       final pinnedEventIds = pinnedEvents.map((e) => e.id).toSet();
      
//       // Clear and update the pinned event tokens set
//       _pinnedEventTokens.clear();
//       _pinnedEventTokens.addAll(pinnedEvents.map((e) => e.eventToken));

//       // Update events with invitation and pin status
//       allEvents = allEvents.map((event) {
//         final isPinned = _pinnedEventTokens.contains(event.eventToken);
//         return event.copyWith(
//           isInvited: invitedEventIds.contains(event.id),
//           isPinned: isPinned,
//         );
//       }).toList();

//       if (!mounted) return;
      
//       setState(() {
//         _allEvents = allEvents;
//         _pinnedEvents = pinnedEvents;
//         _isLoading = false;
//         _hasError = false;
//       });
      
//       if (kDebugMode) {
//         print("✅ Events loaded successfully:");
//         print("   - All events: ${_allEvents.length}");
//         print("   - Pinned events: ${_pinnedEvents.length}");
//         print("   - Pinned event tokens: $_pinnedEventTokens");
//         print("   - Invited events: ${invitedEvents.length}");
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//       _showErrorSnackBar('Failed to load events: $e');
//     }
//   }

//   Future<void> _togglePinEvent(EventModel event) async {
//     // Prevent multiple simultaneous pin operations on the same event
//     if (_pinningInProgress.contains(event.eventToken)) {
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     // Add to in-progress set
//     setState(() {
//       _pinningInProgress.add(event.eventToken);
//     });

//     try {
//       final newPinStatus = await NetworkService.togglePinEvent(
//         event.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (!mounted) return;

//       // Update the pinned event tokens set
//       setState(() {
//         if (newPinStatus) {
//           _pinnedEventTokens.add(event.eventToken);
//         } else {
//           _pinnedEventTokens.remove(event.eventToken);
//         }

//         // Update in _allEvents
//         _allEvents = _allEvents.map((e) {
//           if (e.eventToken == event.eventToken) {
//             return e.copyWith(isPinned: newPinStatus);
//           }
//           return e;
//         }).toList();

//         // Update _pinnedEvents list
//         if (newPinStatus) {
//           // Event was pinned - add to pinned events if not already there
//           if (!_pinnedEvents.any((e) => e.eventToken == event.eventToken)) {
//             final updatedEvent = event.copyWith(isPinned: true);
//             _pinnedEvents.add(updatedEvent);
//           }
//         } else {
//           // Event was unpinned - remove from pinned events
//           _pinnedEvents.removeWhere((e) => e.eventToken == event.eventToken);
//         }
//       });

//       // Show success message
//       _showSuccessSnackBar(
//         newPinStatus 
//           ? '📌 Event pinned successfully!' 
//           : '📌 Event unpinned successfully!',
//       );

//       if (kDebugMode) {
//         print('✅ Pin toggled: ${event.title} is now ${newPinStatus ? 'pinned' : 'unpinned'}');
//         print('✅ Updated pinned tokens: $_pinnedEventTokens');
//       }
//     } catch (e) {
//       if (!mounted) return;
//       _showErrorSnackBar('Failed to update pin status: $e');
      
//       if (kDebugMode) {
//         print('❌ Pin toggle failed for ${event.title}: $e');
//       }
//     } finally {
//       // Remove from in-progress set
//       setState(() {
//         _pinningInProgress.remove(event.eventToken);
//       });
//     }
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 3),
//         margin: const EdgeInsets.all(16),
//         action: SnackBarAction(
//           label: 'Dismiss',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   // List<EventModel> _getFilteredEvents() {
//   //   List<EventModel> events = [];
    
//   //   switch (_selectedFilterIndex) {
//   //     case 0: // All
//   //       events = _allEvents;
//   //       break;
//   //     case 1: // Today
//   //       final today = DateTime.now();
//   //       events = _allEvents.where((event) {
//   //         return event.date.year == today.year &&
//   //                event.date.month == today.month &&
//   //                event.date.day == today.day;
//   //       }).toList();
//   //       break;
//   //     case 2: // This Week
//   //       final now = DateTime.now();
//   //       final weekStart = now.subtract(Duration(days: now.weekday - 1));
//   //       final weekEnd = weekStart.add(const Duration(days: 6));
//   //       events = _allEvents.where((event) {
//   //         return event.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
//   //                event.date.isBefore(weekEnd.add(const Duration(days: 1)));
//   //       }).toList();
//   //       break;
//   //     case 3: // Pinned
//   //       events = _pinnedEvents;
//   //       break;
//   //   }

//   //   // Apply search filter
//   //   if (_searchQuery.isNotEmpty) {
//   //     events = events.where((event) {
//   //       return event.title.toLowerCase().contains(_searchQuery) ||
//   //              event.description.toLowerCase().contains(_searchQuery) ||
//   //              event.category.toLowerCase().contains(_searchQuery);
//   //     }).toList();
//   //   }

//   //   // Sort by priority: recently commented first, then by date
//   //   final recentlyCommentedEvents = events.where((event) {
//   //     return event.latestComment != null && 
//   //            (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);
//   //   }).toList();

//   //   recentlyCommentedEvents.sort((a, b) {
//   //     final aTime = a.lastActivity ?? DateTime(0);
//   //     final bTime = b.lastActivity ?? DateTime(0);
//   //     return bTime.compareTo(aTime);
//   //   });

//   //   final otherEvents = events.where((event) => !recentlyCommentedEvents.contains(event)).toList();
//   //   otherEvents.sort((a, b) => a.date.compareTo(b.date));

//   //   return [...recentlyCommentedEvents, ...otherEvents];
//   // }


// List<EventModel> _getFilteredEvents() {
//   List<EventModel> events = [];

//   switch (_selectedFilterIndex) {
//     case 0: // All
//       events = _allEvents;
//       break;
//     case 1: // Today
//       final today = DateTime.now();
//       events = _allEvents.where((event) {
//         return event.date.year == today.year &&
//                event.date.month == today.month &&
//                event.date.day == today.day;
//       }).toList();
//       break;
//     case 2: // This Week
//       final now = DateTime.now();
//       final weekStart = now.subtract(Duration(days: now.weekday - 1));
//       final weekEnd = weekStart.add(const Duration(days: 6));
//       events = _allEvents.where((event) {
//         return event.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
//                event.date.isBefore(weekEnd.add(const Duration(days: 1)));
//       }).toList();
//       break;
//     case 3: // Pinned
//       events = _pinnedEvents;
//       break;
//   }

//   // Apply search filter
//   if (_searchQuery.isNotEmpty) {
//     events = events.where((event) {
//       return event.title.toLowerCase().contains(_searchQuery) ||
//              event.description.toLowerCase().contains(_searchQuery) ||
//              event.category.toLowerCase().contains(_searchQuery);
//     }).toList();
//   }

//   return events; // ✅ Keep backend sort order
// }


// // List<EventModel> _getFilteredEvents() {
// //   List<EventModel> events = [];
  
// //   switch (_selectedFilterIndex) {
// //     case 0: // All
// //       events = _allEvents;
// //       break;
// //     case 1: // Today
// //       final today = DateTime.now();
// //       events = _allEvents.where((event) {
// //         return event.date.year == today.year &&
// //                event.date.month == today.month &&
// //                event.date.day == today.day;
// //       }).toList();
// //       break;
// //     case 2: // This Week
// //       final now = DateTime.now();
// //       final weekStart = now.subtract(Duration(days: now.weekday - 1));
// //       final weekEnd = weekStart.add(const Duration(days: 6));
// //       events = _allEvents.where((event) {
// //         return event.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
// //                event.date.isBefore(weekEnd.add(const Duration(days: 1)));
// //       }).toList();
// //       break;
// //     case 3: // Pinned
// //       events = _pinnedEvents;
// //       break;
// //   }

// //   // Apply search filter
// //   if (_searchQuery.isNotEmpty) {
// //     events = events.where((event) {
// //       return event.title.toLowerCase().contains(_searchQuery) ||
// //              event.description.toLowerCase().contains(_searchQuery) ||
// //              event.category.toLowerCase().contains(_searchQuery);
// //     }).toList();
// //   }

// //   // Enhanced sorting with multiple priority levels
// //   final now = DateTime.now();
  
// //   // 1. Events with very recent comments (last 24 hours)
// //   final veryRecentCommentedEvents = events.where((event) {
// //     return event.latestComment != null && 
// //            DateTime.parse(event.latestComment!.createdAt)
// //              .isAfter(now.subtract(const Duration(hours: 24)));
// //   }).toList();
  
// //   // 2. Events with recent comments (last 7 days)
// //   final recentCommentedEvents = events.where((event) {
// //     return event.latestComment != null && 
// //            DateTime.parse(event.latestComment!.createdAt)
// //              .isAfter(now.subtract(const Duration(days: 7))) &&
// //            !veryRecentCommentedEvents.contains(event);
// //   }).toList();
  
// //   // 3. Upcoming events (future events)
// //   final upcomingEvents = events.where((event) {
// //     return event.date.isAfter(now) &&
// //            !veryRecentCommentedEvents.contains(event) &&
// //            !recentCommentedEvents.contains(event);
// //   }).toList();
  
// //   // 4. Past events with no recent comments
// //   final pastEvents = events.where((event) {
// //     return event.date.isBefore(now) &&
// //            !veryRecentCommentedEvents.contains(event) &&
// //            !recentCommentedEvents.contains(event);
// //   }).toList();
  
// //   // Sort each category
// //   veryRecentCommentedEvents.sort((a, b) {
// //     final aTime = DateTime.parse(a.latestComment!.createdAt);
// //     final bTime = DateTime.parse(b.latestComment!.createdAt);
// //     return bTime.compareTo(aTime); // Newest comments first
// //   });
  
// //   recentCommentedEvents.sort((a, b) {
// //     final aTime = DateTime.parse(a.latestComment!.createdAt);
// //     final bTime = DateTime.parse(b.latestComment!.createdAt);
// //     return bTime.compareTo(aTime); // Newest comments first
// //   });
  
// //   upcomingEvents.sort((a, b) => a.date.compareTo(b.date)); // Soonest first
// //   pastEvents.sort((a, b) => b.date.compareTo(a.date)); // Most recent first
  
// //   // Combine all categories in priority order
// //   return [
// //     ...veryRecentCommentedEvents,
// //     ...recentCommentedEvents,
// //     ...upcomingEvents,
// //     ...pastEvents,
// //   ];
// // }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//     final theme = Theme.of(context);

//   // 🔹 Redirect if not authenticated
//   if (!authProvider.isAuthenticated) {
//     Future.microtask(() {
//       // ignore: use_build_context_synchronously
//       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     });
//     return const SizedBox.shrink();
//   }
  
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: Column(
//         children: [
//           _buildModernHeader(authProvider, theme),
//           _buildSearchSection(theme),
//           _buildFilterChips(theme),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _loadEvents,
//               color: theme.primaryColor,
//               backgroundColor: Colors.white,
//               child: _buildContent(theme),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: ScaleTransition(
//         scale: _fabAnimation,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               colors: [
//                 theme.primaryColor,
//                 theme.primaryColor.withOpacity(0.8),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: theme.primaryColor.withOpacity(0.3),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: FloatingActionButton.extended(
//             onPressed: () => Navigator.pushNamed(context, '/create-event'),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
//             label: const Text(
//               'Create',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernHeader(AuthProvider authProvider, ThemeData theme) {
//     final user = authProvider.user;
//     final profileImage = (user != null && user.photo != null && user.photo!.isNotEmpty)
//         ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//         : const AssetImage('assets/images/user_avatar.png') as ImageProvider;

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//           child: Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.white,
//                   backgroundImage: profileImage,
//                   child: (user == null || user.photo == null || user.photo!.isEmpty)
//                       ? Icon(
//                           Icons.person_rounded,
//                           size: 24,
//                           color: theme.primaryColor,
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Good ${_getGreeting()},',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       user?.name ?? 'Guest',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Container(
//               //   padding: const EdgeInsets.all(12),
//               //   decoration: BoxDecoration(
//               //     color: Colors.white.withOpacity(0.15),
//               //     borderRadius: BorderRadius.circular(16),
//               //   ),
//               //   child: const Icon(
//               //     Icons.push_pin_rounded,
//               //     color: Colors.white,
//               //     size: 24,
//               //   ),
//               // ),
//               Container(
//   padding: const EdgeInsets.all(12),
//   decoration: BoxDecoration(
//     color: Colors.white.withOpacity(0.15),
//     borderRadius: BorderRadius.circular(16),
//   ),
//   child: InkWell(
//     borderRadius: BorderRadius.circular(16), // ripple stays inside container
//     onTap: () => Navigator.pushNamed(context, '/pinned-events'),
//     child: const Icon(
//       Icons.push_pin_rounded,
//       color: Colors.white,
//       size: 24,
//     ),
//   ),
// ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Morning';
//     if (hour < 17) return 'Afternoon';
//     return 'Evening';
//   }

//   Widget _buildSearchSection(ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: TextField(
//           controller: _searchController,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: 'Search events, categories...',
//             hintStyle: TextStyle(
//               color: Colors.grey[500],
//               fontWeight: FontWeight.w400,
//             ),
//             prefixIcon: Container(
//               padding: const EdgeInsets.all(12),
//               child: Icon(
//                 Icons.search_rounded,
//                 size: 24,
//                 color: theme.primaryColor,
//               ),
//             ),
//             suffixIcon: _searchQuery.isNotEmpty
//                 ? IconButton(
//                     icon: Icon(
//                       Icons.close_rounded,
//                       size: 20,
//                       color: Colors.grey[600],
//                     ),
//                     onPressed: () {
//                       _searchController.clear();
//                     },
//                   )
//                 : null,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChips(ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//         height: 45,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: _filterOptions.length,
//           itemBuilder: (context, index) {
//             final isSelected = _selectedFilterIndex == index;
//             return Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: FilterChip(
//                 selected: isSelected,
//                 label: Text(
//                   _filterOptions[index],
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : theme.primaryColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 backgroundColor: Colors.white,
//                 selectedColor: theme.primaryColor,
//                 elevation: isSelected ? 2 : 0,
//                 shadowColor: theme.primaryColor.withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   side: BorderSide(
//                     color: isSelected ? theme.primaryColor : theme.primaryColor.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                 ),
//                 onSelected: (selected) {
//                   setState(() {
//                     _selectedFilterIndex = index;
//                   });
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(ThemeData theme) {
//     if (_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
//                 strokeWidth: 3,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading your events...',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
    
//     if (_hasError) {
//       return _buildErrorWidget(theme);
//     }

//     final filteredEvents = _getFilteredEvents();

//     if (filteredEvents.isEmpty) {
//       return _buildEmptyWidget(
//         theme: theme,
//         message: _searchQuery.isEmpty ? null : 'No events found for your search',
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListView.builder(
//         padding: const EdgeInsets.only(top: 16, 
//         bottom: 10),
//         itemCount: filteredEvents.length,
//         itemBuilder: (context, index) {
//           final event = filteredEvents[index];
//           final isRecentlyCommented = event.latestComment != null && 
//                                     (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);
//           final isPinning = _pinningInProgress.contains(event.eventToken);
          
//           // Use the pinned event tokens set for accurate pin status
//           final isPinned = _pinnedEventTokens.contains(event.eventToken);

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: ModernEventCard(
//               event: event.copyWith(isPinned: isPinned), // Ensure correct pin status
//               onTap: () => _navigateToEventDetail(event),
//               onPinPressed: () => _togglePinEvent(event),
//               isPinned: isPinned,
//               isPinning: isPinning,
//               highlightComment: isRecentlyCommented,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildErrorWidget(ThemeData theme) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(32),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline_rounded,
//                 size: 48,
//                 color: Colors.red[400],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Oops! Something went wrong',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'We couldn\'t load your events. Please try again.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _loadEvents,
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text('Try Again'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: theme.primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyWidget({required ThemeData theme, String? message}) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(32),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: theme.primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.event_note_rounded,
//                 size: 64,
//                 color: theme.primaryColor,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               message ?? 'No events yet',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               message == null 
//                   ? 'Create your first event to get started'
//                   : 'Try adjusting your search or filters',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (message == null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () => Navigator.pushNamed(context, '/create-event'),
//                 icon: const Icon(Icons.add_rounded),
//                 label: const Text('Create Event'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: theme.primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToEventDetail(EventModel event) {
//     Navigator.pushNamed(
//       context,
//       '/event-detail',
//       arguments: {'eventToken': event.eventToken},
//     );
//   }
// }





















//claude ai  old



// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/widgets/event_card.dart';
// import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   List<EventModel> _allEvents = [];
//   List<EventModel> _pinnedEvents = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   int _selectedFilterIndex = 0;
//   late AnimationController _fabAnimationController;
//   late Animation<double> _fabAnimation;

//   final List<String> _filterOptions = ['All', 'Today', 'This Week', 'Pinned'];

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.trim().toLowerCase();
//       });
//     });
    
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fabAnimation = CurvedAnimation(
//       parent: _fabAnimationController,
//       curve: Curves.elasticOut,
//     );
//     _fabAnimationController.forward();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _fabAnimationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadEvents() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final results = await Future.wait([
//         NetworkService.getAllEvents(),
//         NetworkService.getPinnedEvents(authProvider.user!.userToken),
//         NetworkService.getInvitedEvents(),
//       ]);

//       List<EventModel> allEvents = results[0];
//       final pinnedEvents = results[1];
//       final invitedEvents = results[2];

//       // Mark invited events
//       final invitedEventIds = invitedEvents.map((e) => e.id).toSet();
//       allEvents = allEvents.map((event) {
//         return event.copyWith(isInvited: invitedEventIds.contains(event.id));
//       }).toList();

//       // Mark pinned events
//       final pinnedEventIds = pinnedEvents.map((e) => e.id).toSet();
//       final updatedEvents = allEvents.map((event) {
//         return event.copyWith(isPinned: pinnedEventIds.contains(event.id));
//       }).toList();

//       if (!mounted) return;
//       setState(() {
//         _allEvents = updatedEvents;
//         _pinnedEvents = pinnedEvents;
//         _isLoading = false;
//       });
      
//       if (kDebugMode) {
//         print("All events loaded: ${_allEvents.length}");
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to load events: $e'),
//           backgroundColor: Colors.red[400],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   Future<void> _togglePinEvent(EventModel event) async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       if (authProvider.user == null) return;

//       final success = await NetworkService.togglePinEvent(
//         event.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (!mounted) return;

//       if (success) {
//         setState(() {
//           if (event.isPinned) {
//             _pinnedEvents.removeWhere((e) => e.id == event.id);
//           } else {
//             _pinnedEvents.add(event.copyWith(isPinned: true));
//           }
//           _allEvents = _allEvents.map((e) {
//             if (e.id == event.id) {
//               return e.copyWith(isPinned: !e.isPinned);
//             }
//             return e;
//           }).toList();
//         });
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(event.isPinned ? 'Event unpinned' : 'Event pinned'),
//             backgroundColor: Colors.green[400],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update pin status: $e'),
//           backgroundColor: Colors.red[400],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   List<EventModel> _getFilteredEvents() {
//     List<EventModel> events = [];
    
//     switch (_selectedFilterIndex) {
//       case 0: // All
//         events = _allEvents;
//         break;
//       case 1: // Today
//         final today = DateTime.now();
//         events = _allEvents.where((event) {
//           return event.date.year == today.year &&
//                  event.date.month == today.month &&
//                  event.date.day == today.day;
//         }).toList();
//         break;
//       case 2: // This Week
//         final now = DateTime.now();
//         final weekStart = now.subtract(Duration(days: now.weekday - 1));
//         final weekEnd = weekStart.add(const Duration(days: 6));
//         events = _allEvents.where((event) {
//           return event.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
//                  event.date.isBefore(weekEnd.add(const Duration(days: 1)));
//         }).toList();
//         break;
//       case 3: // Pinned
//         events = _pinnedEvents;
//         break;
//     }

//     // Apply search filter
//     if (_searchQuery.isNotEmpty) {
//       events = events.where((event) {
//         return event.title.toLowerCase().contains(_searchQuery) ||
//                event.description.toLowerCase().contains(_searchQuery) ||
//                event.category.toLowerCase().contains(_searchQuery);
//       }).toList();
//     }

//     // Sort by priority: recently commented first, then by date
//     final recentlyCommentedEvents = events.where((event) {
//       return event.latestComment != null && 
//              (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);
//     }).toList();

//     recentlyCommentedEvents.sort((a, b) {
//       final aTime = a.lastActivity ?? DateTime(0);
//       final bTime = b.lastActivity ?? DateTime(0);
//       return bTime.compareTo(aTime);
//     });

//     final otherEvents = events.where((event) => !recentlyCommentedEvents.contains(event)).toList();
//     otherEvents.sort((a, b) => a.date.compareTo(b.date));

//     return [...recentlyCommentedEvents, ...otherEvents];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: Column(
//         children: [
//           _buildModernHeader(authProvider, theme),
//           _buildSearchSection(theme),
//           _buildFilterChips(theme),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _loadEvents,
//               color: theme.primaryColor,
//               backgroundColor: Colors.white,
//               child: _buildContent(theme),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: ScaleTransition(
//         scale: _fabAnimation,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: LinearGradient(
//               colors: [
//                 theme.primaryColor,
//                 theme.primaryColor.withOpacity(0.8),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: theme.primaryColor.withOpacity(0.3),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: FloatingActionButton.extended(
//             onPressed: () => Navigator.pushNamed(context, '/create-event'),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
//             label: const Text(
//               'Create',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildModernHeader(AuthProvider authProvider, ThemeData theme) {
//     final user = authProvider.user;
//     final profileImage = (user != null && user.photo != null && user.photo!.isNotEmpty)
//         ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//         : const AssetImage('assets/images/default_avatar.png') as ImageProvider;

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             theme.primaryColor,
//             theme.primaryColor.withOpacity(0.8),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
//           child: Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 24,
//                   backgroundColor: Colors.white,
//                   backgroundImage: profileImage,
//                   child: (user == null || user.photo == null || user.photo!.isEmpty)
//                       ? Icon(
//                           Icons.person_rounded,
//                           size: 24,
//                           color: theme.primaryColor,
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Good ${_getGreeting()},',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       user?.name ?? 'Guest',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: const Icon(
//                   Icons.notifications_rounded,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//     // Container(
//     //   decoration: const BoxDecoration(
//     //     shape: BoxShape.circle,
//     //     color: Colors.white, // white background
//     //   ),
//     //   padding: const EdgeInsets.all(12), // spacing inside the circle
//     //   child: Image.asset(
//     //     'assets/images/moments1.png',
//     //     height: 28,
//     //     width: 28,
//     //     fit: BoxFit.contain,
//     //   ),
//     // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'Morning';
//     if (hour < 17) return 'Afternoon';
//     return 'Evening';
//   }

//   Widget _buildSearchSection(ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: TextField(
//           controller: _searchController,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           decoration: InputDecoration(
//             hintText: 'Search events, categories...',
//             hintStyle: TextStyle(
//               color: Colors.grey[500],
//               fontWeight: FontWeight.w400,
//             ),
//             prefixIcon: Container(
//               padding: const EdgeInsets.all(12),
//               child: Icon(
//                 Icons.search_rounded,
//                 size: 24,
//                 color: theme.primaryColor,
//               ),
//             ),
//             suffixIcon: _searchQuery.isNotEmpty
//                 ? IconButton(
//                     icon: Icon(
//                       Icons.close_rounded,
//                       size: 20,
//                       color: Colors.grey[600],
//                     ),
//                     onPressed: () {
//                       _searchController.clear();
//                     },
//                   )
//                 : null,
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChips(ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: SizedBox(
//         height: 45,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           itemCount: _filterOptions.length,
//           itemBuilder: (context, index) {
//             final isSelected = _selectedFilterIndex == index;
//             return Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: FilterChip(
//                 selected: isSelected,
//                 label: Text(
//                   _filterOptions[index],
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : theme.primaryColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//                 backgroundColor: Colors.white,
//                 selectedColor: theme.primaryColor,
//                 elevation: isSelected ? 2 : 0,
//                 shadowColor: theme.primaryColor.withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   side: BorderSide(
//                     color: isSelected ? theme.primaryColor : theme.primaryColor.withOpacity(0.3),
//                     width: 1.5,
//                   ),
//                 ),
//                 onSelected: (selected) {
//                   setState(() {
//                     _selectedFilterIndex = index;
//                   });
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(ThemeData theme) {
//     if (_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
//                 strokeWidth: 3,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading your events...',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
    
//     if (_hasError) {
//       return _buildErrorWidget(theme);
//     }

//     final filteredEvents = _getFilteredEvents();

//     if (filteredEvents.isEmpty) {
//       return _buildEmptyWidget(
//         theme: theme,
//         message: _searchQuery.isEmpty ? null : 'No events found for your search',
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListView.builder(
//         padding: const EdgeInsets.only(top: 16, bottom: 100),
//         itemCount: filteredEvents.length,
//         itemBuilder: (context, index) {
//           final event = filteredEvents[index];
//           final isRecentlyCommented = event.latestComment != null && 
//                                     (event.lastActivity?.isAfter(DateTime.now().subtract(const Duration(days: 7))) ?? false);

//           return Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: ModernEventCard(
//               event: event,
//               onTap: () => _navigateToEventDetail(event),
//               onPinPressed: () => _togglePinEvent(event),
//               isPinned: event.isPinned,
//               highlightComment: isRecentlyCommented,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildErrorWidget(ThemeData theme) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(32),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.red[50],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline_rounded,
//                 size: 48,
//                 color: Colors.red[400],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Oops! Something went wrong',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'We couldn\'t load your events. Please try again.',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _loadEvents,
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text('Try Again'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: theme.primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyWidget({required ThemeData theme, String? message}) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(32),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: theme.primaryColor.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.event_note_rounded,
//                 size: 64,
//                 color: theme.primaryColor,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               message ?? 'No events yet',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               message == null 
//                   ? 'Create your first event to get started'
//                   : 'Try adjusting your search or filters',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (message == null) ...[
//               const SizedBox(height: 24),
//               ElevatedButton.icon(
//                 onPressed: () => Navigator.pushNamed(context, '/create-event'),
//                 icon: const Icon(Icons.add_rounded),
//                 label: const Text('Create Event'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: theme.primaryColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToEventDetail(EventModel event) {
//     Navigator.pushNamed(
//       context,
//       '/event-detail',
//       arguments: {'eventToken': event.eventToken},
//     );
//   }
// }