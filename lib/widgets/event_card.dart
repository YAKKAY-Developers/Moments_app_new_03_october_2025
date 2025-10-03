
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import '../models/event_model.dart';
// import '../network_service/network_service.dart';

// class ModernEventCard extends StatelessWidget {
//   final EventModel event;
//   final VoidCallback onTap;
//   final VoidCallback onPinPressed;
//   final bool isPinned;
//   final bool isPinning; // New parameter for pin loading state
//   final bool highlightComment;

//   const ModernEventCard({
//     super.key,
//     required this.event,
//     required this.onTap,
//     required this.onPinPressed,
//     required this.isPinned,
//     this.isPinning = false,
//     this.highlightComment = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 15,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Enhanced Image Section
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       height: 200,
//                       width: double.infinity,
//                       child: event.imageUrl != null
//                           ? Image.network(
//                               event.fullImageUrl,
//                               fit: BoxFit.cover,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Container(
//                                   color: Colors.grey[100],
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       value: loadingProgress.expectedTotalBytes != null
//                                           ? loadingProgress.cumulativeBytesLoaded /
//                                               loadingProgress.expectedTotalBytes!
//                                           : null,
//                                       valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         theme.primaryColor.withOpacity(0.1),
//                                         theme.primaryColor.withOpacity(0.05),
//                                       ],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.event_rounded,
//                                       size: 48,
//                                       color: theme.primaryColor.withOpacity(0.6),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             )
//                           : Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     theme.primaryColor.withOpacity(0.1),
//                                     theme.primaryColor.withOpacity(0.05),
//                                   ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.event_rounded,
//                                   size: 48,
//                                   color: theme.primaryColor.withOpacity(0.6),
//                                 ),
//                               ),
//                             ),
//                     ),
                    
//                     // Gradient overlay
//                     Container(
//                       height: 200,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.7),
//                           ],
//                           stops: const [0.0, 0.5, 1.0],
//                         ),
//                       ),
//                     ),

