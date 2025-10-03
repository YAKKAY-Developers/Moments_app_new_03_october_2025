import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isCompleted;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  const EventCard({
    super.key,
    required this.event,
    this.isCompleted = false,
    this.onDelete,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(event.fullImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(event.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (event.location != null && event.location!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                event.location!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if (event.isPinned)
                  const Icon(Icons.push_pin, size: 16, color: Colors.amber),
              ],
            ),
            if (event.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (event.category.isNotEmpty)
                  Chip(
                    label: Text(event.category),
                    backgroundColor: Colors.blue[50],
                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[800],
                        ),
                  ),
                if (isCompleted)
                  Chip(
                    label: const Text('Completed'),
                    backgroundColor: Colors.green[50],
                    labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green[800],
                        ),
                  ),
              ],
            ),
            if (!isCompleted && (onDelete != null || onComplete != null))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onComplete != null)
                    TextButton(
                      onPressed: onComplete,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      child: const Text('Complete'),
                    ),
                  if (onDelete != null)
                    TextButton(
                      onPressed: onDelete,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}