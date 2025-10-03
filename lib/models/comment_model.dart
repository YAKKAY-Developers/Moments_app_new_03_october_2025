// import 'package:moments/network_service/network_service.dart';

// class CommentModel {
//   final String commentToken;
//   String content;
//   final bool isAdminReply;
//   int likeCount;
//   int replyCount;
//   final String status;
//   final bool isDeleted;
//   final String? deletedAt;
//   final String? ipAddress;
//   final bool activeInd;
//   final String createdAt;
//   String updatedAt;
//   final String? userName;
//   final String? userPhoto;
//   final String? userToken; // Optional, for user-specific actions
//   List<CommentModel> replies;
//   bool isLiked; // Local tracking
//   List<MediaAttachment> attachments; // New field for media attachments

//   CommentModel({
//     required this.commentToken,
//     required this.content,
//     required this.isAdminReply,
//     required this.likeCount,
//     required this.replyCount,
//     required this.status,
//     required this.isDeleted,
//     this.deletedAt,
//     this.ipAddress,
//     required this.activeInd,
//     required this.createdAt,
//     required this.updatedAt,
//     this.userName,
//     this.userPhoto,
//     this.userToken, // Optional, for user-specific actions
//     this.replies = const [],
//     this.isLiked = false,
//     this.attachments = const [], // Initialize empty list

//   });

// factory CommentModel.fromJson(Map<String, dynamic> json) {
//   return CommentModel(
//     commentToken: json['comment_token'] ?? '',
//     content: json['content'] ?? '',
//     isAdminReply: json['isAdminReply'] ?? false,
//     likeCount: json['likeCount'] ?? 0,
//     replyCount: json['replyCount'] ?? 0,
//     status: json['status'] ?? 'active',
//     isDeleted: json['isDeleted'] ?? false,
//     deletedAt: json['deletedAt'],
//     ipAddress: json['ip_address'],
//     activeInd: json['activeInd'] ?? true,
//     createdAt: json['createdAt'] ?? '',
//     updatedAt: json['updatedAt'] ?? '',
//     userName: json['user_name'],
//     userPhoto: json['user_photo'],
//     userToken: json['user_token'],
//     isLiked: json['isLiked'] ?? false,
//     attachments: (json['attachments'] as List<dynamic>?)
//         ?.map((e) => MediaAttachment.fromJson(e))
//         .toList() ?? [],
//     replies: (json['replies'] as List<dynamic>?)
//         ?.map((e) => CommentModel.fromJson(e))
//         .toList() ?? [],
//   );
// }

//   CommentModel copyWith({
//     String? commentToken,
//     String? content,
//     bool? isAdminReply,
//     int? likeCount,
//     int? replyCount,
//     String? status,
//     bool? isDeleted,
//     String? deletedAt,
//     String? ipAddress,
//     bool? activeInd,
//     String? createdAt,
//     String? updatedAt,
//     String? userName,
//     String? userPhoto,
//     String? userToken, // Optional, for user-specific actions
//     List<CommentModel>? replies,
//     bool? isLiked,
//     List<MediaAttachment>? attachments, // New field for media attachments
//   }) {
//     return CommentModel(
//       commentToken: commentToken ?? this.commentToken,
//       content: content ?? this.content,
//       isAdminReply: isAdminReply ?? this.isAdminReply,
//       likeCount: likeCount ?? this.likeCount,
//       replyCount: replyCount ?? this.replyCount,
//       status: status ?? this.status,
//       isDeleted: isDeleted ?? this.isDeleted,
//       deletedAt: deletedAt ?? this.deletedAt,
//       ipAddress: ipAddress ?? this.ipAddress,
//       activeInd: activeInd ?? this.activeInd,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       userName: userName ?? this.userName,
//       userPhoto: userPhoto ?? this.userPhoto,
//       userToken: userToken ?? this.userToken, // Optional, for user-specific actions
//       replies: replies ?? this.replies,
//       isLiked: isLiked ?? this.isLiked,
//       attachments: attachments ?? this.attachments, // New field for media attachments
//     );
//   }
// } 


// class MediaAttachment {
//   final String attachmentToken;
//   final String url;
//   final String type;
//   final String? thumbnailUrl;
//   final DateTime createdAt;

//   MediaAttachment({
//     required this.attachmentToken,
//     required this.url,
//     required this.type,
//     this.thumbnailUrl,
//     required this.createdAt,
//   });

