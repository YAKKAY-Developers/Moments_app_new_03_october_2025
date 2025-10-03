// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/screens/events/event_detail_screen.dart';
import 'package:moments/widgets/my_event_card.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  late Future<List<EventModel>> _eventsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _eventsFuture = NetworkService.getMyEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = NetworkService.getMyEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshEvents,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: _eventsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No events found'),
                  );
                }

                final events = snapshot.data!
                    .where((event) =>
                        event.title.toLowerCase().contains(_searchQuery) ||
                        event.description.toLowerCase().contains(_searchQuery) == true)
                    .toList();

                if (events.isEmpty) {
                  return const Center(
                    child: Text('No matching events found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    _refreshEvents();
                  },
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(eventToken: event.eventToken),
                            ),
                          );
                          if (result == true) {
                            _refreshEvents();
                          }
                        },
                        child: EventCard(
                          event: event,
                          onDelete: () => _confirmDeleteEvent(event),
                          onComplete: () => _markEventCompleted(event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteEvent(EventModel event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await NetworkService.deleteEvent(event.eventToken);
        _refreshEvents();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${event.title}" deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: $e')),
        );
      }
    }
  }

  Future<void> _markEventCompleted(EventModel event) async {
    try {
      await NetworkService.markEventCompleted(event.eventToken);
      _refreshEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${event.title}" marked as completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark event as completed: $e')),
      );
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}