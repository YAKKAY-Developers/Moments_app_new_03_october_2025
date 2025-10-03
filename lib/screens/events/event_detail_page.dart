// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/screens/events/edit_event_screen.dart';


// class EventDetailPage extends StatefulWidget {
//   final EventModel event;

//   const EventDetailPage({super.key, required this.event});

//   @override
//   // ignore: library_private_types_in_public_api
//   _EventDetailPageState createState() => _EventDetailPageState();
// }

// class _EventDetailPageState extends State<EventDetailPage> {
//   late EventModel _currentEvent;

//   @override
//   void initState() {
//     super.initState();
//     _currentEvent = widget.event;
//   }

//   Future<void> _refreshEvent() async {
//     try {
//       final events = await NetworkService.getMyEvents();
//       final updatedEvent = events.firstWhere(
//         (e) => e.eventToken == _currentEvent.eventToken,
//         orElse: () => _currentEvent,
//       );
//       setState(() {
//         _currentEvent = updatedEvent;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to refresh event: $e')),
//       );
//     }
//   }

//   Future<void> _navigateToEdit() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditEventPage(event: _currentEvent),
//       ),
//     );

//     if (result == true) {
//       await _refreshEvent();
//       if (mounted) {
//         Navigator.pop(context, true);
//       }
//     }
//   }

//   Future<void> _markEventCompleted() async {
//     try {
//       final completedEvent = await NetworkService.markEventCompleted(_currentEvent.eventToken);
//       setState(() {
//         _currentEvent = completedEvent;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('"${_currentEvent.title}" marked as completed')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to mark event as completed: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_currentEvent.title),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: _navigateToEdit,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_currentEvent.imageUrl != null && _currentEvent.imageUrl!.isNotEmpty)
//               Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: DecorationImage(
//                     image: NetworkImage(_currentEvent.fullImageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             Text(
//               _currentEvent.title,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 16),
//                 const SizedBox(width: 8),
//                 Text(
//                   DateFormat('MMMM dd, yyyy').format(_currentEvent.date),
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.access_time, size: 16),
//                 const SizedBox(width: 8),
//                 Text(
//                   _currentEvent.time,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             if (_currentEvent.location != null && _currentEvent.location!.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on, size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     _currentEvent.location!,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             ],
//             if (_currentEvent.category.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.category, size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     _currentEvent.category,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             ],
//             if (_currentEvent.visibilityName != null && _currentEvent.visibilityName!.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(Icons.visibility, size: 16),
//                   const SizedBox(width: 8),
//                   Text(
//                     _currentEvent.visibilityName!,
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             ],
//             const SizedBox(height: 16),
//             if (_currentEvent.description.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Description',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(_currentEvent.description),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             if (_currentEvent.shareLink != null && _currentEvent.shareLink!.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Share Link',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   SelectableText(_currentEvent.shareLink!),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             const SizedBox(height: 16),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _markEventCompleted,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 ),
//                 child: const Text('Mark as Completed'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }