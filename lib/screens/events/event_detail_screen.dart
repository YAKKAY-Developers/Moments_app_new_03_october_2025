
// //working code 10-9-25

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_invitation_screen.dart';
// import 'package:moments/widgets/comment_section.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class EventDetailScreen extends StatefulWidget {
//   final String eventToken;

//   const EventDetailScreen({
//     super.key,
//     required this.eventToken,
//   });

//   @override
//   State<EventDetailScreen> createState() => _EventDetailScreenState();
// }

// class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
//   late Future<EventModel> _eventFuture;
//   bool _isPinned = false;
//   bool _isLoading = true;
//   bool _isCheckingPinStatus = false;
//   late AnimationController _fabController;
//   late AnimationController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     _eventFuture = _loadEventDetails();
//     _checkPinnedStatus();
//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _imageController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fabController.forward();
//     _imageController.forward();
//   }

//   @override
//   void dispose() {
//     _fabController.dispose();
//     _imageController.dispose();
//     super.dispose();
//   }

//   Future<EventModel> _loadEventDetails() async {
//     try {
//       final event = await NetworkService.getEventDetail(widget.eventToken);
//       setState(() {
//         _isLoading = false;
//       });
//       return event;
//     } catch (e) {
//       setState(() => _isLoading = false);
//       throw Exception('Failed to load event details: $e');
//     }
//   }

