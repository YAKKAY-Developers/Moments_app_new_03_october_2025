// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:moments/widgets/event_card.dart';
// import 'package:provider/provider.dart';

// class PinnedEventsScreen extends StatefulWidget {
//   const PinnedEventsScreen({super.key});

//   @override
//   State<PinnedEventsScreen> createState() => _PinnedEventsScreenState();
// }

// class _PinnedEventsScreenState extends State<PinnedEventsScreen> {
//   List<EventModel> _pinnedEvents = [];
//   bool _isLoading = true;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPinnedEvents();
//   }

//   Future<void> _loadPinnedEvents() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       final pinnedEvents = await NetworkService.getPinnedEvents(authProvider.user!.userToken);
//       setState(() {
//         _pinnedEvents = pinnedEvents;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to load pinned events: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

// Future<void> _togglePinEvent(EventModel event) async {
//   final authProvider = context.read<AuthProvider>();
//   if (authProvider.user == null) return;

//   try {
//     final success = await NetworkService.togglePinEvent(
//       event.eventToken,
//       authProvider.user!.userToken,
//     );

//     if (success) {
//       await _loadPinnedEvents(); // More reliable than local remove
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Failed to update pin: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // ✅ removes the default back button
//         title: const Text('Pin',
//         style: TextStyle(
//           fontFamily: 'Poppins', // ✅ Use Poppins family
//           fontWeight: FontWeight.w500, // ✅ Medium weight
//           fontSize: 24,
//           color: Colors.white,
//         ),
//         ),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadPinnedEvents,
//         child: _buildContent(),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 16),
//             const Text('Failed to load pinned events'),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _loadPinnedEvents,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_pinnedEvents.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.push_pin_outlined,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No pinned events',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Pin events to access them quickly',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _pinnedEvents.length,
//       itemBuilder: (context, index) {
//         final event = _pinnedEvents[index];
//         return ModernEventCard(
//           event: event,
//           onTap: () => _navigateToEventDetail(event),
//           onPinPressed: () => _togglePinEvent(event),
//           isPinned: true,
//         );
//       },
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







//claude ai new 25-8-25

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:moments/utils/theme.dart';
import 'package:moments/widgets/event_card.dart';
import 'package:provider/provider.dart';

class PinnedEventsScreen extends StatefulWidget {
  const PinnedEventsScreen({super.key});

  @override
  State<PinnedEventsScreen> createState() => _PinnedEventsScreenState();
}

class _PinnedEventsScreenState extends State<PinnedEventsScreen> {
  List<EventModel> _pinnedEvents = [];
  final Set<String> _pinningInProgress = {}; // Track events being unpinned
  bool _isLoading = true;
  bool _hasError = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadPinnedEvents();
  }

  Future<void> _loadPinnedEvents() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    if (!_isRefreshing) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      if (kDebugMode) {
        print('🔄 Loading pinned events...');
      }

      final pinnedEvents = await NetworkService.getPinnedEvents(
        authProvider.user!.userToken,
      );

      if (!mounted) return;

      setState(() {
        _pinnedEvents = pinnedEvents;
        _isLoading = false;
        _hasError = false;
        _isRefreshing = false;
      });

      if (kDebugMode) {
        print('✅ Pinned events loaded: ${_pinnedEvents.length} events');
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _hasError = true;
        _isLoading = false;
        _isRefreshing = false;
      });

      _showErrorSnackBar('Failed to load pinned events: ${e.toString()}');
      
      if (kDebugMode) {
        print('❌ Failed to load pinned events: $e');
      }
    }
  }

  Future<void> _togglePinEvent(EventModel event) async {
    // Prevent multiple simultaneous operations
    if (_pinningInProgress.contains(event.eventToken)) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    setState(() {
      _pinningInProgress.add(event.eventToken);
    });

    try {
      final success = await NetworkService.togglePinEvent(
        event.eventToken,
        authProvider.user!.userToken,
      );

      if (!mounted) return;

      if (!success) {
        // Event was unpinned (since we're in the pinned events screen)
        setState(() {
          _pinnedEvents.removeWhere((e) => e.eventToken == event.eventToken);
        });

        _showSuccessSnackBar('📌 Event "${event.title}" unpinned successfully!');

        if (kDebugMode) {
          print('✅ Event unpinned: ${event.title}');
        }
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Failed to unpin event: ${e.toString()}');
      
      if (kDebugMode) {
        print('❌ Failed to unpin event ${event.title}: $e');
      }
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
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildModernAppBar(theme),
      body: _buildBody(theme),
    );
  }

PreferredSizeWidget _buildModernAppBar(ThemeData theme) {
  return AppBar(
    automaticallyImplyLeading: false, // we'll manually add the back button
    title: const Text(
      'Pinned Events',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 22,
        color: Colors.white,
      ),
    ),
    backgroundColor: AppTheme.primaryColor,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
        size: 20,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    actions: [
      if (!_isLoading && _pinnedEvents.isNotEmpty)
        IconButton(
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: _loadPinnedEvents,
        ),
    ],
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
  );
}

  // PreferredSizeWidget _buildModernAppBar(ThemeData theme) {
  //   return AppBar(
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     scrolledUnderElevation: 0,
  //     leading: IconButton(
  //       icon: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 8,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Icon(
  //           Icons.arrow_back_ios_rounded,
  //           size: 18,
  //           color: theme.primaryColor,
  //         ),
  //       ),
  //       onPressed: () => Navigator.pop(context),
  //     ),
  //     title: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Pinned Events',
  //           style: TextStyle(
  //             fontFamily: 'Poppins',
  //             fontWeight: FontWeight.w700,
  //             fontSize: 24,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         if (!_isLoading && !_hasError)
  //           Text(
  //             '${_pinnedEvents.length} event${_pinnedEvents.length != 1 ? 's' : ''}',
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: Colors.grey[600],
  //             ),
  //           ),
  //       ],
  //     ),
  //     actions: [
  //       if (!_isLoading && _pinnedEvents.isNotEmpty)
  //         Container(
  //           margin: const EdgeInsets.only(right: 16),
  //           child: IconButton(
  //             icon: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.1),
  //                     blurRadius: 8,
  //                     offset: const Offset(0, 2),
  //                   ),
  //                 ],
  //               ),
  //               child: Icon(
  //                 Icons.refresh_rounded,
  //                 size: 20,
  //                 color: theme.primaryColor,
  //               ),
  //             ),
  //             onPressed: _loadPinnedEvents,
  //           ),
  //         ),
  //     ],
  //     flexibleSpace: Container(
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [
  //             theme.primaryColor.withOpacity(0.1),
  //             Colors.transparent,
  //           ],
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading && !_isRefreshing) {
      return _buildLoadingState(theme);
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isRefreshing = true);
        await _loadPinnedEvents();
      },
      color: theme.primaryColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          if (_hasError)
            SliverFillRemaining(
              child: _buildErrorState(theme),
            )
          else if (_pinnedEvents.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(theme),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final event = _pinnedEvents[index];
                    final isPinning = _pinningInProgress.contains(event.eventToken);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ModernEventCard(
                          event: event,
                          onTap: () => _navigateToEventDetail(event),
                          onPinPressed: () => _togglePinEvent(event),
                          isPinned: true,
                          isPinning: isPinning,
                        ),
                      ),
                    );
                  },
                  childCount: _pinnedEvents.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading your pinned events...',
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

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t load your pinned events.\nPlease check your connection and try again.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadPinnedEvents,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    theme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.push_pin_rounded,
                size: 64,
                color: theme.primaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Pinned Events Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Pin your favorite events to see them here for quick access. Look for the pin icon on any event card!',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 20,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Tip: Use the pin button to save events you care about most',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: theme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
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








