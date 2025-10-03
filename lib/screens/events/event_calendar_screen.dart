// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_detail_screen.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';

// class EventCalendarScreen extends StatefulWidget {
//   const EventCalendarScreen({super.key});

//   @override
//   State<EventCalendarScreen> createState() => _EventCalendarScreenState();
// }

// class _EventCalendarScreenState extends State<EventCalendarScreen> {
//   late Future<List<EventModel>> _eventsFuture;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<EventModel>> _eventsMap = {};

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _eventsFuture = _loadEvents();
//   }

//   Future<List<EventModel>> _loadEvents() async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final userToken = authProvider.user?.userToken;
      
//       if (userToken == null) return [];
      
//       final events = await NetworkService.getAllEvents();
      
//       // Group events by date
//       final tempMap = <DateTime, List<EventModel>>{};
//       for (var event in events) {
//         final date = DateTime(event.date.year, event.date.month, event.date.day);
//         if (tempMap.containsKey(date)) {
//           tempMap[date]!.add(event);
//         } else {
//           tempMap[date] = [event];
//         }
//       }
      
//       setState(() {
//         _eventsMap = tempMap;
//       });
      
//       return events;
//     } catch (e) {
//       throw Exception('Failed to load events: $e');
//     }
//   }

//   List<EventModel> _getEventsForDay(DateTime day) {
//     return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//       automaticallyImplyLeading: false, // ✅ removes the default back button
//         title: const Text('Calendar',
//                 style: TextStyle(
//           fontFamily: 'Poppins', // ✅ Use Poppins family
//           fontWeight: FontWeight.w500, // ✅ Medium weight
//           fontSize: 24,
//           color: Colors.white,
//         ),),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _eventsFuture = _loadEvents();
//               });
//             },
//           ),
//         ],
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: FutureBuilder<List<EventModel>>(
//         future: _eventsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Failed to load events',
//                     style: theme.textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     snapshot.error.toString(),
//                     textAlign: TextAlign.center,
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _eventsFuture = _loadEvents();
//                       });
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               TableCalendar<EventModel>(
//                 firstDay: DateTime(2000),
//                 lastDay: DateTime(2050),
//                 focusedDay: _focusedDay,
//                 calendarFormat: _calendarFormat,
//                 selectedDayPredicate: (day) {
//                   return isSameDay(_selectedDay, day);
//                 },
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 onFormatChanged: (format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 },
//                 eventLoader: _getEventsForDay,
//                 calendarStyle: CalendarStyle(
//                   todayDecoration: BoxDecoration(
//                     color: colorScheme.primary.withOpacity(0.3),
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: BoxDecoration(
//                     color: colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   markerDecoration: BoxDecoration(
//                     color: colorScheme.secondary,
//                     shape: BoxShape.circle,
//                   ),
//                   markerSize: 6,
//                   outsideDaysVisible: false,
//                 ),
//                 headerStyle: HeaderStyle(
//                   formatButtonVisible: true,
//                   titleCentered: true,
//                   formatButtonDecoration: BoxDecoration(
//                     border: Border.all(color: colorScheme.primary),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   formatButtonTextStyle: TextStyle(
//                     color: colorScheme.primary,
//                   ),
//                 ),
//                 calendarBuilders: CalendarBuilders(
//                   markerBuilder: (context, date, events) {
//                     if (events.isEmpty) return null;
                    
//                     return Positioned(
//                       right: 1,
//                       bottom: 1,
//                       child: Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: colorScheme.secondary,
//                         ),
//                         child: Text(
//                           events.length.toString(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   dowBuilder: (context, day) {
//                     final text = DateFormat.E().format(day);
//                     return Center(
//                       child: Text(
//                         text,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const Divider(height: 1),
//               Expanded(
//                 child: _buildEventsList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEventsList() {
//     if (_selectedDay == null) return const Center(child: Text('No day selected'));

//     final events = _getEventsForDay(_selectedDay!);
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     if (events.isEmpty) {
//       return Center(
//         child: Text(
//           'No events for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}',
//           style: theme.textTheme.bodyLarge,
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         final event = events[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EventDetailScreen(
//                     eventToken: event.eventToken,
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // Event icon based on category
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primary.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: _getEventIcon(event.category),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               event.title,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               event.category,
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: colorScheme.onSurface.withOpacity(0.6),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (event.isPinned)
//                         const Icon(Icons.push_pin, size: 16),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         size: 16,
//                         color: theme.textTheme.bodySmall?.color,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '${event.time} • ${DateFormat('MMM d, yyyy').format(event.date)}',
//                         style: theme.textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                   if (event.location != null) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           size: 16,
//                           color: theme.textTheme.bodySmall?.color,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           event.location!,
//                           style: theme.textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Icon _getEventIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return const Icon(Icons.cake);
//       case 'meeting':
//         return const Icon(Icons.people);
//       case 'holiday':
//         return const Icon(Icons.beach_access);
//       case 'anniversary':
//         return const Icon(Icons.favorite);
//       case 'reminder':
//         return const Icon(Icons.notifications);
//       default:
//         return const Icon(Icons.event);
//     }
//   }
// }

























































// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_detail_screen.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';

// class EventCalendarScreen extends StatefulWidget {
//   const EventCalendarScreen({super.key});

//   @override
//   State<EventCalendarScreen> createState() => _EventCalendarScreenState();
// }

// class _EventCalendarScreenState extends State<EventCalendarScreen> {
//   late Future<List<EventModel>> _eventsFuture;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<EventModel>> _eventsMap = {};

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _eventsFuture = _loadEvents();
//   }

//   Future<List<EventModel>> _loadEvents() async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final userToken = authProvider.user?.userToken;
      
//       if (userToken == null) return [];
      
//       final events = await NetworkService.getAllEvents();
      
//       // Group events by date
//       final tempMap = <DateTime, List<EventModel>>{};
//       for (var event in events) {
//         final date = DateTime(event.date.year, event.date.month, event.date.day);
//         if (tempMap.containsKey(date)) {
//           tempMap[date]!.add(event);
//         } else {
//           tempMap[date] = [event];
//         }
//       }
      
//       setState(() {
//         _eventsMap = tempMap;
//       });
      
//       return events;
//     } catch (e) {
//       throw Exception('Failed to load events: $e');
//     }
//   }

//   List<EventModel> _getEventsForDay(DateTime day) {
//     return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Calendar',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _eventsFuture = _loadEvents();
//               });
//             },
//           ),
//         ],
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: FutureBuilder<List<EventModel>>(
//         future: _eventsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Failed to load events',
//                     style: theme.textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     snapshot.error.toString(),
//                     textAlign: TextAlign.center,
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _eventsFuture = _loadEvents();
//                       });
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               TableCalendar<EventModel>(
//                 firstDay: DateTime.now().subtract(const Duration(days: 365)),
//                 lastDay: DateTime.now().add(const Duration(days: 365)),
//                 focusedDay: _focusedDay,
//                 calendarFormat: _calendarFormat,
//                 selectedDayPredicate: (day) {
//                   return isSameDay(_selectedDay, day);
//                 },
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 onFormatChanged: (format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 },
//                 eventLoader: _getEventsForDay,
//                 calendarStyle: CalendarStyle(
//                   todayDecoration: BoxDecoration(
//                     color: colorScheme.primary.withOpacity(0.3),
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: BoxDecoration(
//                     color: colorScheme.primary,
//                     shape: BoxShape.circle,
//                   ),
//                   markerDecoration: BoxDecoration(
//                     color: colorScheme.secondary,
//                     shape: BoxShape.circle,
//                   ),
//                   markerSize: 6,
//                   outsideDaysVisible: false,
//                 ),
//                 headerStyle: HeaderStyle(
//                   formatButtonVisible: true,
//                   titleCentered: true,
//                   formatButtonDecoration: BoxDecoration(
//                     border: Border.all(color: colorScheme.primary),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   formatButtonTextStyle: TextStyle(
//                     color: colorScheme.primary,
//                   ),
//                 ),
//                 calendarBuilders: CalendarBuilders(
//                   markerBuilder: (context, date, events) {
//                     if (events.isEmpty) return null;
                    
//                     return Positioned(
//                       right: 1,
//                       bottom: 1,
//                       child: Wrap(
//                         spacing: 2,
//                         children: events.map((event) {
//                           return Container(
//                             padding: const EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: _getEventColor(event.category),
//                             ),
//                             child: Icon(
//                               _getEventIcon(event.category).icon,
//                               size: 12,
//                               color: Colors.white,
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   },
//                   dowBuilder: (context, day) {
//                     final text = DateFormat.E().format(day);
//                     return Center(
//                       child: Text(
//                         text,
//                         style: theme.textTheme.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const Divider(height: 1),
//               Expanded(
//                 child: _buildEventsList(),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEventsList() {
//     if (_selectedDay == null) return const Center(child: Text('No day selected'));

//     final events = _getEventsForDay(_selectedDay!);
//     final theme = Theme.of(context);

//     if (events.isEmpty) {
//       return Center(
//         child: Text(
//           'No events for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}',
//           style: theme.textTheme.bodyLarge,
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         final event = events[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: InkWell(
//             borderRadius: BorderRadius.circular(12),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EventDetailScreen(
//                     eventToken: event.eventToken,
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       // Event image
//                       if (event.imageUrl != null)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             event.fullImageUrl,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 width: 60,
//                                 height: 60,
//                                 color: Colors.grey[200],
//                                 child: const Icon(Icons.error),
//                               );
//                             },
//                           ),
//                         ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               event.title,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             // const SizedBox(height: 4),
//                             // Text(
//                             //   'Organized by ${event.creatorName ?? 'Unknown'}',
//                             //   style: theme.textTheme.bodySmall?.copyWith(
//                             //     color: colorScheme.onSurface.withOpacity(0.6),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today,
//                         size: 16,
//                         color: theme.textTheme.bodySmall?.color,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         DateFormat('MMM d, yyyy').format(event.date),
//                         style: theme.textTheme.bodySmall,
//                       ),
//                       const SizedBox(width: 16),
//                       Icon(
//                         Icons.access_time,
//                         size: 16,
//                         color: theme.textTheme.bodySmall?.color,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         event.time,
//                         style: theme.textTheme.bodySmall,
//                       ),
//                     ],
//                   ),
//                   if (event.location != null && event.location!.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           size: 16,
//                           color: theme.textTheme.bodySmall?.color,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           event.location!,
//                           style: theme.textTheme.bodySmall,
//                         ),
//                       ],
//                     ),
//                   ],
//                   const SizedBox(height: 8),
//                   Text(
//                     event.description,
//                     style: theme.textTheme.bodyMedium,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Icon _getEventIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return const Icon(Icons.cake);
//       case 'meeting':
//         return const Icon(Icons.people);
//       case 'holiday':
//         return const Icon(Icons.beach_access);
//       case 'anniversary':
//         return const Icon(Icons.favorite);
//       case 'reminder':
//         return const Icon(Icons.notifications);
//       default:
//         return const Icon(Icons.event);
//     }
//   }

//   Color _getEventColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'birthday':
//         return Colors.pink;
//       case 'meeting':
//         return Colors.blue;
//       case 'holiday':
//         return Colors.green;
//       case 'anniversary':
//         return Colors.red;
//       case 'reminder':
//         return Colors.orange;
//       default:
//         return Colors.purple;
//     }
//   }
// }


















// //working

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:moments/models/event_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:moments/screens/events/event_detail_screen.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:marquee/marquee.dart';

// class EventCalendarScreen extends StatefulWidget {
//   const EventCalendarScreen({super.key});

//   @override
//   State<EventCalendarScreen> createState() => _EventCalendarScreenState();
// }

// class _EventCalendarScreenState extends State<EventCalendarScreen> {
//   late Future<List<EventModel>> _eventsFuture;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<EventModel>> _eventsMap = {};

//   List<EventModel> _currentMonthEvents = [];

//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _eventsFuture = _loadEvents();
//   }

//   Future<List<EventModel>> _loadEvents() async {
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final userToken = authProvider.user?.userToken;
//       if (userToken == null) return [];

//       final events = await NetworkService.getAllEvents();

//       final tempMap = <DateTime, List<EventModel>>{};
//       for (var event in events) {
//         final date = DateTime(event.date.year, event.date.month, event.date.day);
//         if (tempMap.containsKey(date)) {
//           tempMap[date]!.add(event);
//         } else {
//           tempMap[date] = [event];
//         }
//       }

//       setState(() {
//         _eventsMap = tempMap;
//         _updateCurrentMonthEvents();
//       });

//       return events;
//     } catch (e) {
//       throw Exception('Failed to load events: $e');
//     }
//   }

//   void _updateCurrentMonthEvents() {
//     final monthEvents = _eventsMap.entries
//         .where((entry) =>
//             entry.key.year == _focusedDay.year &&
//             entry.key.month == _focusedDay.month)
//         .expand((entry) => entry.value)
//         .toList();

//     setState(() {
//       _currentMonthEvents = monthEvents;
//     });
//   }

//   List<EventModel> _getEventsForDay(DateTime day) {
//     return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Calendar',
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.w500,
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _eventsFuture = _loadEvents();
//               });
//             },
//           ),
//         ],
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Column(
//         children: [
//           _buildMonthEventsMarquee(theme),
//           Expanded(
//             child: FutureBuilder<List<EventModel>>(
//               future: _eventsFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                         const SizedBox(height: 16),
//                         Text('Failed to load events', style: theme.textTheme.titleLarge),
//                         const SizedBox(height: 8),
//                         Text(snapshot.error.toString(),
//                             textAlign: TextAlign.center,
//                             style: theme.textTheme.bodyMedium),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _eventsFuture = _loadEvents();
//                             });
//                           },
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return Column(
//                   children: [
//                     TableCalendar<EventModel>(                      
//                     calendarBuilders: CalendarBuilders(
//                       markerBuilder: (context, date, events) {
//                         if (events.isEmpty) return const SizedBox.shrink();

//                         final icons = events.take(3).map((event) {
//                           return Container(
//                             width: 14,
//                             height: 14,
//                             decoration: BoxDecoration(
//                               color: _getEventColor(event.category),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               _getEventIcon(event.category),
//                               size: 8,
//                               color: Colors.white,
//                             ),
//                           );
//                         }).toList();

//                         return Padding(
//                           padding: const EdgeInsets.only(top: 28), // moves below date number
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: icons,
//                           ),
//                         );
//                       },
//                     ),


//                       firstDay: DateTime.now().subtract(const Duration(days: 365)),
//                       lastDay: DateTime.now().add(const Duration(days: 365)),
//                       focusedDay: _focusedDay,
//                       calendarFormat: _calendarFormat,
//                       selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                       onDaySelected: (selectedDay, focusedDay) {
//                         setState(() {
//                           _selectedDay = selectedDay;
//                           _focusedDay = focusedDay;
//                         });
//                       },
//                       onFormatChanged: (format) {
//                         setState(() {
//                           _calendarFormat = format;
//                         });
//                       },
//                       onPageChanged: (focusedDay) {
//                         _focusedDay = focusedDay;
//                         _updateCurrentMonthEvents();
//                       },
//                       eventLoader: _getEventsForDay,
//                       calendarStyle: CalendarStyle(
//                         todayDecoration: BoxDecoration(
//                           color: colorScheme.primary.withOpacity(0.3),
//                           shape: BoxShape.circle,
//                         ),
//                         selectedDecoration: BoxDecoration(
//                           color: colorScheme.primary,
//                           shape: BoxShape.circle,
//                         ),
//                         markerDecoration: BoxDecoration(
//                           color: colorScheme.secondary,
//                           shape: BoxShape.circle,
//                         ),
//                         markerSize: 6,
//                         outsideDaysVisible: false,
//                       ),
//                       headerStyle: HeaderStyle(
//                         formatButtonVisible: true,
//                         titleCentered: true,
//                         formatButtonDecoration: BoxDecoration(
//                           border: Border.all(color: colorScheme.primary),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         formatButtonTextStyle: TextStyle(
//                           color: colorScheme.primary,
//                         ),
//                       ),
//                     ),
//                     const Divider(height: 1),
//                     Expanded(child: _buildEventsList()),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMonthEventsMarquee(ThemeData theme) {
//     final monthName = DateFormat('MMMM yyyy').format(_focusedDay);

//     if (_currentMonthEvents.isEmpty) {
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         child: Center(
//           child: Text(
//             'No events in $monthName',
//             style: theme.textTheme.bodyMedium,
//           ),
//         ),
//       );
//     }

//     final text = _currentMonthEvents.map((e) => '• ${e.title}').join('    ');

//     return SizedBox(
//       height: 30,
//       child: Marquee(
//         text: text,
//         style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
//         blankSpace: 50,
//         velocity: 30,
//         pauseAfterRound: const Duration(seconds: 1),
//         startPadding: 10,
//       ),
//     );
//   }

//   Widget _buildEventsList() {
//     if (_selectedDay == null) {
//       return const Center(child: Text('No day selected'));
//     }

//     final events = _getEventsForDay(_selectedDay!);
//     final theme = Theme.of(context);

//     if (events.isEmpty) {
//       return Center(
//         child: Text(
//           'No events for ${DateFormat('MMMM d, yyyy').format(_selectedDay!)}',
//           style: theme.textTheme.bodyLarge,
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: events.length,
//       itemBuilder: (context, index) {
//         final event = events[index];
//         return _buildEventCard(event, theme);
//       },
//     );
//   }

//   Widget _buildEventCard(EventModel event, ThemeData theme) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => EventDetailScreen(eventToken: event.eventToken),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   if (event.imageUrl != null)
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         event.fullImageUrl,
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           width: 60,
//                           height: 60,
//                           color: Colors.grey[200],
//                           child: const Icon(Icons.error),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Text(
//                       event.title,
//                       style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   const Icon(Icons.calendar_today, size: 16),
//                   const SizedBox(width: 8),
//                   Text(DateFormat('MMM d, yyyy').format(event.date),
//                       style:  TextStyle(color: theme.colorScheme.onSurface)),
//                   const SizedBox(width: 16),
//                   const Icon(Icons.access_time, size: 16),
//                   const SizedBox(width: 8),
//                   Text(event.time, style: TextStyle(color: theme.colorScheme.onSurface)),
//                 ],
//               ),
//               if (event.location != null && event.location!.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 16),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(event.location!, style: TextStyle(color: theme.colorScheme.onSurface)),
//                     ),
//                   ],
//                 ),
//               ],
//               const SizedBox(height: 8),
//               Text(
//                 event.description,
//                 style: theme.textTheme.bodyMedium,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }



//   IconData _getEventIcon(String category) {
//   switch (category.toLowerCase()) {
//     case 'birthday':
//       return Icons.cake;
//     case 'anniversary':
//     case 'wedding':
//       return Icons.favorite;
//     case 'meeting':
//     case 'meetup':
//       return Icons.people;
//     case 'party':
//       return Icons.celebration;
//     case 'holiday':
//       return Icons.beach_access;
//     case 'reminder':
//       return Icons.notifications;
//     default:
//       return Icons.event;
//   }
// }

// Color _getEventColor(String category) {
//   switch (category.toLowerCase()) {
//     case 'birthday':
//       return Colors.pink;
//     case 'anniversary':
//     case 'wedding':
//       return Colors.redAccent;
//     case 'meeting':
//     case 'meetup':
//       return Colors.blueAccent;
//     case 'party':
//       return Colors.deepPurple;
//     case 'holiday':
//       return Colors.green;
//     case 'reminder':
//       return Colors.orange;
//     default:
//       return Colors.purple;
//   }
// }

// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:moments/screens/events/event_detail_screen.dart';
import 'package:moments/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:marquee/marquee.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen>
    with TickerProviderStateMixin {
  late Future<List<EventModel>> _eventsFuture;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<EventModel>> _eventsMap = {};
  List<EventModel> _currentMonthEvents = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsFuture = _loadEvents();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<EventModel>> _loadEvents() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final userToken = authProvider.user?.userToken;
      if (userToken == null) return [];

      final events = await NetworkService.getAllEvents();

      final tempMap = <DateTime, List<EventModel>>{};
      for (var event in events) {
        final date = DateTime(event.date.year, event.date.month, event.date.day);
        if (tempMap.containsKey(date)) {
          tempMap[date]!.add(event);
        } else {
          tempMap[date] = [event];
        }
      }

      setState(() {
        _eventsMap = tempMap;
        _updateCurrentMonthEvents();
      });

      return events;
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }

  void _updateCurrentMonthEvents() {
    final monthEvents = _eventsMap.entries
        .where((entry) =>
            entry.key.year == _focusedDay.year &&
            entry.key.month == _focusedDay.month)
        .expand((entry) => entry.value)
        .toList();

    setState(() {
      _currentMonthEvents = monthEvents;
    });
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildModernAppBar(),
      body: Column(
        children: [
          _buildMonthEventsMarquee(theme),
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: AppTheme.primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          "Loading your events...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  return _buildErrorView(theme);
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _buildModernCalendar(),
                      const SizedBox(height: 16),
                      Expanded(child: _buildEventsList()),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'Calendar',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.refresh_outlined, color: Colors.white, size: 20),
            ),
            onPressed: () {
              setState(() {
                _eventsFuture = _loadEvents();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthEventsMarquee(ThemeData theme) {
    final monthName = DateFormat('MMMM yyyy').format(_focusedDay);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: _currentMonthEvents.isEmpty
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month_outlined, 
                       color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'No events in $monthName',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.event_note_outlined, 
                       color: AppTheme.primaryColor, size: 20),
                ),
                Expanded(
                  child: Marquee(
                    text: _currentMonthEvents.map((e) => '• ${e.title}').join('    '),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                    ),
                    blankSpace: 50,
                    velocity: 30,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildModernCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar<EventModel>(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _updateCurrentMonthEvents();
        },
        eventLoader: _getEventsForDay,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          todayTextStyle: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          markerDecoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppTheme.primaryColor,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppTheme.primaryColor,
          ),
          titleTextStyle: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return const SizedBox.shrink();

            final icons = events.take(3).map((event) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: _getEventColor(event.category),
                  shape: BoxShape.circle,
                ),
              );
            }).toList();

            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: icons,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load events',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _eventsFuture = _loadEvents();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedDay == null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_view_day_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Select a date to view events',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final events = _getEventsForDay(_selectedDay!);

    if (events.isEmpty) {
return Center(
  child: SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events for',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('MMMM d, yyyy').format(_selectedDay!),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
);

    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildModernEventCard(event, index);
      },
    );
  }

  Widget _buildModernEventCard(EventModel event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(eventToken: event.eventToken),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Event Image or Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getEventColor(event.category),
                      _getEventColor(event.category).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: event.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          event.fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildEventIcon(event.category),
                        ),
                      )
                    : _buildEventIcon(event.category),
              ),
              const SizedBox(width: 16),
              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                   Row(
                      children: [
                        _buildInfoChip(Icons.access_time_outlined, event.time),
                        if (event.location != null && event.location!.isNotEmpty)
                          const SizedBox(width: 8),
                        if (event.location != null && event.location!.isNotEmpty)
                          Expanded(
                            child: _buildInfoChip(Icons.location_on_outlined, event.location!),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventIcon(String category) {
    return Center(
      child: Icon(
        _getEventIconData(category),
        color: Colors.white,
        size: 32,
      ),
    );
  }
Widget _buildInfoChip(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(   // ✅ allows wrapping/ellipsis inside chip
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

  // Widget _buildInfoChip(IconData icon, String text) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
      
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 12, color: Colors.grey[600]),
  //         const SizedBox(width: 4),
  //         Text(
  //           text,
  //           style: TextStyle(
  //             fontSize: 12,
  //             color: Colors.grey[600],
  //             fontWeight: FontWeight.w500,
  //           ),
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  IconData _getEventIconData(String category) {
    switch (category.toLowerCase()) {
      case 'birthday':
        return Icons.cake_outlined;
      case 'anniversary':
      case 'wedding':
        return Icons.favorite_outline;
      case 'meeting':
      case 'meetup':
        return Icons.people_outline;
      case 'party':
        return Icons.celebration_outlined;
      case 'holiday':
        return Icons.beach_access_outlined;
      case 'reminder':
        return Icons.notifications_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  Color _getEventColor(String category) {
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
      default:
        return const Color(0xFF673AB7);
    }
  }
}