//   Future<void> _checkPinnedStatus() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final isPinned = await NetworkService.checkPinnedStatus(
//         authProvider.user!.userToken,
//         widget.eventToken,
//       );
//       setState(() {
//         _isPinned = isPinned;
//         _isCheckingPinStatus = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to check pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _togglePin() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final success = await NetworkService.togglePinEvent(
//         widget.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (success) {
//         setState(() {
//           _isPinned = !_isPinned;
//         });
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(
//                   _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(_isPinned ? 'Event pinned!' : 'Event unpinned!'),
//               ],
//             ),
//             backgroundColor: const Color(0xFF10B981),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//     }
//   }

//   Future<void> _shareEventWithImage(EventModel event) async {
//     try {
//       final String shareText = '''
// ✨ ${event.title}

// 📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
// 🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
// 📍 Location: ${event.location ?? 'Not specified'}

// ${event.description}

// 🔗 Check it out here: ${event.shareLink ?? 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps'}

// Shared via Moments App ✨
// ''';

//       if (event.imageUrl == null) {
//         await Share.share(shareText);
//         return;
//       }

//       final uri = Uri.parse(NetworkService.getImageUrl(event.imageUrl!, type: 'event'));
//       final file = await DefaultCacheManager().getSingleFile(uri.toString());

//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: shareText,
//         subject: 'Event: ${event.title}',
//       );
//     } catch (e) {
//       debugPrint('Error sharing event: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to share event. Please try again.'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildShimmerLoading() {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 350,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.grey[300]!,
//                     Colors.grey[100]!,
//                     Colors.grey[300]!,
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 28,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     height: 20,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ...List.generate(3, (index) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Container(
//                       height: 16,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: FutureBuilder<EventModel>(
//         future: _eventFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.isPrivate) {
//             return ScaleTransition(
//               scale: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: FloatingActionButton.extended(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) => 
//                           EventInvitationScreen(
//                             eventToken: widget.eventToken,
//                             eventName: snapshot.data!.title,
//                             organizerName: snapshot.data!.displayCreatorName,
//                             shareLink: snapshot.data!.shareLink ?? 
//                               'https://momentsapp.page.link/event?token=${widget.eventToken}',
//                           ),
//                         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                           return SlideTransition(
//                             position: Tween<Offset>(
//                               begin: const Offset(1.0, 0.0),
//                               end: Offset.zero,
//                             ).animate(CurvedAnimation(
//                               parent: animation,
//                               curve: Curves.easeInOutCubic,
//                             )),
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   label: const Row(
//                     children: [
//                       Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         'Invite',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       body: FutureBuilder<EventModel>(
//         future: _eventFuture,
//         builder: (context, snapshot) {
//           if (_isLoading) {
//             return _buildShimmerLoading();
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Container(
//                 margin: const EdgeInsets.all(20),
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFEE2E2),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Icon(
//                         Icons.error_outline_rounded,
//                         size: 48,
//                         color: Color(0xFFE53E3E),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Oops! Something went wrong',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Failed to load event details',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _isLoading = true;
//                             _eventFuture = _loadEventDetails();
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text(
//                           'Try Again',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           if (snapshot.hasData) {
//             final event = snapshot.data!;
            
//             return Column(
//               children: [
//                 // Event Details Section - Scrollable
//                 Expanded(
//                   child: CustomScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     slivers: [
//                       SliverAppBar(
//                         expandedHeight: 350,
//                         pinned: true,
//                         stretch: true,
//                         backgroundColor: Colors.white,
//                         surfaceTintColor: Colors.transparent,
//                         elevation: 0,
//                         flexibleSpace: FlexibleSpaceBar(
//                           stretchModes: const [
//                             StretchMode.zoomBackground,
//                             StretchMode.blurBackground,
//                           ],
//                           background: FadeTransition(
//                             opacity: _imageController,
//                             child: Stack(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     image: event.imageUrl != null
//                                         ? DecorationImage(
//                                             image: NetworkImage(
//                                               NetworkService.getImageUrl(event.imageUrl!, type: 'event'),
//                                             ),
//                                             fit: BoxFit.cover,
//                                           )
//                                         : null,
//                                     gradient: event.imageUrl == null
//                                         ? const LinearGradient(
//                                             colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                                             begin: Alignment.topLeft,
//                                             end: Alignment.bottomRight,
//                                           )
//                                         : null,
//                                   ),
//                                   child: event.imageUrl == null
//                                       ? const Center(
//                                           child: Icon(
//                                             Icons.event_rounded,
//                                             size: 80,
//                                             color: Colors.white,
//                                           ),
//                                         )
//                                       : null,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.black.withOpacity(0.3),
//                                         Colors.transparent,
//                                         Colors.black.withOpacity(0.8),
//                                       ],
//                                       stops: const [0.0, 0.5, 1.0],
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 60,
//                                   left: 20,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       color: _getCategoryColor(event.category),
//                                       borderRadius: BorderRadius.circular(20),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: _getCategoryColor(event.category).withOpacity(0.3),
//                                           blurRadius: 6,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           _getCategoryIcon(event.category),
//                                           color: Colors.white,
//                                           size: 16,
//                                         ),
//                                         const SizedBox(width: 6),
//                                         Text(
//                                           event.category,
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                             child: Container(
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//                                 onPressed: () => Navigator.pop(context),
//                               ),
//                             ),
//                           ),
//                         ),
//                         actions: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                               child: Container(
//                                 margin: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: _isCheckingPinStatus
//                                     ? const Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: SizedBox(
//                                           width: 24,
//                                           height: 24,
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                           ),
//                                         ),
//                                       )
//                                     : IconButton(
//                                         icon: AnimatedSwitcher(
//                                           duration: const Duration(milliseconds: 300),
//                                           child: Icon(
//                                             _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
//                                             key: ValueKey(_isPinned),
//                                             color: _isPinned ? Theme.of(context).primaryColor : Colors.white,
//                                           ),
//                                         ),
//                                         onPressed: _togglePin,
//                                       ),
//                               ),
//                             ),
//                           ),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                               child: Container(
//                                 margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: IconButton(
//                                   icon: const Icon(Icons.share_rounded, color: Colors.white),
//                                   onPressed: () => _shareEventWithImage(event),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
                      
//                       SliverToBoxAdapter(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFF8FAFC),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Event Title & Privacy Status
//                                 Container(
//                                   padding: const EdgeInsets.all(24),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         event.title,
//                                         style: const TextStyle(
//                                           fontSize: 26,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xFF1F2937),
//                                           height: 1.3,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 16),
                                      
//                                       Row(
//                                         children: [
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12,
//                                               vertical: 6,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: event.isPrivate 
//                                                   ? const Color(0xFFFEF3C7)
//                                                   : const Color(0xFFDCFDF7),
//                                               borderRadius: BorderRadius.circular(12),
//                                             ),
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 Icon(
//                                                   event.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
//                                                   size: 16,
//                                                   color: event.isPrivate 
//                                                       ? const Color(0xFFA16207)
//                                                       : const Color(0xFF047857),
//                                                 ),
//                                                 const SizedBox(width: 6),
//                                                 Text(
//                                                   event.isPrivate ? 'PRIVATE' : 'PUBLIC',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 12,
//                                                     color: event.isPrivate 
//                                                         ? const Color(0xFFA16207)
//                                                         : const Color(0xFF047857),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           if (event.creatorName != null && event.creatorName!.isNotEmpty) ...[
//                                             const SizedBox(width: 12),
//                                             Expanded(
//                                               child: Row(
//                                                 children: [
//                                                   Container(
//                                                     padding: const EdgeInsets.all(2),
//                                                     decoration: BoxDecoration(
//                                                       gradient: const LinearGradient(
//                                                         colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                                                       ),
//                                                       borderRadius: BorderRadius.circular(8),
//                                                     ),
//                                                     child: const Icon(
//                                                       Icons.person_rounded,
//                                                       size: 16,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                   Expanded(
//                                                     child: Text(
//                                                       'by ${event.displayCreatorName}',
//                                                       style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight: FontWeight.w500,
//                                                         color: Colors.grey[600],
//                                                       ),
//                                                       overflow: TextOverflow.ellipsis,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 const SizedBox(height: 20),

//                                 // Event Details Card
//                                 Container(
//                                   padding: const EdgeInsets.all(24),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(0.05),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Event Details',
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xFF1F2937),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 20),
                                      
//                                       _buildDetailRow(
//                                         Icons.calendar_today_rounded,
//                                         'Date',
//                                         DateFormat('EEEE, MMMM d, yyyy').format(event.date),
//                                         const Color(0xFF3B82F6),
//                                       ),
//                                       const SizedBox(height: 16),

//                                       _buildDetailRow(
//                                         Icons.access_time_rounded,
//                                         'Time',
//                                         event.time.isNotEmpty ? event.time : 'Not specified',
//                                         const Color(0xFF10B981),
//                                       ),
//                                       const SizedBox(height: 16),

//                                       if (event.location != null) ...[
//                                         _buildDetailRow(
//                                           Icons.location_on_rounded,
//                                           'Location',
//                                           event.location!,
//                                           const Color(0xFFE53E3E),
//                                         ),
//                                         const SizedBox(height: 16),
//                                       ],

//                                       const Divider(height: 32),

//                                       const Text(
//                                         'Description',
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Color(0xFF1F2937),
//                                         ),
//                                       ),
//                                       const SizedBox(height: 12),
//                                       Text(
//                                         event.description,
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           height: 1.6,
//                                           color: Colors.grey[700],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Comment Section - Full Width with Sticky Input
//                 CommentSection(eventToken: widget.eventToken),
//               ],
//             );
//           }
//           return _buildShimmerLoading();
//         },
//       ),
//     );
//   }

//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return const Color(0xFFE91E63);
//       case 'anniversary':
//       case 'wedding':
//         return const Color(0xFFF44336);
//       case 'meeting':
//       case 'meetup':
//         return const Color(0xFF2196F3);
//       case 'party':
//         return const Color(0xFF9C27B0);
//       case 'holiday':
//         return const Color(0xFF4CAF50);
//       case 'reminder':
//         return const Color(0xFFFF9800);
//       case 'conference':
//         return const Color(0xFF607D8B);
//       case 'workshop':
//         return const Color(0xFF795548);
//       default:
//         return const Color(0xFF6366F1);
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return Icons.cake_rounded;
//       case 'anniversary':
//       case 'wedding':
//         return Icons.favorite_rounded;
//       case 'meeting':
//       case 'meetup':
//         return Icons.people_rounded;
//       case 'party':
//         return Icons.celebration_rounded;
//       case 'holiday':
//         return Icons.beach_access_rounded;
//       case 'reminder':
//         return Icons.notifications_rounded;
//       case 'conference':
//         return Icons.business_rounded;
//       case 'workshop':
//         return Icons.school_rounded;
//       default:
//         return Icons.event_rounded;
//     }
//   }

//   Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             color: iconColor,
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }




















// ignore_for_file: unused_field

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:moments/screens/events/event_invitation_screen.dart';
import 'package:moments/widgets/comment_section.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';




// class EventDetailScreen extends StatefulWidget {
//   final String eventToken;
//   final String? invitationToken; // Add for deep link handling

//   const EventDetailScreen({
//     super.key,
//     required this.eventToken,
//     this.invitationToken,
//   });

//   @override
//   State<EventDetailScreen> createState() => _EventDetailScreenState();
// }

// class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
//   late Future<EventModel> _eventFuture;
//   bool _isPinned = false;
//   bool _isLoading = true;
//   bool _isCheckingPinStatus = false;
//   late AnimationController _fabController;
//   late AnimationController _imageController;
//   bool _isInvitationEvent = false;
//   Map<String, dynamic>? _invitationData;

//   // Comment section state
//   bool _showComments = false;
//   final DraggableScrollableController _commentController = DraggableScrollableController();
  
//   @override
//   void initState() {
//     super.initState();
//     _eventFuture = _loadEventDetails();
//     _checkPinnedStatus();
//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _imageController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fabController.forward();
//     _imageController.forward();
//   }

//   @override
//   void dispose() {
//     _fabController.dispose();
//     _imageController.dispose();
//     _commentController.dispose();
//     super.dispose();
//   }


class EventDetailScreen extends StatefulWidget {
  final String eventToken;
  final String? invitationToken; // Add for deep link handling

  const EventDetailScreen({
    super.key,
    required this.eventToken,
    this.invitationToken,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
  late Future<EventModel> _eventFuture;
  bool _isPinned = false;
  bool _isLoading = true;
  bool _isCheckingPinStatus = false;
  bool _isInvitationEvent = false;
  Map<String, dynamic>? _invitationData;
  
  late AnimationController _fabController;
  late AnimationController _imageController;
  
  bool _showComments = false;
  final DraggableScrollableController _commentController = DraggableScrollableController();
  
  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fabController.forward();
    _imageController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _imageController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    // Handle invitation token if provided
    if (widget.invitationToken != null) {
      await _handleInvitationAccess();
    } else {
      _eventFuture = _loadEventDetails();
      _checkPinnedStatus();
    }
  }

  Future<void> _handleInvitationAccess() async {
    try {
      setState(() => _isLoading = true);

      // Get invitation details
      final invitationDetails = await NetworkService.getInvitationDetails(widget.invitationToken!);
      
      setState(() {
        _invitationData = invitationDetails['data'];
        _isInvitationEvent = true;
      });

      // Check if user is logged in
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user == null) {
        // Show login/signup dialog for invitation access
        _showInvitationLoginDialog();
      } else {
        // Auto-accept invitation if user is logged in
        await _acceptInvitation();
        // Load event details after accepting
        _eventFuture = _loadEventDetails();
        _checkPinnedStatus();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Invalid or expired invitation link');
    }
  }

  Future<void> _acceptInvitation() async {
    try {
      final result = await NetworkService.acceptEventInvitation(widget.invitationToken!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Joined "${result['data']['event_name']}"!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      _showMessage('Failed to accept invitation: $e');
    }
  }

  // Future<EventModel> _loadEventDetails() async {
  //   try {
  //     final event = await NetworkService.getEventDetail(widget.eventToken);
  //     setState(() => _isLoading = false);
  //     return event;
  //   } catch (e) {
  //     setState(() => _isLoading = false);
  //     throw Exception('Failed to load event details: $e');
  //   }
  // }

  Future<EventModel> _loadEventDetails() async {
    try {
      final event = await NetworkService.getEventDetail(widget.eventToken);
      setState(() {
        _isLoading = false;
      });
      return event;
    } catch (e) {
      setState(() => _isLoading = false);
      throw Exception('Failed to load event details: $e');
    }
  }

  Future<void> _checkPinnedStatus() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    setState(() {
      _isCheckingPinStatus = true;
    });

    try {
      final isPinned = await NetworkService.checkPinnedStatus(
        authProvider.user!.userToken,
        widget.eventToken,
      );
      setState(() {
        _isPinned = isPinned;
        _isCheckingPinStatus = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingPinStatus = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check pin status: $e'),
            backgroundColor: const Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _togglePin() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    setState(() {
      _isCheckingPinStatus = true;
    });

    try {
      final success = await NetworkService.togglePinEvent(
        widget.eventToken,
        authProvider.user!.userToken,
      );

      if (success) {
        setState(() {
          _isPinned = !_isPinned;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(_isPinned ? 'Event pinned!' : 'Event unpinned!'),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update pin status: $e'),
            backgroundColor: const Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      setState(() {
        _isCheckingPinStatus = false;
      });
    }
  }

  Future<void> _shareEventWithImage(EventModel event) async {
    try {
      final String shareText = '''
✨ ${event.title}

📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
📍 Location: ${event.location ?? 'Not specified'}

${event.description}

🔗 Check it out here: ${event.shareLink ?? 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps'}

Shared via Moments App ✨
''';

      if (event.imageUrl == null) {
        await Share.share(shareText);
        return;
      }

      final uri = Uri.parse(NetworkService.getImageUrl(event.imageUrl!, type: 'event'));
      final file = await DefaultCacheManager().getSingleFile(uri.toString());

      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
        subject: 'Event: ${event.title}',
      );
    } catch (e) {
      debugPrint('Error sharing event: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share event. Please try again.'),
            backgroundColor: const Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _openCommentSheet() {
    setState(() {
      _showComments = true;
    });
  }

  void _closeCommentSheet() {
    setState(() {
      _showComments = false;
    });
  }


  void _showInvitationLoginDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.mail_outline_rounded,
                color: Colors.purple.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Event Invitation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_invitationData != null) ...[
              Text(
                'You\'ve been invited to:',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _invitationData!['event']['event_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'by ${_invitationData!['event']['organizer_name']}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text('Please log in or create an account to join this private event.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('LOGIN'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  Widget _buildShimmerLoading() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[100]!,
                    Colors.grey[300]!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 28,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 20,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0xFFF8FAFC),
  //     extendBodyBehindAppBar: true,
  //     floatingActionButton: FutureBuilder<EventModel>(
  //       future: _eventFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasData && snapshot.data!.isPrivate) {
  //           return ScaleTransition(
  //             scale: Tween<double>(begin: 0.0, end: 1.0).animate(
  //               CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
  //             ),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 gradient: const LinearGradient(
  //                   colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: const Color(0xFF8B5CF6).withOpacity(0.3),
  //                     blurRadius: 20,
  //                     offset: const Offset(0, 8),
  //                   ),
  //                 ],
  //               ),
  //               child: FloatingActionButton.extended(
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     PageRouteBuilder(
  //                       pageBuilder: (context, animation, secondaryAnimation) => 
  //                         EventInvitationScreen(
  //                           eventToken: widget.eventToken,
  //                           eventName: snapshot.data!.title,
  //                           organizerName: snapshot.data!.displayCreatorName,
  //                           shareLink: snapshot.data!.shareLink ?? 
  //                             'https://momentsapp.page.link/event?token=${widget.eventToken}',
  //                         ),
  //                       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //                         return SlideTransition(
  //                           position: Tween<Offset>(
  //                             begin: const Offset(1.0, 0.0),
  //                             end: Offset.zero,
  //                           ).animate(CurvedAnimation(
  //                             parent: animation,
  //                             curve: Curves.easeInOutCubic,
  //                           )),
  //                           child: child,
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 },
  //                 backgroundColor: Colors.transparent,
  //                 elevation: 0,
  //                 label: const Row(
  //                   children: [
  //                     Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
  //                     SizedBox(width: 8),
  //                     Text(
  //                       'Invite',
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //         return const SizedBox.shrink();
  //       },
  //     ),


  // Update the FloatingActionButton section in your build method:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      floatingActionButton: FutureBuilder<EventModel>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isPrivate) {
            final authProvider = context.read<AuthProvider>();
            final isOwner = authProvider.user != null && 
                          snapshot.data!.creatorName == authProvider.user!.name;
            
            // Only show invite button for event owners
            if (isOwner) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF25D366), Color(0xFF20BA5A)], // WhatsApp colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF25D366).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => 
                            WhatsAppInvitationScreen(
                              eventToken: widget.eventToken,
                              eventName: snapshot.data!.title,
                              organizerName: snapshot.data!.displayCreatorName,
                              shareLink: snapshot.data!.shareLink ?? 
                                'https://momentsapp.page.link/event?token=${widget.eventToken}',
                            ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOutCubic,
                              )),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    label: const Row(
                      children: [
                        Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Invite',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),

      body: Stack(
        children: [
          // Main content
          FutureBuilder<EventModel>(
            future: _eventFuture,
            builder: (context, snapshot) {
              if (_isLoading) {
                return _buildShimmerLoading();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Color(0xFFE53E3E),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Oops! Something went wrong',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load event details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _eventFuture = _loadEventDetails();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Try Again',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                final event = snapshot.data!;
                
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 350,
                      pinned: true,
                      stretch: true,
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const [
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                        ],
                        background: FadeTransition(
                          opacity: _imageController,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: event.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            NetworkService.getImageUrl(event.imageUrl!, type: 'event'),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  gradient: event.imageUrl == null
                                      ? const LinearGradient(
                                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                ),
                                child: event.imageUrl == null
                                    ? const Center(
                                        child: Icon(
                                          Icons.event_rounded,
                                          size: 80,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.3),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(event.category),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getCategoryColor(event.category).withOpacity(0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getCategoryIcon(event.category),
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        event.category,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _isCheckingPinStatus
                                  ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        child: Icon(
                                          _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                                          key: ValueKey(_isPinned),
                                          color: _isPinned ? Theme.of(context).primaryColor : Colors.white,
                                        ),
                                      ),
                                      onPressed: _togglePin,
                                    ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.share_rounded, color: Colors.white),
                                onPressed: () => _shareEventWithImage(event),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              if (event.isInvited && !_isEventOwner(event))
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF25D366), Color(0xFF20BA5A)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'You\'re invited!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'You have access to this private event',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // Event Title & Privacy Status
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: event.isPrivate 
                                                ? const Color(0xFFFEF3C7)
                                                : const Color(0xFFDCFDF7),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                event.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
                                                size: 16,
                                                color: event.isPrivate 
                                                    ? const Color(0xFFA16207)
                                                    : const Color(0xFF047857),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                event.isPrivate ? 'PRIVATE' : 'PUBLIC',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: event.isPrivate 
                                                      ? const Color(0xFFA16207)
                                                      : const Color(0xFF047857),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (event.creatorName != null && event.creatorName!.isNotEmpty) ...[
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.person_rounded,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'by ${event.displayCreatorName}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey[600],
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // const SizedBox(height: 10),

                              // Event Details Card
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Event Details',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    
                                    _buildDetailRow(
                                      Icons.calendar_today_rounded,
                                      'Date',
                                      DateFormat('EEEE, MMMM d, yyyy').format(event.date),
                                      const Color(0xFF3B82F6),
                                    ),
                                    const SizedBox(height: 16),

                                    _buildDetailRow(
                                      Icons.access_time_rounded,
                                      'Time',
                                      event.time.isNotEmpty ? event.time : 'Not specified',
                                      const Color(0xFF10B981),
                                    ),
                                    const SizedBox(height: 16),

                                    if (event.location != null) ...[
                                      _buildDetailRow(
                                        Icons.location_on_rounded,
                                        'Location',
                                        event.location!,
                                        const Color(0xFFE53E3E),
                                      ),
                                      const SizedBox(height: 10),
                                    ],

                                    const Divider(height: 10),
                                      const SizedBox(height: 10),

                                    const Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    // const SizedBox(height: 12),
                                    Text(
                                      event.description,
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Comment Button
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _openCommentSheet,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.chat_bubble_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'View Comments',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10), // Extra space for the bottom sheet
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return _buildShimmerLoading();
            },
          ),




// In your EventDetailScreen class, replace the DraggableScrollableSheet section with this:

// Draggable Comment Bottom Sheet
if (_showComments)
  DraggableScrollableSheet(
    controller: _commentController,
    // initialChildSize: 0.5,
    // minChildSize: 0.1,
    // maxChildSize: 1.0, // Allow full screen
    // snap: true,
    // snapSizes: const [0.1, 0.5, 1.0], // Include full screen and half screen snap position
    initialChildSize: 0.5,
    minChildSize: 0.5,   // 👈 start at 50%, cannot go smaller
    maxChildSize: 1.0,   // 👈 allow full screen
    snap: true,
    snapSizes: const [0.5, 1.0], // 👈 only 50% and full screen
    builder: (context, scrollController) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag Handle and Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200]!,
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle - user can drag this to resize the sheet
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Header with close button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const Spacer(),
                        // Close button
                        GestureDetector(
                          onTap: _closeCommentSheet,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Comment Section Content
            Expanded(
              child: CommentSection(
                eventToken: widget.eventToken,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      );
    },
  ),
        ],
      ),
    );
  }

  bool _isEventOwner(EventModel event) {
    final authProvider = context.read<AuthProvider>();
    return authProvider.user != null && 
           event.creatorName == authProvider.user!.name;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'birthday':
        return const Color(0xFFE91E63);
      case 'anniversary':
      case 'wedding':
        return const Color(0xFFF44336);
      case 'meeting':
      case 'meetup':
        return const Color(0xFF2196F3);
      case 'party':
        return const Color(0xFF9C27B0);
      case 'holiday':
        return const Color(0xFF4CAF50);
      case 'reminder':
        return const Color(0xFFFF9800);
      case 'conference':
        return const Color(0xFF607D8B);
      case 'workshop':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'birthday':
        return Icons.cake_rounded;
      case 'anniversary':
      case 'wedding':
        return Icons.favorite_rounded;
      case 'meeting':
      case 'meetup':
        return Icons.people_rounded;
      case 'party':
        return Icons.celebration_rounded;
      case 'holiday':
        return Icons.beach_access_rounded;
      case 'reminder':
        return Icons.notifications_rounded;
      case 'conference':
        return Icons.business_rounded;
      case 'workshop':
        return Icons.school_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}







// event detail comment section like (chatbot)

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_invitation_screen.dart';
// import 'package:moments/widgets/comment_section.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class EventDetailScreen extends StatefulWidget {
//   final String eventToken;

//   const EventDetailScreen({
//     super.key,
//     required this.eventToken,
//   });

//   @override
//   State<EventDetailScreen> createState() => _EventDetailScreenState();
// }

// class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
//   late Future<EventModel> _eventFuture;
//   bool _isPinned = false;
//   bool _isLoading = true;
//   bool _isCheckingPinStatus = false;
//   bool _showCommentSection = false; // Add comment section visibility state
//   late AnimationController _fabController;
//   late AnimationController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     _eventFuture = _loadEventDetails();
//     _checkPinnedStatus();
//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _imageController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fabController.forward();
//     _imageController.forward();
//   }

//   @override
//   void dispose() {
//     _fabController.dispose();
//     _imageController.dispose();
//     super.dispose();
//   }

//   Future<EventModel> _loadEventDetails() async {
//     try {
//       final event = await NetworkService.getEventDetail(widget.eventToken);
//       setState(() {
//         _isLoading = false;
//       });
//       return event;
//     } catch (e) {
//       setState(() => _isLoading = false);
//       throw Exception('Failed to load event details: $e');
//     }
//   }

//   Future<void> _checkPinnedStatus() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final isPinned = await NetworkService.checkPinnedStatus(
//         authProvider.user!.userToken,
//         widget.eventToken,
//       );
//       setState(() {
//         _isPinned = isPinned;
//         _isCheckingPinStatus = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to check pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _togglePin() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final success = await NetworkService.togglePinEvent(
//         widget.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (success) {
//         setState(() {
//           _isPinned = !_isPinned;
//         });
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(
//                   _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(_isPinned ? 'Event pinned!' : 'Event unpinned!'),
//               ],
//             ),
//             backgroundColor: const Color(0xFF10B981),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//     }
//   }

//   Future<void> _shareEventWithImage(EventModel event) async {
//     try {
//       final String shareText = '''
// ✨ ${event.title}

// 📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
// 🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
// 📍 Location: ${event.location ?? 'Not specified'}

// ${event.description}

// 🔗 Check it out here: ${event.shareLink ?? 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps'}

// Shared via Moments App ✨
// ''';

//       if (event.imageUrl == null) {
//         await Share.share(shareText);
//         return;
//       }

//       final uri = Uri.parse(NetworkService.getImageUrl(event.imageUrl!, type: 'event'));
//       final file = await DefaultCacheManager().getSingleFile(uri.toString());

//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: shareText,
//         subject: 'Event: ${event.title}',
//       );
//     } catch (e) {
//       debugPrint('Error sharing event: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to share event. Please try again.'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildShimmerLoading() {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 350,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.grey[300]!,
//                     Colors.grey[100]!,
//                     Colors.grey[300]!,
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 28,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     height: 20,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ...List.generate(3, (index) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Container(
//                       height: 16,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           // Comment toggle button
//           ScaleTransition(
//             scale: Tween<double>(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
//             ),
//             child: Container(
//               margin: const EdgeInsets.only(right: 16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF3B82F6).withOpacity(0.3),
//                     blurRadius: 15,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: FloatingActionButton(
//                 heroTag: "comment_fab",
//                 onPressed: () {
//                   setState(() {
//                     _showCommentSection = !_showCommentSection;
//                   });
//                 },
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 200),
//                   child: Icon(
//                     _showCommentSection ? Icons.close_rounded : Icons.chat_bubble_outline_rounded,
//                     key: ValueKey(_showCommentSection),
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           // Invite button (only for private events)
//           FutureBuilder<EventModel>(
//             future: _eventFuture,
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data!.isPrivate) {
//                 return ScaleTransition(
//                   scale: Tween<double>(begin: 0.0, end: 1.0).animate(
//                     CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: FloatingActionButton.extended(
//                       heroTag: "invite_fab",
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (context, animation, secondaryAnimation) => 
//                               EventInvitationScreen(
//                                 eventToken: widget.eventToken,
//                                 eventName: snapshot.data!.title,
//                                 organizerName: snapshot.data!.displayCreatorName,
//                                 shareLink: snapshot.data!.shareLink ?? 
//                                   'https://momentsapp.page.link/event?token=${widget.eventToken}',
//                               ),
//                             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                               return SlideTransition(
//                                 position: Tween<Offset>(
//                                   begin: const Offset(1.0, 0.0),
//                                   end: Offset.zero,
//                                 ).animate(CurvedAnimation(
//                                   parent: animation,
//                                   curve: Curves.easeInOutCubic,
//                                 )),
//                                 child: child,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       label: const Row(
//                         children: [
//                           Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             'Invite',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           // Main event details
//           FutureBuilder<EventModel>(
//             future: _eventFuture,
//             builder: (context, snapshot) {
//               if (_isLoading) {
//                 return _buildShimmerLoading();
//               }

//               if (snapshot.hasError) {
//                 return Center(
//                   child: Container(
//                     margin: const EdgeInsets.all(20),
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFEE2E2),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: const Icon(
//                             Icons.error_outline_rounded,
//                             size: 48,
//                             color: Color(0xFFE53E3E),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         const Text(
//                           'Oops! Something went wrong',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1F2937),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Failed to load event details',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 _isLoading = true;
//                                 _eventFuture = _loadEventDetails();
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                             ),
//                             child: const Text(
//                               'Try Again',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }

//               if (snapshot.hasData) {
//                 final event = snapshot.data!;
                
//                 return CustomScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   slivers: [
//                     SliverAppBar(
//                       expandedHeight: 350,
//                       pinned: true,
//                       stretch: true,
//                       backgroundColor: Colors.white,
//                       surfaceTintColor: Colors.transparent,
//                       elevation: 0,
//                       flexibleSpace: FlexibleSpaceBar(
//                         stretchModes: const [
//                           StretchMode.zoomBackground,
//                           StretchMode.blurBackground,
//                         ],
//                         background: FadeTransition(
//                           opacity: _imageController,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   image: event.imageUrl != null
//                                       ? DecorationImage(
//                                           image: NetworkImage(
//                                             NetworkService.getImageUrl(event.imageUrl!, type: 'event'),
//                                           ),
//                                           fit: BoxFit.cover,
//                                         )
//                                       : null,
//                                   gradient: event.imageUrl == null
//                                       ? const LinearGradient(
//                                           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                                           begin: Alignment.topLeft,
//                                           end: Alignment.bottomRight,
//                                         )
//                                       : null,
//                                 ),
//                                 child: event.imageUrl == null
//                                     ? const Center(
//                                         child: Icon(
//                                           Icons.event_rounded,
//                                           size: 80,
//                                           color: Colors.white,
//                                         ),
//                                       )
//                                     : null,
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [
//                                       Colors.black.withOpacity(0.3),
//                                       Colors.transparent,
//                                       Colors.black.withOpacity(0.8),
//                                     ],
//                                     stops: const [0.0, 0.5, 1.0],
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 60,
//                                 left: 20,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                   decoration: BoxDecoration(
//                                     color: _getCategoryColor(event.category),
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: _getCategoryColor(event.category).withOpacity(0.3),
//                                         blurRadius: 6,
//                                         offset: const Offset(0, 2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         _getCategoryIcon(event.category),
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       const SizedBox(width: 6),
//                                       Text(
//                                         event.category,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w600,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                           child: Container(
//                             margin: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: IconButton(
//                               icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//                               onPressed: () => Navigator.pop(context),
//                             ),
//                           ),
//                         ),
//                       ),
//                       actions: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                             child: Container(
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: _isCheckingPinStatus
//                                   ? const Padding(
//                                       padding: EdgeInsets.all(12),
//                                       child: SizedBox(
//                                         width: 24,
//                                         height: 24,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       ),
//                                     )
//                                   : IconButton(
//                                       icon: AnimatedSwitcher(
//                                         duration: const Duration(milliseconds: 300),
//                                         child: Icon(
//                                           _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
//                                           key: ValueKey(_isPinned),
//                                           color: _isPinned ? Theme.of(context).primaryColor : Colors.white,
//                                         ),
//                                       ),
//                                       onPressed: _togglePin,
//                                     ),
//                             ),
//                           ),
//                         ),
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                             child: Container(
//                               margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.share_rounded, color: Colors.white),
//                                 onPressed: () => _shareEventWithImage(event),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     SliverToBoxAdapter(
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFF8FAFC),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Event Title & Privacy Status
//                               Container(
//                                 padding: const EdgeInsets.all(24),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 20,
//                                       offset: const Offset(0, 8),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       event.title,
//                                       style: const TextStyle(
//                                         fontSize: 26,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF1F2937),
//                                         height: 1.3,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 16),
                                    
//                                     Row(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 12,
//                                             vertical: 6,
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: event.isPrivate 
//                                                 ? const Color(0xFFFEF3C7)
//                                                 : const Color(0xFFDCFDF7),
//                                             borderRadius: BorderRadius.circular(12),
//                                           ),
//                                           child: Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(
//                                                 event.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
//                                                 size: 16,
//                                                 color: event.isPrivate 
//                                                     ? const Color(0xFFA16207)
//                                                     : const Color(0xFF047857),
//                                               ),
//                                               const SizedBox(width: 6),
//                                               Text(
//                                                 event.isPrivate ? 'PRIVATE' : 'PUBLIC',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 12,
//                                                   color: event.isPrivate 
//                                                       ? const Color(0xFFA16207)
//                                                       : const Color(0xFF047857),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         if (event.creatorName != null && event.creatorName!.isNotEmpty) ...[
//                                           const SizedBox(width: 12),
//                                           Expanded(
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   padding: const EdgeInsets.all(2),
//                                                   decoration: BoxDecoration(
//                                                     gradient: const LinearGradient(
//                                                       colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                                                     ),
//                                                     borderRadius: BorderRadius.circular(8),
//                                                   ),
//                                                   child: const Icon(
//                                                     Icons.person_rounded,
//                                                     size: 16,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 8),
//                                                 Expanded(
//                                                   child: Text(
//                                                     'by ${event.displayCreatorName}',
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.w500,
//                                                       color: Colors.grey[600],
//                                                     ),
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               const SizedBox(height: 20),

//                               // Event Details Card
//                               Container(
//                                 padding: const EdgeInsets.all(24),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.05),
//                                       blurRadius: 20,
//                                       offset: const Offset(0, 8),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'Event Details',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF1F2937),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 20),
                                    
//                                     _buildDetailRow(
//                                       Icons.calendar_today_rounded,
//                                       'Date',
//                                       DateFormat('EEEE, MMMM d, yyyy').format(event.date),
//                                       const Color(0xFF3B82F6),
//                                     ),
//                                     const SizedBox(height: 16),

//                                     _buildDetailRow(
//                                       Icons.access_time_rounded,
//                                       'Time',
//                                       event.time.isNotEmpty ? event.time : 'Not specified',
//                                       const Color(0xFF10B981),
//                                     ),
//                                     const SizedBox(height: 16),

//                                     if (event.location != null) ...[
//                                       _buildDetailRow(
//                                         Icons.location_on_rounded,
//                                         'Location',
//                                         event.location!,
//                                         const Color(0xFFE53E3E),
//                                       ),
//                                       const SizedBox(height: 16),
//                                     ],

//                                     const Divider(height: 32),

//                                     const Text(
//                                       'Description',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF1F2937),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     Text(
//                                       event.description,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         height: 1.6,
//                                         color: Colors.grey[700],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//               return _buildShimmerLoading();
//             },
//           ),
          
//           // Comment Section Overlay
//           if (_showCommentSection)
//             Positioned.fill(
//               child: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 300),
//                 opacity: _showCommentSection ? 1.0 : 0.0,
//                 child: Container(
//                   color: Colors.black.withOpacity(0.5),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _showCommentSection = false;
//                       });
//                     },
//                     child: Container(
//                       color: Colors.transparent,
//                       child: SafeArea(
//                         child: Column(
//                           children: [
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: () {}, // Prevent tap from closing when tapping inside comment section
//                               child: CommentSection(eventToken: widget.eventToken),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return const Color(0xFFE91E63);
//       case 'anniversary':
//       case 'wedding':
//         return const Color(0xFFF44336);
//       case 'meeting':
//       case 'meetup':
//         return const Color(0xFF2196F3);
//       case 'party':
//         return const Color(0xFF9C27B0);
//       case 'holiday':
//         return const Color(0xFF4CAF50);
//       case 'reminder':
//         return const Color(0xFFFF9800);
//       case 'conference':
//         return const Color(0xFF607D8B);
//       case 'workshop':
//         return const Color(0xFF795548);
//       default:
//         return const Color(0xFF6366F1);
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return Icons.cake_rounded;
//       case 'anniversary':
//       case 'wedding':
//         return Icons.favorite_rounded;
//       case 'meeting':
//       case 'meetup':
//         return Icons.people_rounded;
//       case 'party':
//         return Icons.celebration_rounded;
//       case 'holiday':
//         return Icons.beach_access_rounded;
//       case 'reminder':
//         return Icons.notifications_rounded;
//       case 'conference':
//         return Icons.business_rounded;
//       case 'workshop':
//         return Icons.school_rounded;
//       default:
//         return Icons.event_rounded;
//     }
//   }

//   Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             color: iconColor,
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



















// //claude ai
// // ignore_for_file: use_build_context_synchronously

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_invitation_screen.dart';
// import 'package:moments/widgets/comment_section.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// class EventDetailScreen extends StatefulWidget {
//   final String eventToken;

//   const EventDetailScreen({
//     super.key,
//     required this.eventToken,
//   });

//   @override
//   State<EventDetailScreen> createState() => _EventDetailScreenState();
// }

// class _EventDetailScreenState extends State<EventDetailScreen> with TickerProviderStateMixin {
//   late Future<EventModel> _eventFuture;
//   bool _isPinned = false;
//   bool _isLoading = true;
//   bool _isCheckingPinStatus = false;
//   late AnimationController _fabController;
//   late AnimationController _imageController;

//   @override
//   void initState() {
//     super.initState();
//     _eventFuture = _loadEventDetails();
//     _checkPinnedStatus();
//     _fabController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _imageController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fabController.forward();
//     _imageController.forward();
//   }

//   @override
//   void dispose() {
//     _fabController.dispose();
//     _imageController.dispose();
//     super.dispose();
//   }

//   Future<EventModel> _loadEventDetails() async {
//     try {
//       final event = await NetworkService.getEventDetail(widget.eventToken);
//       setState(() {
//         _isLoading = false;
//       });
//       return event;
//     } catch (e) {
//       setState(() => _isLoading = false);
//       throw Exception('Failed to load event details: $e');
//     }
//   }

//   Future<void> _checkPinnedStatus() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final isPinned = await NetworkService.checkPinnedStatus(
//         authProvider.user!.userToken,
//         widget.eventToken,
//       );
//       setState(() {
//         _isPinned = isPinned;
//         _isCheckingPinStatus = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to check pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _togglePin() async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     setState(() {
//       _isCheckingPinStatus = true;
//     });

//     try {
//       final success = await NetworkService.togglePinEvent(
//         widget.eventToken,
//         authProvider.user!.userToken,
//       );

//       if (success) {
//         setState(() {
//           _isPinned = !_isPinned;
//         });
        
//         // Show success feedback
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 Icon(
//                   _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(_isPinned ? 'Event pinned!' : 'Event unpinned!'),
//               ],
//             ),
//             backgroundColor: const Color(0xFF10B981),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to update pin status: $e'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       setState(() {
//         _isCheckingPinStatus = false;
//       });
//     }
//   }

//   Future<void> _shareEventWithImage(EventModel event) async {
//     try {
//       final String shareText = '''
// ✨ ${event.title}

// 📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
// 🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
// 📍 Location: ${event.location ?? 'Not specified'}

// ${event.description}

// 🔗 Check it out here: ${event.shareLink ?? 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps'}

// Shared via Moments App ✨
// ''';

//       if (event.imageUrl == null) {
//         await Share.share(shareText);
//         return;
//       }

//       final uri = Uri.parse(NetworkService.getImageUrl(event.imageUrl!, type: 'event'));
//       final file = await DefaultCacheManager().getSingleFile(uri.toString());

//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: shareText,
//         subject: 'Event: ${event.title}',
//       );
//     } catch (e) {
//       debugPrint('Error sharing event: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to share event. Please try again.'),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildShimmerLoading() {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header shimmer
//             Container(
//               height: 350,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.grey[300]!,
//                     Colors.grey[100]!,
//                     Colors.grey[300]!,
//                   ],
//                   stops: const [0.0, 0.5, 1.0],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Content shimmer
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 28,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     height: 20,
//                     width: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ...List.generate(3, (index) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: Container(
//                       height: 16,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       extendBodyBehindAppBar: true,
//       floatingActionButton: FutureBuilder<EventModel>(
//         future: _eventFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.isPrivate) {
//             return ScaleTransition(
//               scale: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: FloatingActionButton.extended(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) => 
//                           EventInvitationScreen(
//                             eventToken: widget.eventToken,
//                             eventName: snapshot.data!.title,
//                             organizerName: snapshot.data!.displayCreatorName,
//                             shareLink: snapshot.data!.shareLink ?? 
//                               'https://momentsapp.page.link/event?token=${widget.eventToken}',
//                           ),
//                         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                           return SlideTransition(
//                             position: Tween<Offset>(
//                               begin: const Offset(1.0, 0.0),
//                               end: Offset.zero,
//                             ).animate(CurvedAnimation(
//                               parent: animation,
//                               curve: Curves.easeInOutCubic,
//                             )),
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   label: const Row(
//                     children: [
//                       Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
//                       SizedBox(width: 8),
//                       Text(
//                         'Invite',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       body: FutureBuilder<EventModel>(
//         future: _eventFuture,
//         builder: (context, snapshot) {
//           if (_isLoading) {
//             return _buildShimmerLoading();
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Container(
//                 margin: const EdgeInsets.all(20),
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFEE2E2),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Icon(
//                         Icons.error_outline_rounded,
//                         size: 48,
//                         color: Color(0xFFE53E3E),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Oops! Something went wrong',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Failed to load event details',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _isLoading = true;
//                             _eventFuture = _loadEventDetails();
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                         ),
//                         child: const Text(
//                           'Try Again',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           if (snapshot.hasData) {
//             final event = snapshot.data!;
            
//             return CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 SliverAppBar(
//                   expandedHeight: 350,
//                   pinned: true,
//                   stretch: true,
//                   backgroundColor: Colors.white,
//                   surfaceTintColor: Colors.transparent,
//                   elevation: 0,
//                   flexibleSpace: FlexibleSpaceBar(
//                     stretchModes: const [
//                       StretchMode.zoomBackground,
//                       StretchMode.blurBackground,
//                     ],
//                     background: FadeTransition(
//                       opacity: _imageController,
//                       child: Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               image: event.imageUrl != null
//                                   ? DecorationImage(
//                                       image: NetworkImage(
//                                         NetworkService.getImageUrl(event.imageUrl!, type: 'event'),
//                                       ),
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                               gradient: event.imageUrl == null
//                                   ? const LinearGradient(
//                                       colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     )
//                                   : null,
//                             ),
//                             child: event.imageUrl == null
//                                 ? Center(
//                                     child: 
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(12),
//                                     child: BackdropFilter(
//                                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                                       child: Container(
//                                         color: Colors.white.withOpacity(0.2),
//                                         padding: const EdgeInsets.all(8),
//                                         child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//                                       ),
//                                     ),
//                                   )
//                                   )
//                                 : null,
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.black.withOpacity(0.3),
//                                   Colors.transparent,
//                                   Colors.black.withOpacity(0.8),
//                                 ],
//                                 stops: const [0.0, 0.5, 1.0],
//                               ),
//                             ),
//                           ),
// Positioned(
//   top: 60,
//   left: 20,
//   child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//     decoration: BoxDecoration(
//       color: _getCategoryColor(event.category), // ✅ Use category color
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: _getCategoryColor(event.category).withOpacity(0.3), // ✅ Match home page shadow
//           blurRadius: 6,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           _getCategoryIcon(event.category), // ✅ Optional: match icon from home
//           color: Colors.white,
//           size: 16,
//         ),
//         const SizedBox(width: 6),
//         Text(
//           event.category,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     ),
//   ),
// )

//                         ],
//                       ),
//                     ),
//                   ),
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Container(
//                         margin: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: IconButton(
//                           icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ),
//                     ),
//                   ),
//                   actions: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           margin: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: _isCheckingPinStatus
//                               ? const Padding(
//                                   padding: EdgeInsets.all(12),
//                                   child: SizedBox(
//                                     width: 24,
//                                     height: 24,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                     ),
//                                   ),
//                                 )
//                               : IconButton(
//                                   icon: AnimatedSwitcher(
//                                     duration: const Duration(milliseconds: 300),
//                                     child: Icon(
//                                       _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
//                                       key: ValueKey(_isPinned),
//                                       color: _isPinned ? Theme.of(context).primaryColor : Colors.white,
//                                     ),
//                                   ),
//                                   onPressed: _togglePin,
//                                 ),
//                         ),
//                       ),
//                     ),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: IconButton(
//                             icon: const Icon(Icons.share_rounded, color: Colors.white),
//                             onPressed: () => _shareEventWithImage(event),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],

//                 ),
                
//                 SliverToBoxAdapter(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFF8FAFC),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(0),
//                         topRight: Radius.circular(0),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Event Title & Privacy Status
//                           Container(
//                             padding: const EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   event.title,
//                                   style: const TextStyle(
//                                     fontSize: 26,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1F2937),
//                                     height: 1.3,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
                                
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 6,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: event.isPrivate 
//                                             ? const Color(0xFFFEF3C7)
//                                             : const Color(0xFFDCFDF7),
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Icon(
//                                             event.isPrivate ? Icons.lock_rounded : Icons.public_rounded,
//                                             size: 16,
//                                             color: event.isPrivate 
//                                                 ? const Color(0xFFA16207)
//                                                 : const Color(0xFF047857),
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             event.isPrivate ? 'PRIVATE' : 'PUBLIC',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 12,
//                                               color: event.isPrivate 
//                                                   ? const Color(0xFFA16207)
//                                                   : const Color(0xFF047857),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     if (event.creatorName != null && event.creatorName!.isNotEmpty) ...[
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               padding: const EdgeInsets.all(2),
//                                               decoration: BoxDecoration(
//                                                 gradient: const LinearGradient(
//                                                   colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                                                 ),
//                                                 borderRadius: BorderRadius.circular(8),
//                                               ),
//                                               child: const Icon(
//                                                 Icons.person_rounded,
//                                                 size: 16,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Expanded(
//                                               child: Text(
//                                                 'by ${event.displayCreatorName}',
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.grey[600],
//                                                 ),
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 20),

//                           // Event Details Card
//                           Container(
//                             padding: const EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 20,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Event Details',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1F2937),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
                                
//                                 _buildDetailRow(
//                                   Icons.calendar_today_rounded,
//                                   'Date',
//                                   DateFormat('EEEE, MMMM d, yyyy').format(event.date),
//                                   const Color(0xFF3B82F6),
//                                 ),
//                                 const SizedBox(height: 16),

//                                 _buildDetailRow(
//                                   Icons.access_time_rounded,
//                                   'Time',
//                                   event.time.isNotEmpty ? event.time : 'Not specified',
//                                   const Color(0xFF10B981),
//                                 ),
//                                 const SizedBox(height: 16),

//                                 if (event.location != null) ...[
//                                   _buildDetailRow(
//                                     Icons.location_on_rounded,
//                                     'Location',
//                                     event.location!,
//                                     const Color(0xFFE53E3E),
//                                   ),
//                                   const SizedBox(height: 16),
//                                 ],

//                                 const Divider(height: 32),

//                                 const Text(
//                                   'Description',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF1F2937),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   event.description,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     height: 1.6,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   sliver: SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 20,
//                                 offset: const Offset(0, 8),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       gradient: const LinearGradient(
//                                         colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                                       ),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Icon(
//                                       Icons.chat_bubble_rounded,
//                                       color: Colors.white,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Text(
//                                     'Comments',
//                                     style: TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF1F2937),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // const SizedBox(height: 20),
//                               CommentSection(eventToken: widget.eventToken),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // const SliverToBoxAdapter(
//                 //   child: SizedBox(height: 100),
//                 // ),
//               ],
//             );
//           }
//           return _buildShimmerLoading();
//         },
//       ),
//     );
//   }


//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return const Color(0xFFE91E63);
//       case 'anniversary':
//       case 'wedding':
//         return const Color(0xFFF44336);
//       case 'meeting':
//       case 'meetup':
//         return const Color(0xFF2196F3);
//       case 'party':
//         return const Color(0xFF9C27B0);
//       case 'holiday':
//         return const Color(0xFF4CAF50);
//       case 'reminder':
//         return const Color(0xFFFF9800);
//       case 'conference':
//         return const Color(0xFF607D8B);
//       case 'workshop':
//         return const Color(0xFF795548);
//       default:
//         return const Color(0xFF6366F1);
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return Icons.cake_rounded;
//       case 'anniversary':
//       case 'wedding':
//         return Icons.favorite_rounded;
//       case 'meeting':
//       case 'meetup':
//         return Icons.people_rounded;
//       case 'party':
//         return Icons.celebration_rounded;
//       case 'holiday':
//         return Icons.beach_access_rounded;
//       case 'reminder':
//         return Icons.notifications_rounded;
//       case 'conference':
//         return Icons.business_rounded;
//       case 'workshop':
//         return Icons.school_rounded;
//       default:
//         return Icons.event_rounded;
//     }
//   }


//   Widget _buildDetailRow(IconData icon, String label, String value, Color iconColor) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: iconColor.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             color: iconColor,
//             size: 20,
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }