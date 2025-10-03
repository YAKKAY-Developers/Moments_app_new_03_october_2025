import 'package:flutter/material.dart';
import 'package:moments/models/event_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/screens/events/event_detail_screen.dart';
import 'package:moments/screens/events/my_events_screen.dart';
import 'package:moments/widgets/my_event_card.dart';

class CompletedEventsPage extends StatefulWidget {
  const CompletedEventsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CompletedEventsPageState createState() => _CompletedEventsPageState();
}

class _CompletedEventsPageState extends State<CompletedEventsPage> {
  late Future<List<EventModel>> _eventsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _eventsFuture = NetworkService.getCompletedEvents();
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = NetworkService.getCompletedEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Events'),
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
                hintText: 'Search completed events...',
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
                    child: Text('No completed events found'),
                  );
                }

                final events = snapshot.data!
                    .where((event) =>
                        event.title.toLowerCase().contains(_searchQuery) ||
                        event.description.toLowerCase().contains(_searchQuery) == true)
                    .toList();

                if (events.isEmpty) {
                  return const Center(
                    child: Text('No matching completed events found'),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(eventToken: event.eventToken),
                            ),
                          );
                        },
                        child: EventCard(
                          event: event,
                          isCompleted: true,
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
}