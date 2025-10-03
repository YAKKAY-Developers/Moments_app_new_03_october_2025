// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventModel {
//   final String id;
//   final String eventToken;
//   final String title;
//   final String description;
//   final String category;
//   final DateTime date;
//   final String time;
//   final String? location;
//   final String? imageUrl;
//   bool isPinned;
//   final DateTime createdAt;
//   final String? creatorName;
//   final int commentCount;
//   final String? visibilityName; 
//   final String? shareLink; 
//   final CommentModel? latestComment;
//   final bool isInvited;
//   final bool isPrivate;

//   String get fullImageUrl {
//     return NetworkService.getImageUrl(imageUrl, type: 'event');
//   }
  
//   EventModel({
//     required this.id,
//     required this.eventToken,
//     required this.title,
//     required this.description,
//     required this.category,
//     required this.date,
//     required this.time,
//     this.location,
//     this.imageUrl,
//     this.isPinned = false,
//     required this.createdAt,
//     this.creatorName,
//     this.commentCount = 0,
//     this.visibilityName, 
//     this.shareLink, 
//     this.latestComment,
//     this.isInvited = false,
//     this.isPrivate = false,
//   });

// factory EventModel.fromJson(Map<String, dynamic> json) {
//   return EventModel(
//     id: (json['event_id'] ?? '').toString(), 
//     eventToken: json['event_token'] ?? '',
//     title: json['event_name'] ?? '',
//     description: json['description'] ?? '',
//     category: json['category_name'] ?? 'Other', //get all event
//     date: DateTime.parse(json['event_date'] ?? DateTime.now().toIso8601String()),
//     time: json['time'] ?? '',
//     location: json['location'],
//     imageUrl: json['event_image'],
//     isPinned: json['is_pinned'] ?? false,
//     createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//     creatorName: json['user_name'], 
//     commentCount: json['comment_count'] ?? 0,
//     visibilityName: json['event_visibility_name'] ?? '',
//     shareLink: json['share_link'], 
//       latestComment: json['latest_comment'] != null 
//           ? CommentModel.fromJson(json['latest_comment']) 
//           : null,
//       isInvited: json['is_invited'] ?? false,
//       isPrivate: (json['event_visibility_code'] ?? '') == 'EVS002',   
//   );
// }


//   EventModel copyWith({
//     String? id,
//     String? eventToken,
//     String? title,
//     String? description,
//     String? category,
//     DateTime? date,
//     String? time,
//     String? location,
//     String? imageUrl,
//     bool? isPinned,
//     DateTime? createdAt,
//     String? creatorName,
//     int? commentCount,
//     String? visibilityName,
//     String? shareLink,
//     CommentModel? latestComment,
//     bool? isInvited,
//     bool? isPrivate,
//   }) {
    
//     return EventModel(
//       id: id ?? this.id,
//       eventToken: eventToken ?? this.eventToken,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       date: date ?? this.date,
//       time: time ?? this.time,
//       location: location ?? this.location,
//       imageUrl: imageUrl ?? this.imageUrl,
//       isPinned: isPinned ?? this.isPinned,
//       createdAt: createdAt ?? this.createdAt,
//       creatorName: creatorName ?? this.creatorName,
//       commentCount: commentCount ?? this.commentCount,
//       visibilityName: visibilityName ?? this.visibilityName,
//       shareLink: shareLink ?? this.shareLink, 
//       latestComment: latestComment ?? this.latestComment,
//       isInvited: isInvited ?? this.isInvited,
//       isPrivate: isPrivate ?? this.isPrivate,
//     );
//   }
// }













// //working code

// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventModel {
//   final String id;
//   final String eventToken;
//   final String title;
//   final String description;
//   final String category; // Can be category name or "Other"
//   final int? categoryId; // Added to handle category_id from API
//   final DateTime date;
//   final String time;
//   final String? location;
//   final String? imageUrl;
//   bool isPinned;
//   final DateTime createdAt;
//   final String? creatorName;
//   final int commentCount;
//   final String? visibilityName;
//   final int? visibilityId; // Added to handle event_visibility_id
//   final String? shareLink;
//   final CommentModel? latestComment;
//   final bool isInvited;
//   final bool isPrivate;
//   final DateTime? lastActivity;

//   String get fullImageUrl {
//     return NetworkService.getImageUrl(imageUrl, type: 'event');
//   }

//   EventModel({
//     required this.id,
//     required this.eventToken,
//     required this.title,
//     required this.description,
//     required this.category,
//     this.categoryId,
//     required this.date,
//     required this.time,
//     this.location,
//     this.imageUrl,
//     this.isPinned = false,
//     required this.createdAt,
//     this.creatorName,
//     this.commentCount = 0,
//     this.visibilityName,
//     this.visibilityId,
//     this.shareLink,
//     this.latestComment,
//     this.isInvited = false,
//     this.isPrivate = false,
//     this.lastActivity,
//   });
  
//   String get displayCreatorName =>
//       (creatorName != null && creatorName!.trim().isNotEmpty)
//           ? creatorName!
//           : "Unknown Creator";

//   factory EventModel.fromJson(Map<String, dynamic> json) {
//     return EventModel(
//       id: (json['event_id'] ?? '').toString(),
//       eventToken: json['event_token'] ?? '',
//       title: json['event_name'] ?? '',
//       description: json['description'] ?? '',
//       category: json['category_name'] ?? 'Other',
//       categoryId: json['category_id'],
//       date: DateTime.tryParse(json['event_date'] ?? '') ?? DateTime.now(),
//       time: json['time'] ?? '',
//       location: json['location'],
//       imageUrl: json['event_image'],
//       isPinned: json['is_pinned'] ?? false,
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       creatorName: json['organizer_name'], // ✅ Correct field
//       commentCount: json['comment_count'] ?? 0,
//       visibilityName: json['event_visibility_name'],
//       visibilityId: json['event_visibility_id'],
//       shareLink: json['share_link'],
//       latestComment: json['latest_comment'] != null
//           ? CommentModel.fromJson(json['latest_comment'])
//           : null,
//       lastActivity: json['lastActivity'] != null
//         ? DateTime.tryParse(json['lastActivity'])
//         : null,
//       isInvited: json['is_invited'] ?? false,
//       isPrivate: (json['event_visibility_code'] ?? '') == 'EVS002',
//     );
//   }

//   EventModel copyWith({
//     String? id,
//     String? eventToken,
//     String? title,
//     String? description,
//     String? category,
//     int? categoryId,
//     DateTime? date,
//     String? time,
//     String? location,
//     String? imageUrl,
//     bool? isPinned,
//     DateTime? createdAt,
//     String? creatorName,
//     int? commentCount,
//     String? visibilityName,
//     int? visibilityId,
//     String? shareLink,
//     CommentModel? latestComment,
//     bool? isInvited,
//     bool? isPrivate,
//   }) {
//     return EventModel(
//       id: id ?? this.id,
//       eventToken: eventToken ?? this.eventToken,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       categoryId: categoryId ?? this.categoryId,
//       date: date ?? this.date,
//       time: time ?? this.time,
//       location: location ?? this.location,
//       imageUrl: imageUrl ?? this.imageUrl,
//       isPinned: isPinned ?? this.isPinned,
//       createdAt: createdAt ?? this.createdAt,
//       creatorName: creatorName ?? this.creatorName,
//       commentCount: commentCount ?? this.commentCount,
//       visibilityName: visibilityName ?? this.visibilityName,
//       visibilityId: visibilityId ?? this.visibilityId,
//       shareLink: shareLink ?? this.shareLink,
//       latestComment: latestComment ?? this.latestComment,
//       isInvited: isInvited ?? this.isInvited,
//       isPrivate: isPrivate ?? this.isPrivate,
//     );
//   }
// }