//old code working

// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/widgets/event_card.dart';
// import 'package:provider/provider.dart';

// class PinnedEventsScreen extends StatefulWidget {
//   const PinnedEventsScreen({super.key});

//   @override
//   State<PinnedEventsScreen> createState() => _PinnedEventsScreenState();
// }

// class _PinnedEventsScreenState extends State<PinnedEventsScreen> {
//   List<EventModel> _pinnedEvents = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isRefreshing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPinnedEvents();
//   }

//   Future<void> _loadPinnedEvents() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final pinnedEvents = await NetworkService.getPinnedEvents(authProvider.user!.userToken);
//       setState(() {
//         _pinnedEvents = pinnedEvents;
//         _isLoading = false;
//         _hasError = false;
//         _isRefreshing = false;
//       });
//     } catch (e) {
//       setState(() {
//         _hasError = true;
//         _isLoading = false;
//         _isRefreshing = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to load pinned events: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _togglePinEvent(EventModel event) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final success = await NetworkService.togglePinEvent(
//         event.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Event ${event.title} ${_pinnedEvents.contains(event) ? 'unpinned' : 'pinned'}'),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         await _loadPinnedEvents();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update pin: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Pin',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 24,
//           ),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.search),
//         //     onPressed: () {
//         //       // Implement search functionality
//         //     },
//         //   ),
//         // ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading && !_isRefreshing) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     return RefreshIndicator(
//       onRefresh: () async {
//         setState(() => _isRefreshing = true);
//         await _loadPinnedEvents();
//       },
//       child: CustomScrollView(
//         slivers: [
//           if (_hasError)
//             SliverFillRemaining(
//               child: _buildErrorState(),
//             )
//           else if (_pinnedEvents.isEmpty)
//             SliverFillRemaining(
//               child: _buildEmptyState(),
//             )
//           else
//             SliverPadding(
//               padding: const EdgeInsets.all(16),
//               sliver: SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final event = _pinnedEvents[index];
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 16),
//                       child: ModernEventCard(
//                         event: event,
//                         onTap: () => _navigateToEventDetail(event),
//                         onPinPressed: () => _togglePinEvent(event),
//                         isPinned: true,
//                       ),
//                     );
//                   },
//                   childCount: _pinnedEvents.length,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 48,
//             color: Theme.of(context).colorScheme.error,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'Failed to load pinned events',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Please check your connection and try again',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 24),
//           FilledButton(
//             onPressed: _loadPinnedEvents,
//             style: FilledButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('Retry'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.push_pin,
//             size: 64,
//             color: Colors.grey.withOpacity(0.5),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Pinned Events',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 48),
//             child: Text(
//               'Pin your favorite events to see them here for quick access',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                   ),
//             ),
//           ),
//           // const SizedBox(height: 24),
// //           FilledButton(
// // onPressed: () {
// //   Navigator.pushReplacement(
// //     context,
// //     MaterialPageRoute(builder: (context) => const HomePage()),
// //   );
// // },

// //             style: FilledButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //             ),
// //             child: const Text('Browse Events'),
// //           ),
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