//   factory MediaAttachment.fromJson(Map<String, dynamic> json) {
//     return MediaAttachment(
//       attachmentToken: json['attachment_token'],
//       url: NetworkService.getImageUrl(json['url'], type: 'comment'),
//       type: json['type'],
//       thumbnailUrl: json['thumbnail_url'] != null 
//           ? NetworkService.getImageUrl(json['thumbnail_url'], type: 'comment')
//           : null,
//       createdAt: DateTime.parse(json['createdAt']),
//     );
//   }

//   bool get isImage => type == 'image';
//   bool get isVideo => type == 'video';
// }



import 'package:moments/network_service/network_service.dart';

class CommentModel {
  final String commentToken;
  String content;
  final bool isAdminReply;
  int likeCount;
  int replyCount;
  final String status;
  final bool isDeleted;
  final String? deletedAt;
  final String? ipAddress;
  final bool activeInd;
  final DateTime createdAt;  // Changed to DateTime
  DateTime updatedAt;        // Changed to DateTime
  final String? userName;
  final String? userPhoto;
  final String? userToken;
  List<CommentModel> replies;
  bool isLiked;
  List<MediaAttachment> attachments;

  CommentModel({
    required this.commentToken,
    required this.content,
    required this.isAdminReply,
    required this.likeCount,
    required this.replyCount,
    required this.status,
    required this.isDeleted,
    this.deletedAt,
    this.ipAddress,
    required this.activeInd,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userPhoto,
    this.userToken,
    this.replies = const [],
    this.isLiked = false,
    this.attachments = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentToken: json['comment_token'] ?? '',
      content: json['content'] ?? '',
      isAdminReply: json['isAdminReply'] ?? false,
      likeCount: json['likeCount'] ?? 0,
      replyCount: json['replyCount'] ?? 0,
      status: json['status'] ?? 'active',
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'],
      ipAddress: json['ip_address'],
      activeInd: json['activeInd'] ?? true,
      createdAt: _parseDateTime(json['createdAt']),    // Parse to DateTime
      updatedAt: _parseDateTime(json['updatedAt']),    // Parse to DateTime
      userName: json['user']?['name'] ?? json['user_name'],
      userPhoto: json['user']?['photo'] ?? json['user_photo'],
      userToken: json['user']?['user_token'] ?? json['user_token'],
      isLiked: json['isLiked'] ?? false,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => MediaAttachment.fromJson(e))
          .toList() ?? [],
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e))
          .toList() ?? [],
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_token': commentToken,
      'content': content,
      'isAdminReply': isAdminReply,
      'likeCount': likeCount,
      'replyCount': replyCount,
      'status': status,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'ip_address': ipAddress,
      'activeInd': activeInd,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'user_name': userName,
      'user_photo': userPhoto,
      'user_token': userToken,
      'isLiked': isLiked,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  CommentModel copyWith({
    String? commentToken,
    String? content,
    bool? isAdminReply,
    int? likeCount,
    int? replyCount,
    String? status,
    bool? isDeleted,
    String? deletedAt,
    String? ipAddress,
    bool? activeInd,
    DateTime? createdAt,     // Changed to DateTime
    DateTime? updatedAt,     // Changed to DateTime
    String? userName,
    String? userPhoto,
    String? userToken,
    List<CommentModel>? replies,
    bool? isLiked,
    List<MediaAttachment>? attachments,
  }) {
    return CommentModel(
      commentToken: commentToken ?? this.commentToken,
      content: content ?? this.content,
      isAdminReply: isAdminReply ?? this.isAdminReply,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      ipAddress: ipAddress ?? this.ipAddress,
      activeInd: activeInd ?? this.activeInd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      userToken: userToken ?? this.userToken,
      replies: replies ?? this.replies,
      isLiked: isLiked ?? this.isLiked,
      attachments: attachments ?? this.attachments,
    );
  }
}

class MediaAttachment {
  final String attachmentToken;
  final String url;
  final String type;
  final String mimeType;
  final String? thumbnailUrl;
  final DateTime createdAt;

  MediaAttachment({
    required this.attachmentToken,
    required this.url,
    required this.type,
    required this.mimeType,
    this.thumbnailUrl,
    required this.createdAt,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) {
    return MediaAttachment(
      attachmentToken: json['attachment_token'] ?? '',
      url: NetworkService.getImageUrl(json['url'], type: 'comment'),
      type: json['type'] ?? 'image',
      mimeType: json['mime_type'] ?? 'image/jpeg',
      thumbnailUrl: json['thumbnail_url'] != null 
          ? NetworkService.getImageUrl(json['thumbnail_url'], type: 'comment')
          : null,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'attachment_token': attachmentToken,
      'url': url,
      'type': type,
      'mime_type': mimeType,
      'thumbnail_url': thumbnailUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isImage => type == 'image';
  bool get isVideo => type == 'video';
}