import 'package:moments/models/comment_model.dart';
import 'package:moments/network_service/network_service.dart';

class EventModel {
  final String id;
  final String eventToken;
  final String title;
  final String description;
  final String category;
  final int? categoryId;
  final DateTime date;
  final String time;
  final String? location;
  final String? imageUrl;
  bool isPinned;
  final DateTime createdAt;
  final String? creatorName;
  final int commentCount;
  final String? visibilityName;
  final int? visibilityId;
  final String? shareLink;
  final CommentModel? latestComment;
  final bool isInvited;
  final bool isPrivate;
  final DateTime? lastActivity;

  String get fullImageUrl {
    return NetworkService.getImageUrl(imageUrl, type: 'event');
  }

  EventModel({
    required this.id,
    required this.eventToken,
    required this.title,
    required this.description,
    required this.category,
    this.categoryId,
    required this.date,
    required this.time,
    this.location,
    this.imageUrl,
    this.isPinned = false,
    required this.createdAt,
    this.creatorName,
    this.commentCount = 0,
    this.visibilityName,
    this.visibilityId,
    this.shareLink,
    this.latestComment,
    this.isInvited = false,
    this.isPrivate = false,
    this.lastActivity,
  });
  
  String get displayCreatorName =>
      (creatorName != null && creatorName!.trim().isNotEmpty)
          ? creatorName!
          : "Unknown Creator";

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: (json['event_id'] ?? '').toString(),
      eventToken: json['event_token'] ?? '',
      title: json['event_name'] ?? '',
      description: json['description'] ?? '',
      category: json['category_name'] ?? 'Other',
      categoryId: json['category_id'],
      date: DateTime.tryParse(json['event_date'] ?? '') ?? DateTime.now(),
      time: json['time'] ?? '',
      location: json['location'],
      imageUrl: json['event_image'],
      isPinned: json['is_pinned'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      creatorName: json['organizer_name'],
      commentCount: json['comment_count'] ?? 0,
      visibilityName: json['event_visibility_name'],
      visibilityId: json['event_visibility_id'],
      shareLink: json['share_link'],
      latestComment: json['latest_comment'] != null
          ? CommentModel.fromJson(json['latest_comment'])
          : null,
      lastActivity: _parseDateTime(json['lastActivity']),
      isInvited: json['is_invited'] ?? false,
      isPrivate: (json['event_visibility_code'] ?? '') == 'EVS002',
    );
  }

  // Helper method to parse DateTime from various formats
  static DateTime? _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return null;
    
    if (dateValue is DateTime) {
      return dateValue;
    } else if (dateValue is String) {
      return DateTime.tryParse(dateValue);
    } else if (dateValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(dateValue);
    }
    
    return null;
  }

  EventModel copyWith({
    String? id,
    String? eventToken,
    String? title,
    String? description,
    String? category,
    int? categoryId,
    DateTime? date,
    String? time,
    String? location,
    String? imageUrl,
    bool? isPinned,
    DateTime? createdAt,
    String? creatorName,
    int? commentCount,
    String? visibilityName,
    int? visibilityId,
    String? shareLink,
    CommentModel? latestComment,
    bool? isInvited,
    bool? isPrivate,
    DateTime? lastActivity,
  }) {
    return EventModel(
      id: id ?? this.id,
      eventToken: eventToken ?? this.eventToken,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      creatorName: creatorName ?? this.creatorName,
      commentCount: commentCount ?? this.commentCount,
      visibilityName: visibilityName ?? this.visibilityName,
      visibilityId: visibilityId ?? this.visibilityId,
      shareLink: shareLink ?? this.shareLink,
      latestComment: latestComment ?? this.latestComment,
      isInvited: isInvited ?? this.isInvited,
      isPrivate: isPrivate ?? this.isPrivate,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}