//                     // Category chip
//                     Positioned(
//                       top: 12,
//                       left: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: _getCategoryColor(event.category),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: _getCategoryColor(event.category).withOpacity(0.3),
//                               blurRadius: 6,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               _getCategoryIcon(event.category),
//                               size: 14,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               event.category.toUpperCase(),
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.white,
//                                 letterSpacing: 0.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Action buttons with enhanced pin button
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Row(
//                         children: [
//                           _buildActionButton(
//                             icon: Icons.share_rounded,
//                             onPressed: () => _shareEventWithImage(context),
//                           ),
//                           const SizedBox(width: 8),
//                           _buildEnhancedPinButton(theme),
//                         ],
//                       ),
//                     ),

//                     // Private/Invited badge
//                     if (event.isPrivate)
//                       Positioned(
//                         bottom: 12,
//                         right: 12,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.lock_rounded,
//                                 size: 12,
//                                 color: event.isInvited ? Colors.green[300] : Colors.orange[300],
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 event.isInvited ? 'INVITED' : 'PRIVATE',
//                                 style: TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w700,
//                                   color: event.isInvited ? Colors.green[300] : Colors.orange[300],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                     // Event title and date at bottom
//                     Positioned(
//                       bottom: 16,
//                       left: 16,
//                       right: 80,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             event.title,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               shadows: [
//                                 Shadow(
//                                   color: Colors.black26,
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 6),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.9),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   Icons.calendar_today_rounded,
//                                   size: 12,
//                                   color: theme.primaryColor,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   DateFormat('MMM dd, yyyy').format(event.date),
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     color: theme.primaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Enhanced comment preview section with media thumbnails
//               if (event.latestComment != null)
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: highlightComment
//                         ? theme.primaryColor.withOpacity(0.08)
//                         : Colors.grey[50],
//                     borderRadius: BorderRadius.circular(12),
//                     border: highlightComment
//                         ? Border.all(color: theme.primaryColor.withOpacity(0.2), width: 1)
//                         : null,
//                   ),
//                   child: Row(
//                     children: [
//                       // User avatar
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: CircleAvatar(
//                           radius: 18,
//                           backgroundColor: theme.primaryColor.withOpacity(0.1),
//                           backgroundImage: event.latestComment!.userPhoto != null
//                               ? NetworkImage(
//                                   NetworkService.getImageUrl(
//                                     event.latestComment!.userPhoto,
//                                     type: 'profile',
//                                   ),
//                                 )
//                               : null,
//                           child: event.latestComment!.userPhoto == null
//                               ? Icon(
//                                   Icons.person_rounded,
//                                   size: 18,
//                                   color: theme.primaryColor,
//                                 )
//                               : null,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
                      
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   event.latestComment!.userName ?? 'Anonymous',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: theme.primaryColor.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(
//                                     _formatTime(DateTime.parse(event.latestComment!.createdAt)),
//                                     style: TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                       color: theme.primaryColor,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 6),
                            
//                             // Comment content with media thumbnails
//                             if (event.latestComment!.attachments.isNotEmpty)
//                               _buildMediaThumbnails(theme)
//                             else if (event.latestComment!.content.isNotEmpty)
//                               Text(
//                                 event.latestComment!.content,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                           ],
//                         ),
//                       ),
                      
//                       // Comment indicator
//                       if (highlightComment)
//                         Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: theme.primaryColor,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.chat_bubble_rounded,
//                             size: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// Build media thumbnails for comment attachments
//   Widget _buildMediaThumbnails(ThemeData theme) {
//     final attachments = event.latestComment!.attachments;
//     final hasText = event.latestComment!.content.isNotEmpty;
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Show text content if available
//         if (hasText) ...[
//           Text(
//             event.latestComment!.content,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w400,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 6),
//         ],
        
//         // Show media thumbnails
//         Row(
//           children: [
//             // Show up to 3 thumbnails
//             ...attachments.take(3).map((attachment) {
//               final isImage = attachment.isImage;
//               final mediaUrl = NetworkService.getImageUrl(attachment.url);
              
//               return Container(
//                 margin: const EdgeInsets.only(right: 6),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       border: Border.all(
//                         color: Colors.grey[300]!,
//                         width: 0.5,
//                       ),
//                     ),
//                     child: isImage
//                         ? Image.network(
//                             mediaUrl,
//                             fit: BoxFit.cover,
//                             width: 32,
//                             height: 32,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 color: Colors.grey[200],
//                                 child: Center(
//                                   child: SizedBox(
//                                     width: 12,
//                                     height: 12,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 1.5,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         theme.primaryColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: Colors.grey[200],
//                                 child: Icon(
//                                   Icons.image_rounded,
//                                   size: 16,
//                                   color: Colors.grey[500],
//                                 ),
//                               );
//                             },
//                           )
//                         : Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               // Video thumbnail (you might want to get actual video thumbnail)
//                               Container(
//                                 color: Colors.grey[800],
//                                 child: const Icon(
//                                   Icons.play_circle_fill_rounded,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                               // Video overlay icon
//                               Positioned(
//                                 bottom: 2,
//                                 right: 2,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(1),
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withOpacity(0.7),
//                                     borderRadius: BorderRadius.circular(2),
//                                   ),
//                                   child: const Icon(
//                                     Icons.videocam_rounded,
//                                     size: 8,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               );
//             }).toList(),
            
//             // Show count if there are more than 3 attachments
//             if (attachments.length > 3)
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: theme.primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: theme.primaryColor.withOpacity(0.3),
//                     width: 1,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '+${attachments.length - 3}',
//                     style: TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: theme.primaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   /// Enhanced pin button with loading state and better visual feedback
//   Widget _buildEnhancedPinButton(ThemeData theme) {
//     if (isPinning) {
//       // Show loading state
//       return Container(
//         decoration: BoxDecoration(
//           color: theme.primaryColor.withOpacity(0.9),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: theme.primaryColor.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Container(
//           width: 36,
//           height: 36,
//           padding: const EdgeInsets.all(8),
//           child: const CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         ),
//       );
//     }

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeInOut,
//       decoration: BoxDecoration(
//         color: isPinned 
//             ? theme.primaryColor.withOpacity(0.9)
//             : Colors.black.withOpacity(0.6),
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: isPinned 
//                 ? theme.primaryColor.withOpacity(0.3)
//                 : Colors.black.withOpacity(0.2),
//             blurRadius: isPinned ? 8 : 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(18),
//           onTap: onPinPressed,
//           child: SizedBox(
//             width: 36,
//             height: 36,
//             child: AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),
//               child: Icon(
//                 isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
//                 key: ValueKey(isPinned),
//                 size: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   Widget _buildActionButton({
//   required IconData icon,
//   required VoidCallback onPressed,
//   bool isActive = false,
//   Color? activeColor,
// }) {
//   return AnimatedContainer(
//     duration: const Duration(milliseconds: 200),
//     curve: Curves.easeInOut,
//     decoration: BoxDecoration(
//       color: isActive && activeColor != null
//           ? activeColor.withOpacity(0.9)
//           : Colors.black.withOpacity(0.6),
//       shape: BoxShape.circle,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           blurRadius: 6,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     width: 36,
//     height: 36,
//     child: Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: onPressed,
//         child: Center(
//           child: Icon(
//             icon,
//             size: 18,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     ),
//   );
// }


//   // Widget _buildActionButton({
//   //   required IconData icon,
//   //   required VoidCallback onPressed,
//   //   bool isActive = false,
//   //   Color? activeColor,
//   // }) {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       color: isActive && activeColor != null
//   //           ? activeColor.withOpacity(0.9)
//   //           : Colors.black.withOpacity(0.6),
//   //       shape: BoxShape.circle,
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Colors.black.withOpacity(0.2),
//   //           blurRadius: 6,
//   //           offset: const Offset(0, 2),
//   //         ),
//   //       ],
//   //     ),
//   //     child: IconButton(
//   //       icon: Icon(
//   //         icon,
//   //         size: 18,
//   //         color: Colors.white,
//   //       ),
//   //       onPressed: onPressed,
//   //       padding: EdgeInsets.zero,
//   //       constraints: const BoxConstraints(
//   //         minWidth: 36,
//   //         minHeight: 36,
//   //       ),
//   //     ),
//   //   );
//   // }

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

//   String _formatTime(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final dateToCheck = DateTime(date.year, date.month, date.day);
    
//     if (dateToCheck == today) {
//       return DateFormat('h:mm a').format(date);
//     } else if (dateToCheck == yesterday) {
//       return 'Yesterday';
//     } else if (now.difference(date).inDays < 7) {
//       return DateFormat('EEE').format(date); // Mon, Tue, etc.
//     } else {
//       return DateFormat('MMM d').format(date);
//     }
//   }

//   /// Share event with image
//   Future<void> _shareEventWithImage(BuildContext context) async {
//     try {
//       final uri = Uri.parse(event.fullImageUrl);
//       final response = await http.get(uri);
//       if (response.statusCode != 200) throw Exception('Failed to download image');
//       final bytes = response.bodyBytes;

//       final tempDir = await getTemporaryDirectory();
//       final file = File('${tempDir.path}/event_${event.id}.jpg');
//       await file.writeAsBytes(bytes);

//       final String shareText = '''
// 🎉 ${event.title}

// 📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
// 🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
// ${event.location != null ? '📍 Location: ${event.location}' : ''}

// ${event.description}

// 🔗 Join the event: ${event.shareLink ?? 'https://surl.lu/vcaryi'}

// Shared via Moments App ✨
// ''';

//       // ignore: deprecated_member_use
//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: shareText,
//         subject: 'Event: ${event.title}',
//       );
//     } catch (e) {
//       debugPrint('Error sharing event: $e');
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Failed to share event. Please try again.'),
//             backgroundColor: Colors.red[400],
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     }
//   }
// }









import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/event_model.dart';
import '../network_service/network_service.dart';

class ModernEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final VoidCallback onPinPressed;
  final bool isPinned;
  final bool isPinning;
  final bool highlightComment;

  const ModernEventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onPinPressed,
    required this.isPinned,
    this.isPinning = false,
    this.highlightComment = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: event.imageUrl != null
                          ? Image.network(
                              event.fullImageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[100],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.primaryColor.withOpacity(0.1),
                                        theme.primaryColor.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.event_rounded,
                                      size: 48,
                                      color: theme.primaryColor.withOpacity(0.6),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.primaryColor.withOpacity(0.1),
                                    theme.primaryColor.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.event_rounded,
                                  size: 48,
                                  color: theme.primaryColor.withOpacity(0.6),
                                ),
                              ),
                            ),
                    ),
                    
                    // Gradient overlay
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),

                    // Category chip
                    Positioned(
                      top: 12,
                      left: 12,
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
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action buttons with enhanced pin button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.share_rounded,
                            onPressed: () => _shareEventWithImage(context),
                          ),
                          const SizedBox(width: 8),
                          _buildEnhancedPinButton(theme),
                        ],
                      ),
                    ),

                    // Private/Invited badge
                    if (event.isPrivate)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                size: 12,
                                color: event.isInvited ? Colors.green[300] : Colors.orange[300],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                event.isInvited ? 'INVITED' : 'PRIVATE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: event.isInvited ? Colors.green[300] : Colors.orange[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Event title and date at bottom
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: theme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(event.date),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced comment preview section with WhatsApp-style media icons
              if (event.latestComment != null)
                Container(
                  // margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // color: highlightComment
                    //     ? theme.primaryColor.withOpacity(0.08)
                    //     : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: highlightComment
                        ? Border.all(color: theme.primaryColor.withOpacity(0.2), width: 1)
                        : null,
                  ),
                  child: Row(
                    children: [
                      // User avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: theme.primaryColor.withOpacity(0.1),
                          backgroundImage: event.latestComment!.userPhoto != null
                              ? NetworkImage(
                                  NetworkService.getImageUrl(
                                    event.latestComment!.userPhoto,
                                    type: 'profile',
                                  ),
                                )
                              : null,
                          child: event.latestComment!.userPhoto == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 18,
                                  color: theme.primaryColor,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  event.latestComment!.userName ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _formatTime(event.latestComment!.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (event.latestComment!.attachments.isNotEmpty) ...[
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    // child: Icon(
                                    //   event.latestComment!.attachments.first.isImage
                                    //       ? Icons.image_rounded
                                    //       : Icons.videocam_rounded,
                                    //   size: 12,
                                    //   color: theme.primaryColor,
                                    // ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: Text(
                                    event.latestComment!.content.isNotEmpty
                                        ? event.latestComment!.content
                                        : event.latestComment!.attachments.isNotEmpty
                                            ? event.latestComment!.attachments.first.isImage
                                                ? '📷 Photo'
                                                : '🎥 Video'
                                            : '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Comment indicator
                      if (highlightComment)
                        Container(
                          // padding: const EdgeInsets.all(6),
                          // decoration: BoxDecoration(
                          //   color: theme.primaryColor,
                          //   shape: BoxShape.circle,
                          // ),
                          // child: const Icon(
                          //   Icons.chat_bubble_rounded,
                          //   size: 12,
                          //   color: Colors.white,
                          // ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced pin button with loading state and better visual feedback
  Widget _buildEnhancedPinButton(ThemeData theme) {
    if (isPinning) {
      // Show loading state
      return Container(
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          width: 36,
          height: 36,
          padding: const EdgeInsets.all(8),
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isPinned 
            ? theme.primaryColor.withOpacity(0.9)
            : Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isPinned 
                ? theme.primaryColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
            blurRadius: isPinned ? 8 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPinPressed,
          child: SizedBox(
            width: 36,
            height: 36,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                key: ValueKey(isPinned),
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? activeColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isActive && activeColor != null
            ? activeColor.withOpacity(0.9)
            : Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: 36,
      height: 36,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
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

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);
    
    if (dateToCheck == today) {
      return DateFormat('h:mm a').format(date);
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEE').format(date); // Mon, Tue, etc.
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  /// Share event with image
  Future<void> _shareEventWithImage(BuildContext context) async {
    try {
      final uri = Uri.parse(event.fullImageUrl);
      final response = await http.get(uri);
      if (response.statusCode != 200) throw Exception('Failed to download image');
      final bytes = response.bodyBytes;

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/event_${event.id}.jpg');
      await file.writeAsBytes(bytes);

      final String shareText = '''
🎉 ${event.title}

📅 Date: ${DateFormat('MMM dd, yyyy').format(event.date)}
🕒 Time: ${event.time.isNotEmpty ? event.time : 'Not specified'}
${event.location != null ? '📍 Location: ${event.location}' : ''}

${event.description}

🔗 Join the event: ${event.shareLink ?? 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps'}

Shared via Moments App ✨
''';

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
        subject: 'Event: ${event.title}',
      );
    } catch (e) {
      debugPrint('Error sharing event: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share event. Please try again.'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}

