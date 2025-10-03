//   import 'dart:async';
//   import 'dart:convert';
//   import 'dart:io';
//   import 'package:flutter/foundation.dart';
//   import 'package:http/http.dart' as http;
//   import 'package:intl/intl.dart';
//   import 'package:moments/models/comment_model.dart';
//   import 'package:moments/models/contact_models.dart';
//   import 'package:moments/models/event_model.dart';
//   import 'package:shared_preferences/shared_preferences.dart';
//   import 'package:http_parser/http_parser.dart';
//   import 'package:path/path.dart' as path;
//   import 'package:mime/mime.dart';

//   class NetworkService {

//   // static const String baseUrl = 'http://10.0.2.2:4007/api';

//   static const String baseUrl = 'http://demo.yakkaytech.co.in:4007/api';

//   // Image base URLs
//   static const String profileImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/profile-image/';
//   static const String eventImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/event-image/';
//   static const String templateImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/template-image/';
//   static const String commentImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/comment-image/';
//   static const String categoryTemplateImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/template-thumbnail/';


//   static String getImageUrl(String? imagePath, {String type = 'profile'}) {
//   if (imagePath == null || imagePath.isEmpty) return '';

//   // If imagePath is already a full URL, return it as is
//   if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
//     return imagePath;
//   }

//   switch (type) {
//     case 'event':
//       return '$eventImageBaseUrl$imagePath';
//     case 'template':
//       return '$templateImageBaseUrl$imagePath';
//     case 'comment':
//       return '$commentImageBaseUrl$imagePath';
//     case 'category_template_image':
//       return '$categoryTemplateImageBaseUrl$imagePath';
//     case 'profile':
//     default:
//       return '$profileImageBaseUrl$imagePath';
//   }
// }

//   // Shared Preferences Keys
//   static const String _userTokenKey = 'user_token';

//   // Helper method for making POST requests
//   static Future<Map<String, dynamic>> _postRequest(
//   String endpoint,
//   Map<String, dynamic> body,
//   ) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl$endpoint'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode(body),
//   );

//   final responseData = jsonDecode(response.body);

//   if (response.statusCode == 200 || response.statusCode == 201) {
//     return responseData;
//   } else {
//     throw Exception(responseData['message'] ?? 'Failed to load data: ${response.statusCode}');
//   }
//   }

// static Future<void> updateFcmToken(String userToken, String fcmToken) async {
//   try {
//     final response = await http.post(
//       Uri.parse('$baseUrl/user/updateFcmToken'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'user_token': userToken,
//         'fcm_token': fcmToken,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update FCM token');
//     }
    
//     if (kDebugMode) {
//       print('FCM token updated successfully');
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error updating FCM token: $e');
//     }
//     // Don't throw error here - it's not critical for app functionality
//   }
// }

//   // Helper method to get headers with auth token
//   static Future<Map<String, String>> _getHeaders() async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('user_token') ?? '';
//   return {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $token',
//   };
//   }

//   // Token Management
//   static Future<void> saveUserToken(String token) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString(_userTokenKey, token);
//   }

//   static Future<String?> getUserToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getString(_userTokenKey);
//   }

//   static Future<void> removeUserToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove(_userTokenKey);
//   }

//   // Helper method for multipart requests (file uploads)
//   static Future<Map<String, dynamic>> _multipartRequest(
//   String endpoint,
//   Map<String, String> fields,
//   File? file,
//   ) async {
//   final uri = Uri.parse('$baseUrl$endpoint');
//   final request = http.MultipartRequest('POST', uri);

//   // Add fields
//   request.fields.addAll(fields);

//   // Add file if exists
//   if (file != null) {
//     final fileStream = http.ByteStream(file.openRead());
//     final length = await file.length();
//     final multipartFile = http.MultipartFile(
//       'photo',
//       fileStream,
//       length,
//       filename: path.basename(file.path),
//       contentType: MediaType('image', path.extension(file.path).replaceAll('.', '')),
//     );
//     request.files.add(multipartFile);
//   }

//   final response = await request.send();
//   final responseString = await response.stream.bytesToString();

//   if (response.statusCode == 200 || response.statusCode == 201) {
//     return jsonDecode(responseString);
//   } else {
//     throw Exception('Failed to upload: ${response.statusCode}');
//   }
//   }

//   // Sign Up API
//   static Future<Map<String, dynamic>> signUp({
//   required String name,
//   required String email,
//   required String phoneNumber,
//   required String password,
//   required String confirmPassword,
//   required String fcmToken,
//   }) async {
//   return await _postRequest('/user/signup', {
//     'name': name,
//     'email': email,
//     'phone_number': phoneNumber,
//     'password': password,
//     'confirm_password': confirmPassword,
//     'fcm_token': fcmToken,
//   });
//   }

//   // Sign In API
//   static Future<Map<String, dynamic>> signIn({
//   required String phoneNumber,
//   required String password,
//   }) async {
//   return await _postRequest('/user/signin', {
//     'phone_number': phoneNumber,
//     'password': password,
//   });
//   }

//   // Get User Details
//   static Future<Map<String, dynamic>> getUser(String userToken) async {
//   return await _postRequest('/user/getUser', {
//     'user_token': userToken,
//   });
//   }

//   // Update User Profile with optional image
//   static Future<Map<String, dynamic>> updateUser({
//   required String userToken,
//   String? name,
//   String? email,
//   String? phoneNumber,
//   String? address,
//   int? age,
//   File? imageFile,
//   }) async {
//   final fields = {
//     'user_token': userToken,
//     if (name != null) 'name': name,
//     if (email != null) 'email': email,
//     if (phoneNumber != null) 'phone_number': phoneNumber,
//     if (address != null) 'address': address,
//     if (age != null) 'age': age.toString(),
//   };

//   return await _multipartRequest('/user/updateUser', fields, imageFile);
//   }

//   // Sign Out
//   static Future<void> signOut(String userToken) async {
//   await _postRequest('/user/signOut', {
//     'user_token': userToken,
//   });
//   }

//   // Delete User
//   static Future<void> deleteUser(String userToken) async {
//   await _postRequest('/user/deleteUser', {
//     'user_token': userToken,
//   });
//   }

//   // NEW: Remove Profile Photo with better error handling
//   static Future<Map<String, dynamic>> removeProfilePhoto(String userToken) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/user/removeProfilePhoto'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'user_token': userToken}),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         return responseData;
//       } else {
//         throw Exception(responseData['message'] ?? 'Failed to remove profile photo');
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Get all categories
//   static Future<List<dynamic>> getCategories() async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/master/getCategory'),
//       headers: await _getHeaders(),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data'];
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   } catch (e) {
//     throw Exception('Error fetching categories: $e');
//   }
//   }

//   static Future<List<Map<String, dynamic>>> getTemplatesByCategory(String categoryCode) async {
//     try {
//     final response = await http.post(
//       Uri.parse('$baseUrl/event/templatesEvent'),
//       headers: await _getHeaders(),
//       body: json.encode({'category_code': categoryCode}),
//     );
    
//     if (kDebugMode) {
//       print('Response from getTemplatesByCategory: ${response.body}');
//     }

//     if (response.statusCode == 200) {
//       final List templates = json.decode(response.body)['data'];

//       return templates.map<Map<String, dynamic>>((template) {
//         final imagePath = template['image_path'] ?? '';
//         return {
//           'name': template['name'],
//           'file': template['file'],
//           'preview_url': template['preview_url'],
//           'image_url': '$categoryTemplateImageBaseUrl$imagePath', // Directly use the base URL
//           'image_path': imagePath, // Keep the original path if needed
//         };
//       }).toList();
//     } else {
//       throw Exception('Failed to load templates');
//     }
//   } catch (e) {
//     throw Exception('Error fetching templates: $e');
//   }
// }

//   // Get all event visibility options
//   static Future<List<dynamic>> getEventVisibilityOptions() async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/master/eventVisibility'),
//       headers: await _getHeaders(),
//     );
//     if (kDebugMode) {
//       print('Response from getEventVisibilityOptions: $response');
//     }
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data'];
//     } else {
//       throw Exception('Failed to load visibility options');
//     }
//   } catch (e) {
//     throw Exception('Error fetching visibility options: $e');
//   }
//   }

//   // In NetworkService
//   static Future<Map<String, dynamic>> createEvent({
//   required String eventName,
//   required String categoryCode,
//   required DateTime eventDateTime,
//   required String location,
//   required String description,
//   required String visibilityCode,
//   String? templateName,
//   File? imageFile,
//   }) async {
//   try {
  
//   final prefs = await SharedPreferences.getInstance();
//   final userToken = prefs.getString('user_token') ?? '';

//   final formattedDate = DateFormat('yyyy-MM-dd').format(eventDateTime);
//   final formattedTime = DateFormat('HH:mm').format(eventDateTime);

//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse('$baseUrl/event/createEvent'),
//   );

//   request.headers.addAll(await _getHeaders());

//   request.fields['event_name'] = eventName;
//   request.fields['event_date'] = formattedDate;
//   request.fields['time'] = formattedTime;
//   request.fields['location'] = location;
//   request.fields['description'] = description;
//   request.fields['user_token'] = userToken;
//   request.fields['category_code'] = categoryCode;
//   request.fields['event_visibility_code'] = visibilityCode;
//   request.fields['use_template'] = (templateName != null).toString();

//   if (kDebugMode) {
//     print('Creating event with fields: ${request.fields}');
//   }

//   if (templateName != null) {
//     request.fields['template_name'] = templateName;
//   }

//   if (imageFile != null) {
//     request.files.add(
//       await http.MultipartFile.fromPath(
//         'event_image',
//         imageFile.path,
//       ),
//     );
//   }

//   final response = await request.send();
//   final responseData = await response.stream.bytesToString();

//   if (kDebugMode) {
//     print('Create Event Response: $responseData');
//   }

//   if (response.statusCode == 201) {
//     return json.decode(responseData);
//   } else {
//     throw Exception('Failed to create event: ${json.decode(responseData)['message']}');
//   }
//   } catch (e) {
//   throw Exception('Error creating event: $e');
//   }
//   }

//   // Get event details by event token
//   static Future<EventModel> getEventDetail(String eventToken) async {
//     final userToken = await getUserToken();
//     final response = await http.post(
//       Uri.parse('$baseUrl/event/getEventDetail'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'event_token': eventToken,
//         if (userToken != null) 'user_token': userToken,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return EventModel.fromJson(data['data']);
//     } else {
//       throw Exception('Failed to load event details');
//     }
//   }


//   static const String _eventEndpoint = '/event';

//   // Get all events for the current user
//   static Future<List<EventModel>> getMyEvents() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(NetworkService._userTokenKey);
      
//       if (userToken == null) {
//         throw Exception('User not authenticated');
//       }

//       final response = await http.post(
//         Uri.parse('${NetworkService.baseUrl}$_eventEndpoint/getMyEvents'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'user_token': userToken}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['data'] != null) {
//           return (data['data'] as List)
//               .map((event) => EventModel.fromJson(event))
//               .toList();
//         }
//         return [];
//       } else {
//         throw Exception('Failed to load events: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching events: $e');
//     }
//   }

//   // Edit an existing event
//   static Future<EventModel> editEvent({
//     required String eventToken,
//     required String title,
//     required DateTime date,
//     required String time,
//     String? description,
//     String? categoryCode,
//     String? visibilityCode,
//     String? location,
//     File? imageFile,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(NetworkService._userTokenKey);
      
//       if (userToken == null) {
//         throw Exception('User not authenticated');
//       }

//       // Create multipart request
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${NetworkService.baseUrl}$_eventEndpoint/editEvent'),
//       );

//       // Add fields
//       request.fields['event_token'] = eventToken;
//       request.fields['user_token'] = userToken;
//       request.fields['event_name'] = title;
//       request.fields['event_date'] = DateFormat('yyyy-MM-dd').format(date);
//       request.fields['time'] = time;
//       if (description != null) request.fields['description'] = description;
//       if (categoryCode != null) request.fields['category_code'] = categoryCode;
//       if (visibilityCode != null) request.fields['event_visibility_code'] = visibilityCode;
//       if (location != null) request.fields['location'] = location;

//       // Add image file if provided
//       if (imageFile != null) {
//         final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
//         final fileExtension = path.extension(imageFile.path).replaceFirst('.', '');
        
//         request.files.add(await http.MultipartFile.fromPath(
//           'event_image',
//           imageFile.path,
//           contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
//           filename: 'event_image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
//         ));
//       }

//       // Send request
//       final response = await request.send();
//       final responseData = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final data = jsonDecode(responseData);
//         return EventModel.fromJson(data['data']);
//       } else {
//         throw Exception('Failed to edit event: ${jsonDecode(responseData)['message']}');
//       }
//     } catch (e) {
//       throw Exception('Error editing event: $e');
//     }
//   }

//   // Mark an event as completed
//   static Future<EventModel> markEventCompleted(String eventToken) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(NetworkService._userTokenKey);
      
//       if (userToken == null) {
//         throw Exception('User not authenticated');
//       }

//       final response = await http.post(
//         Uri.parse('${NetworkService.baseUrl}$_eventEndpoint/markEventCompleted'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'event_token': eventToken,
//           'user_token': userToken,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return EventModel.fromJson(data['data']);
//       } else {
//         throw Exception('Failed to mark event as completed: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error marking event as completed: $e');
//     }
//   }

//   // Delete an event
//   static Future<void> deleteEvent(String eventToken) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(NetworkService._userTokenKey);
      
//       if (userToken == null) {
//         throw Exception('User not authenticated');
//       }

//       final response = await http.post(
//         Uri.parse('${NetworkService.baseUrl}$_eventEndpoint/deleteEvent'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'event_token': eventToken,
//           'user_token': userToken,
//         }),
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to delete event: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error deleting event: $e');
//     }
//   }

//   // Get completed events
//   static Future<List<EventModel>> getCompletedEvents() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(NetworkService._userTokenKey);
      
//       if (userToken == null) {
//         throw Exception('User not authenticated');
//       }

//       final response = await http.post(
//         Uri.parse('${NetworkService.baseUrl}$_eventEndpoint/getCompletedEventsByDate'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'user_token': userToken}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['data'] != null) {
//           return (data['data'] as List)
//               .map((event) => EventModel.fromJson(event))
//               .toList();
//         }
//         return [];
//       } else {
//         throw Exception('Failed to load completed events: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching completed events: $e');
//     }
//   }


//   // Get all status options
//   static Future<List<dynamic>> getStatusOptions() async {
//   try {
//     final response = await http.get(
//       Uri.parse('$baseUrl/master/getStatus'),
//       headers: await _getHeaders(),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data'];
//     } else {
//       throw Exception('Failed to load status options');
//     }
//   } catch (e) {
//     throw Exception('Error fetching status options: $e');
//   }
//   }


// //claude pin event 


//   static void _handleError(String operation, dynamic error) {
//     if (kDebugMode) {
//       print('❌ $operation Error: $error');
//     }
//   }
  
//   static void _logSuccess(String operation, String details) {
//     if (kDebugMode) {
//       print('✅ $operation Success: $details');
//     }
//   }


//   static Future<bool> togglePinEvent(String eventToken, String userToken) async {
//     try {
//       if (kDebugMode) {
//         print('🔄 Toggling pin for event: $eventToken');
//       }

//       final response = await http.post(
//         Uri.parse('$baseUrl/pinned/toggle'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'user_token': userToken,
//           'event_token': eventToken,
//         }),
//       ).timeout(const Duration(seconds: 10));

//       if (kDebugMode) {
//         print('📡 togglePinEvent Response: ${response.statusCode} → ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         if (data['success'] == true) {
//           final isPinned = data['pinned'] ?? false;
//           _logSuccess('Toggle Pin', isPinned ? 'Event pinned' : 'Event unpinned');
//           return isPinned;
//         } else {
//           throw Exception(data['message'] ?? 'Failed to toggle pin status');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to toggle pin');
//       }
//     } catch (e) {
//       _handleError('togglePinEvent', e);
//       throw Exception('Failed to toggle pin status: $e');
//     }
//   }

//   /// Get all pinned events for a user
//   static Future<List<EventModel>> getPinnedEvents(String userToken) async {
//     try {
//       if (kDebugMode) {
//         print('🔄 Fetching pinned events for user');
//       }

//       final response = await http.post(
//         Uri.parse('$baseUrl/pinned/getpinuser'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({'user_token': userToken}),
//       ).timeout(const Duration(seconds: 15));

//       if (kDebugMode) {
//         print('📡 getPinnedEvents Response: ${response.statusCode} → ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         if (data['success'] == true) {
//           final eventsData = data['data'] as List? ?? [];
//           final events = eventsData
//               .map((eventJson) => EventModel.fromJson(eventJson))
//               .map((event) => event.copyWith(isPinned: true)) // Mark as pinned
//               .toList();
          
//           _logSuccess('Get Pinned Events', '${events.length} events loaded');
//           return events;
//         } else {
//           throw Exception(data['message'] ?? 'Failed to fetch pinned events');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to fetch pinned events');
//       }
//     } catch (e) {
//       _handleError('getPinnedEvents', e);
//       throw Exception('Failed to load pinned events: $e');
//     }
//   }

//   /// Check if a specific event is pinned by the user
//   static Future<bool> checkPinnedStatus(String userToken, String eventToken) async {
//     try {
//       if (kDebugMode) {
//         print('🔄 Checking pin status for event: $eventToken');
//       }

//       final response = await http.post(
//         Uri.parse('$baseUrl/pinned/status'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'user_token': userToken,
//           'event_token': eventToken,
//         }),
//       ).timeout(const Duration(seconds: 10));

//       if (kDebugMode) {
//         print('📡 checkPinnedStatus Response: ${response.statusCode} → ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         if (data['success'] == true) {
//           final isPinned = data['isPinned'] ?? false;
//           _logSuccess('Check Pin Status', isPinned ? 'Event is pinned' : 'Event is not pinned');
//           return isPinned;
//         } else {
//           throw Exception(data['message'] ?? 'Failed to check pin status');
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to check pin status');
//       }
//     } catch (e) {
//       _handleError('checkPinnedStatus', e);
//       throw Exception('Failed to check pin status: $e');
//     }
//   }

//   /// Batch check pin status for multiple events
//   static Future<Map<String, bool>> checkMultiplePinnedStatus(
//     String userToken, 
//     List<String> eventTokens,
//   ) async {
//     final Map<String, bool> results = {};
    
//     try {
//       // Process in batches to avoid overwhelming the server
//       const batchSize = 10;
//       for (int i = 0; i < eventTokens.length; i += batchSize) {
//         final batch = eventTokens.skip(i).take(batchSize).toList();
        
//         final futures = batch.map((token) async {
//           try {
//             final isPinned = await checkPinnedStatus(userToken, token);
//             return MapEntry(token, isPinned);
//           } catch (e) {
//             if (kDebugMode) {
//               print('⚠️ Failed to check pin status for $token: $e');
//             }
//             return MapEntry(token, false); // Default to not pinned on error
//           }
//         });
        
//         final batchResults = await Future.wait(futures);
//         for (final entry in batchResults) {
//           results[entry.key] = entry.value;
//         }
//       }
      
//       _logSuccess('Batch Pin Check', '${results.length} events checked');
//       return results;
//     } catch (e) {
//       _handleError('checkMultiplePinnedStatus', e);
//       return {}; // Return empty map on error
//     }
//   }


//   // Comment-related API methods
//   static Future<CommentModel> createComment({
//     required String content,
//     required String eventToken,
//     required String userToken,
//     List<File> mediaFiles = const [],
//     Function(double)? onProgress,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/comment/createComment');
//       var request = http.MultipartRequest('POST', uri);

//       // Add text fields
//       request.fields['content'] = content;
//       request.fields['event_token'] = eventToken;
//       request.fields['user_token'] = userToken;

//       // Add media files
//       for (int i = 0; i < mediaFiles.length; i++) {
//         final file = mediaFiles[i];
//         final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//         final fileStream = http.ByteStream(file.openRead().cast());
//         final fileLength = await file.length();

//         final multipartFile = http.MultipartFile(
//           'media',
//           fileStream,
//           fileLength,
//           filename: path.basename(file.path),
//           contentType: MediaType.parse(mimeType),
//         );

//         request.files.add(multipartFile);
//       }

//       final response = await request.send();
//       final responseString = await response.stream.bytesToString();
//       final responseData = jsonDecode(responseString);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (responseData['success'] == true && responseData['data'] != null) {
//           // The API returns the raw comment data, we need to fetch the full comment with user details
//           return CommentModel.fromJson(responseData['data']);
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         throw Exception(responseData['message'] ?? 'Failed to create comment');
//       }
//     } catch (e) {
//       throw Exception('Failed to create comment: $e');
//     }
//   }

//   static Future<Map<String, dynamic>> getEventComments({
//     required String eventToken,
//     int page = 1,
//     int limit = 10,
//     String? userToken,
//   }) async {
//     final body = {
//       'event_token': eventToken,
//       'page': page,
//       'limit': limit,
//       if (userToken != null) 'user_token': userToken,
//     };

//     final response = await _postRequest('/comment/geteventcomment', body);
    
//     // Parse comments from response
//     final List<dynamic> commentsJson = response['data']['comments'] ?? [];
//     final List<CommentModel> comments = commentsJson
//         .map((json) => CommentModel.fromJson(json))
//         .toList();

//     return {
//       'success': response['success'],
//       'total': response['data']['total'],
//       'page': response['data']['page'],
//       'totalPages': response['data']['totalPages'],
//       'comments': comments,
//     };
//   }

//   static Future<Map<String, dynamic>> toggleCommentLike({
//     required String commentToken,
//     required String userToken,
//   }) async {
//     final body = {
//       'comment_token': commentToken,
//       'user_token': userToken,
//     };

//     final response = await _postRequest('/comment/liketoggle', body);
//     return {
//       'success': response['success'],
//       'isLiked': response['data']['isLiked'],
//       'likeCount': response['data']['likeCount'],
//     };
//   }

//   static Future<CommentModel> createReply({
//     required String content,
//     required String userToken,
//     required String commentToken,
//     List<File> mediaFiles = const [],
//     Function(double)? onProgress,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/comment/createcommentreply');
//       var request = http.MultipartRequest('POST', uri);

//       // Add text fields
//       request.fields['content'] = content;
//       request.fields['user_token'] = userToken;
//       request.fields['comment_token'] = commentToken;

//       // Add media files
//       for (int i = 0; i < mediaFiles.length; i++) {
//         final file = mediaFiles[i];
//         final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//         final fileStream = http.ByteStream(file.openRead().cast());
//         final fileLength = await file.length();

//         final multipartFile = http.MultipartFile(
//           'media',
//           fileStream,
//           fileLength,
//           filename: path.basename(file.path),
//           contentType: MediaType.parse(mimeType),
//         );

//         request.files.add(multipartFile);
//       }

//       final response = await request.send();
//       final responseString = await response.stream.bytesToString();
//       final responseData = jsonDecode(responseString);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (responseData['success'] == true && responseData['data'] != null) {
//           return CommentModel.fromJson(responseData['data']);
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         throw Exception(responseData['message'] ?? 'Failed to create reply');
//       }
//     } catch (e) {
//       throw Exception('Failed to create reply: $e');
//     }
//   }

//   static Future<CommentModel> updateComment({
//     required String content,
//     required String commentToken,
//     required String userToken,
//     List<File> mediaFiles = const [],
//     Function(double)? onProgress,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl/comment/updateComment');
//       var request = http.MultipartRequest('POST', uri);

//       // Add text fields
//       request.fields['content'] = content;
//       request.fields['comment_token'] = commentToken;
//       request.fields['user_token'] = userToken;

//       // Add media files
//       for (int i = 0; i < mediaFiles.length; i++) {
//         final file = mediaFiles[i];
//         final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
//         final fileStream = http.ByteStream(file.openRead().cast());
//         final fileLength = await file.length();

//         final multipartFile = http.MultipartFile(
//           'media',
//           fileStream,
//           fileLength,
//           filename: path.basename(file.path),
//           contentType: MediaType.parse(mimeType),
//         );

//         request.files.add(multipartFile);
//       }

//       final response = await request.send();
//       final responseString = await response.stream.bytesToString();
//       final responseData = jsonDecode(responseString);

//       if (response.statusCode == 200) {
//         if (responseData['success'] == true && responseData['data'] != null) {
//           return CommentModel.fromJson(responseData['data']);
//         } else {
//           throw Exception('Invalid response format');
//         }
//       } else {
//         throw Exception(responseData['message'] ?? 'Failed to update comment');
//       }
//     } catch (e) {
//       throw Exception('Failed to update comment: $e');
//     }
//   }

//   static Future<bool> deleteComment({
//     required String commentToken,
//     required String userToken,
//   }) async {
//     final body = {
//       'comment_token': commentToken,
//       'user_token': userToken,
//     };

//     final response = await _postRequest('/comment/deleteComment', body);
//     return response['success'] == true;
//   }

//   static Future<List<Map<String, dynamic>>> getRecentlyCommentedEvents({
//     int limit = 5,
//   }) async {
//     final body = {
//       'limit': limit,
//     };

//     final response = await _postRequest('/comment/getrecentlycommentedevents', body);
//     return List<Map<String, dynamic>>.from(response['data'] ?? []);
//   }

//   // Event Invitation APIs
//   static Future<List<EventModel>> getInvitedEvents() async {
//     final userToken = await getUserToken();
//     if (userToken == null) throw Exception('User not authenticated');

//     final response = await http.post(
//       Uri.parse('$baseUrl/event/getInvitedEvents'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'user_token': userToken}),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return (data['data'] as List)
//           .map((event) => EventModel.fromJson(event))
//           .toList();
//     } else {
//       throw Exception('Failed to load invited events: ${response.statusCode}');
//     }
//   }

//     static Future<Map<String, dynamic>> inviteUsers({
//       required String eventToken,
//       required List<String> phoneNumbers,
//     }) async {
//       final userToken = await getUserToken();
//       if (userToken == null) throw Exception('User not authenticated');

//       final response = await http.post(
//         Uri.parse('$baseUrl/event/inviteUser'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'event_token': eventToken,
//           'user_token': userToken,
//           'phone_numbers': phoneNumbers,
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         return data;
//       } else {
//         throw Exception('Failed to send invitations: ${data['message'] ?? response.body}');
//       }
//     }

//   static Future<EventModel> acceptInvitation(String invitationToken) async {
//     final userToken = await getUserToken();
//     if (userToken == null) throw Exception('User not authenticated');

//     final response = await http.post(
//       Uri.parse('$baseUrl/event/acceptInvitation'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'invitation_token': invitationToken,
//         'user_token': userToken,
//       }),
//     );
// if (kDebugMode) {
//   print('acceptInvitation response: ${response.body}');
// }
// if (kDebugMode) {
//   print('response $response');
// }
//     if (kDebugMode) {
//       print('acceptInvitation: ${response.statusCode} → ${response.body}');
//     }
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return EventModel.fromJson(data['data']);
//     } else {
//       throw Exception('Failed to accept invitation: ${response.statusCode}');
//     }
//   }

// static Future<Map<String, dynamic>> checkRegisteredUsers(List<String> phoneNumbers) async {
//   try {
//     // Clean phone numbers before sending to API
//     final cleanedNumbers = phoneNumbers.map((phone) => phone.replaceAll(RegExp(r'[^0-9+]'), '')).toList();
    
//     final response = await http.post(
//       Uri.parse('$baseUrl/user/check-users'),
//       headers: await _getHeaders(),
//       body: json.encode({
//         'phoneNumbers': cleanedNumbers,
//       }),
//     );

//     final responseData = json.decode(response.body);
    
//     if (response.statusCode == 200) {
//       return responseData;
//     } else {
//       throw Exception(responseData['message'] ?? 'Failed to check registered users');
//     }
//   } catch (e) {
//     throw Exception('Error checking users: $e');
//   }
// }

// // Helper method to clean phone numbers for server
// static String _cleanPhoneNumberForServer(String phone) {
//   // Remove all non-digit characters except +
//   String cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  
//   // Ensure proper formatting for server
//   if (cleaned.startsWith('91') && cleaned.length == 12) {
//     return '+$cleaned';
//   } else if (cleaned.length == 10) {
//     return '+91$cleaned';
//   } else if (cleaned.startsWith('+')) {
//     return cleaned;
//   } else if (cleaned.length > 10) {
//     return '+$cleaned';
//   }
//   return cleaned;
// }

// static Future<Map<String, dynamic>> inviteUsersToPrivateEvent({
//   required String eventToken,
//   required List<ContactInvitation> contacts,
// }) async {
//   try {
//     final userToken = await getUserToken();
//     if (userToken == null) throw Exception('User not authenticated');

//     // Debug: Print original phone numbers
//     if (kDebugMode) {
//       print('Original phone numbers:');
//       for (var contact in contacts) {
//         print('${contact.name}: ${contact.phoneNumber}');
//       }
//     }

//     // Clean phone numbers before sending
//     final cleanedContacts = contacts.map((contact) {
//       final cleanedNumber = _cleanPhoneNumberForServer(contact.phoneNumber);
      
//       // Debug: Print cleaned numbers
//       if (kDebugMode) {
//         print('Cleaned: ${contact.phoneNumber} -> $cleanedNumber');
//       }
      
//       return {
//         'name': contact.name,
//         'phone_number': cleanedNumber,
//         'is_registered': contact.isRegistered,
//       };
//     }).toList();

//     final response = await http.post(
//       Uri.parse('$baseUrl/event/inviteUsersToPrivateEvent'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'event_token': eventToken,
//         'user_token': userToken,
//         'contacts': cleanedContacts,
//       }),
//     );

//     if (kDebugMode) {
//       print('inviteUsersToPrivateEvent response: ${response.body}');
//     }

//     final data = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       return data;
//     } else {
//       throw Exception('Failed to send invitations: ${data['message'] ?? response.body}');
//     }
//   } catch (e) {
//     throw Exception('Error sending invitations: $e');
//   }
// }

//   /// Get invitation details by token (for deep links)
//   static Future<Map<String, dynamic>> getInvitationDetails(String invitationToken) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/event/getInvitationDetails'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'invitation_token': invitationToken}),
//       );

//       if (kDebugMode) {
//         print('getInvitationDetails response: ${response.body}');
//       }

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         return data;
//       } else {
//         throw Exception('Failed to get invitation details: ${data['message']}');
//       }
//     } catch (e) {
//       throw Exception('Error getting invitation details: $e');
//     }
//   }


// static Future<Map<String, dynamic>> checkContactsForRegisteredUsers(List<ContactInfo> contacts) async {
//   try {
//     final phoneNumbers = contacts.map((c) => c.phoneNumber).toList();
    
//     final response = await http.post(
//       Uri.parse('$baseUrl/user/check-users'),
//       headers: await _getHeaders(),
//       body: json.encode({'phoneNumbers': phoneNumbers}),
//     );

//     final responseData = json.decode(response.body);
    
//     if (response.statusCode == 200) {
//       // Extract data from response
//       final registeredUsers = List<Map<String, dynamic>>.from(responseData['registered'] ?? []);
//       final unregisteredNumbers = List<String>.from(responseData['unregistered'] ?? []);
      
//       // Create a set of registered phone numbers for quick lookup
//       final registeredPhones = registeredUsers
//           .map((user) => user['phone_number'] as String)
//           .toSet();

//       // Map contacts to enriched contact information
//       final enrichedContacts = contacts.map((contact) {
//         final isRegistered = registeredPhones.contains(contact.phoneNumber);
//         final registeredUser = registeredUsers.firstWhere(
//           (user) => user['phone_number'] == contact.phoneNumber,
//           orElse: () => {},
//         );

//         return {
//           'name': contact.name,
//           'phoneNumber': contact.phoneNumber,
//           'isRegistered': isRegistered,
//           'userData': isRegistered ? registeredUser : null,
//         };
//       }).toList();

//       return {
//         'success': true,
//         'contacts': enrichedContacts,
//         'registered_count': registeredUsers.length,
//         'unregistered_count': unregisteredNumbers.length,
//         'total_checked': contacts.length,
//       };
//     } else {
//       throw Exception(responseData['message'] ?? 'Failed to check registered users');
//     }
//   } catch (e) {
//     throw Exception('Error checking users: $e');
//   }
// }

//   /// Enhanced getAllEvents method that handles private event visibility
//   static Future<List<EventModel>> getAllEvents() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString(_userTokenKey);

//       final response = await http.post(
//         Uri.parse('$baseUrl/event/getAllEvents'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'user_token': userToken, // Send user token for privacy filtering
//         }),
//       );
      
//       if (kDebugMode) {
//         print('getAllEvents: ${response.body}');
//       }

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseBody = jsonDecode(response.body);
//         final List<dynamic> eventList = responseBody['data'] ?? [];
        
//         // Debug print to check event data
//         if (kDebugMode) {
//           for (var event in eventList) {
//             print('''
// Event: ${event['event_name']}
// Is Private: ${event['is_private']}
// Is Invited: ${event['is_invited']}
// Has comment: ${event['hasRecentComment']}
// Last activity: ${event['lastActivity']}
// ''');
//           }
//         }
      
//         return eventList.map((json) => EventModel.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load events (Status ${response.statusCode})');
//       }
//     } catch (e) {
//       throw Exception('Error fetching events: $e');
//     }
//   }

//   /// Accept event invitation
//   static Future<Map<String, dynamic>> acceptEventInvitation(String invitationToken) async {
//     try {
//       final userToken = await getUserToken();
//       if (userToken == null) throw Exception('User not authenticated');

//       final response = await http.post(
//         Uri.parse('$baseUrl/event/acceptInvitation'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'invitation_token': invitationToken,
//           'user_token': userToken,
//         }),
//       );

//       if (kDebugMode) {
//         print('acceptEventInvitation response: ${response.body}');
//       }

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         return data;
//       } else {
//         throw Exception('Failed to accept invitation: ${data['message']}');
//       }
//     } catch (e) {
//       throw Exception('Error accepting invitation: $e');
//     }
//   }

// }































































































































import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moments/models/comment_model.dart';
import 'package:moments/models/contact_models.dart';
import 'package:moments/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

class NetworkService {
  // Base URLs
  static const String baseUrl = 'http://demo.yakkaytech.co.in:4007/api';
  //   // static const String baseUrl = 'http://10.0.2.2:4007/api';
  static const String profileImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/profile-image/';
  static const String eventImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/event-image/';
  static const String templateImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/template-image/';
  static const String commentImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/comment-image/';
  static const String categoryTemplateImageBaseUrl = 'http://demo.yakkaytech.co.in:83/momentsImage/template-thumbnail/';

  // Keys
  static const String _userTokenKey = 'user_token';
  static const String _eventEndpoint = '/event';

  // ==================== UTILITY METHODS ====================

  static String getImageUrl(String? imagePath, {String type = 'profile'}) {
    if (imagePath == null || imagePath.isEmpty) return '';
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    switch (type) {
      case 'event':
        return '$eventImageBaseUrl$imagePath';
      case 'template':
        return '$templateImageBaseUrl$imagePath';
      case 'comment':
        return '$commentImageBaseUrl$imagePath';
      case 'category_template_image':
        return '$categoryTemplateImageBaseUrl$imagePath';
      case 'profile':
      default:
        return '$profileImageBaseUrl$imagePath';
    }
  }

  static void _handleError(String operation, dynamic error) {
    if (kDebugMode) {
      print('❌ $operation Error: $error');
    }
  }

  static void _logSuccess(String operation, String details) {
    if (kDebugMode) {
      print('✅ $operation Success: $details');
    }
  }

  static String _cleanPhoneNumberForServer(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleaned.startsWith('91') && cleaned.length == 12) {
      return '+$cleaned';
    } else if (cleaned.length == 10) {
      return '+91$cleaned';
    } else if (cleaned.startsWith('+')) {
      return cleaned;
    } else if (cleaned.length > 10) {
      return '+$cleaned';
    }
    return cleaned;
  }

  // ==================== TOKEN MANAGEMENT ====================

  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
  }

  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey);
  }

  static Future<void> removeUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTokenKey);
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ==================== HTTP HELPER METHODS ====================

  static Future<Map<String, dynamic>> _postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData;
    } else {
      throw Exception(responseData['message'] ?? 'Failed to load data: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> _multipartRequest(
    String endpoint,
    Map<String, String> fields,
    File? file,
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    request.fields.addAll(fields);

    if (file != null) {
      final fileStream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        'photo',
        fileStream,
        length,
        filename: path.basename(file.path),
        contentType: MediaType('image', path.extension(file.path).replaceAll('.', '')),
      );
      request.files.add(multipartFile);
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(responseString);
    } else {
      throw Exception('Failed to upload: ${response.statusCode}');
    }
  }

  // ==================== USER AUTHENTICATION ====================

  static Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String fcmToken,
  }) async {
    return await _postRequest('/user/signup', {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'confirm_password': confirmPassword,
      'fcm_token': fcmToken,
    });
  }

  static Future<Map<String, dynamic>> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    return await _postRequest('/user/signin', {
      'phone_number': phoneNumber,
      'password': password,
    });
  }

  static Future<void> signOut(String userToken) async {
    await _postRequest('/user/signOut', {'user_token': userToken});
  }

  // ==================== USER PROFILE ====================

  static Future<Map<String, dynamic>> getUser(String userToken) async {
    return await _postRequest('/user/getUser', {'user_token': userToken});
  }

  static Future<Map<String, dynamic>> updateUser({
    required String userToken,
    String? name,
    String? email,
    String? phoneNumber,
    String? address,
    int? age,
    File? imageFile,
  }) async {
    final fields = {
      'user_token': userToken,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (age != null) 'age': age.toString(),
    };

    return await _multipartRequest('/user/updateUser', fields, imageFile);
  }

  static Future<Map<String, dynamic>> removeProfilePhoto(String userToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/removeProfilePhoto'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_token': userToken}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to remove profile photo');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteUser(String userToken) async {
    await _postRequest('/user/deleteUser', {'user_token': userToken});
  }

  static Future<void> updateFcmToken(String userToken, String fcmToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/updateFcmToken'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_token': userToken,
          'fcm_token': fcmToken,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update FCM token');
      }

      if (kDebugMode) {
        print('FCM token updated successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating FCM token: $e');
      }
    }
  }

  // ==================== MASTER DATA ====================

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/master/getCategory'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getTemplatesByCategory(String categoryCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/event/templatesEvent'),
        headers: await _getHeaders(),
        body: json.encode({'category_code': categoryCode}),
      );

      if (kDebugMode) {
        print('Response from getTemplatesByCategory: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List templates = json.decode(response.body)['data'];

        return templates.map<Map<String, dynamic>>((template) {
          final imagePath = template['image_path'] ?? '';
          return {
            'name': template['name'],
            'file': template['file'],
            'preview_url': template['preview_url'],
            'image_url': '$categoryTemplateImageBaseUrl$imagePath',
            'image_path': imagePath,
          };
        }).toList();
      } else {
        throw Exception('Failed to load templates');
      }
    } catch (e) {
      throw Exception('Error fetching templates: $e');
    }
  }

  static Future<List<dynamic>> getEventVisibilityOptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/master/eventVisibility'),
        headers: await _getHeaders(),
      );

      if (kDebugMode) {
        print('Response from getEventVisibilityOptions: $response');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load visibility options');
      }
    } catch (e) {
      throw Exception('Error fetching visibility options: $e');
    }
  }

  static Future<List<dynamic>> getStatusOptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/master/getStatus'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw Exception('Failed to load status options');
      }
    } catch (e) {
      throw Exception('Error fetching status options: $e');
    }
  }

  // ==================== EVENT MANAGEMENT ====================

  static Future<Map<String, dynamic>> createEvent({
    required String eventName,
    required String categoryCode,
    required DateTime eventDateTime,
    required String location,
    required String description,
    required String visibilityCode,
    String? templateName,
    File? imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('user_token') ?? '';

      final formattedDate = DateFormat('yyyy-MM-dd').format(eventDateTime);
      final formattedTime = DateFormat('HH:mm').format(eventDateTime);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/event/createEvent'),
      );

      request.headers.addAll(await _getHeaders());

      request.fields['event_name'] = eventName;
      request.fields['event_date'] = formattedDate;
      request.fields['time'] = formattedTime;
      request.fields['location'] = location;
      request.fields['description'] = description;
      request.fields['user_token'] = userToken;
      request.fields['category_code'] = categoryCode;
      request.fields['event_visibility_code'] = visibilityCode;
      request.fields['use_template'] = (templateName != null).toString();

      if (kDebugMode) {
        print('Creating event with fields: ${request.fields}');
      }

      if (templateName != null) {
        request.fields['template_name'] = templateName;
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'event_image',
            imageFile.path,
          ),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (kDebugMode) {
        print('Create Event Response: $responseData');
      }

      if (response.statusCode == 201) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to create event: ${json.decode(responseData)['message']}');
      }
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  static Future<EventModel> getEventDetail(String eventToken) async {
    final userToken = await getUserToken();
    final response = await http.post(
      Uri.parse('$baseUrl/event/getEventDetail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'event_token': eventToken,
        if (userToken != null) 'user_token': userToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EventModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to load event details');
    }
  }

  static Future<List<EventModel>> getMyEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$_eventEndpoint/getMyEvents'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_token': userToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((event) => EventModel.fromJson(event))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  static Future<List<EventModel>> getAllEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      final response = await http.post(
        Uri.parse('$baseUrl/event/getAllEvents'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_token': userToken}),
      );

      if (kDebugMode) {
        print('getAllEvents: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> eventList = responseBody['data'] ?? [];

        if (kDebugMode) {
          for (var event in eventList) {
            print('''
Event: ${event['event_name']}
Is Private: ${event['is_private']}
Is Invited: ${event['is_invited']}
Has comment: ${event['hasRecentComment']}
Last activity: ${event['lastActivity']}
''');
          }
        }

        return eventList.map((json) => EventModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events (Status ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  static Future<EventModel> editEvent({
    required String eventToken,
    required String title,
    required DateTime date,
    required String time,
    String? description,
    String? categoryCode,
    String? visibilityCode,
    String? location,
    File? imageFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$_eventEndpoint/editEvent'),
      );

      request.fields['event_token'] = eventToken;
      request.fields['user_token'] = userToken;
      request.fields['event_name'] = title;
      request.fields['event_date'] = DateFormat('yyyy-MM-dd').format(date);
      request.fields['time'] = time;
      if (description != null) request.fields['description'] = description;
      if (categoryCode != null) request.fields['category_code'] = categoryCode;
      if (visibilityCode != null) request.fields['event_visibility_code'] = visibilityCode;
      if (location != null) request.fields['location'] = location;

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        final fileExtension = path.extension(imageFile.path).replaceFirst('.', '');

        request.files.add(await http.MultipartFile.fromPath(
          'event_image',
          imageFile.path,
          contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
          filename: 'event_image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension',
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        return EventModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to edit event: ${jsonDecode(responseData)['message']}');
      }
    } catch (e) {
      throw Exception('Error editing event: $e');
    }
  }

  static Future<EventModel> markEventCompleted(String eventToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$_eventEndpoint/markEventCompleted'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event_token': eventToken,
          'user_token': userToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EventModel.fromJson(data['data']);
      } else {
        throw Exception('Failed to mark event as completed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error marking event as completed: $e');
    }
  }

  static Future<void> deleteEvent(String eventToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$_eventEndpoint/deleteEvent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event_token': eventToken,
          'user_token': userToken,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete event: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  static Future<List<EventModel>> getCompletedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString(_userTokenKey);

      if (userToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$_eventEndpoint/getCompletedEventsByDate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_token': userToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return (data['data'] as List)
              .map((event) => EventModel.fromJson(event))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load completed events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching completed events: $e');
    }
  }

  // ==================== PIN EVENT ====================

  static Future<bool> togglePinEvent(String eventToken, String userToken) async {
    try {
      if (kDebugMode) {
        print('🔄 Toggling pin for event: $eventToken');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/pinned/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_token': userToken,
          'event_token': eventToken,
        }),
      ).timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('📡 togglePinEvent Response: ${response.statusCode} → ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final isPinned = data['pinned'] ?? false;
          _logSuccess('Toggle Pin', isPinned ? 'Event pinned' : 'Event unpinned');
          return isPinned;
        } else {
          throw Exception(data['message'] ?? 'Failed to toggle pin status');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to toggle pin');
      }
    } catch (e) {
      _handleError('togglePinEvent', e);
      throw Exception('Failed to toggle pin status: $e');
    }
  }

  static Future<List<EventModel>> getPinnedEvents(String userToken) async {
    try {
      if (kDebugMode) {
        print('🔄 Fetching pinned events for user');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/pinned/getpinuser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'user_token': userToken}),
      ).timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('📡 getPinnedEvents Response: ${response.statusCode} → ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final eventsData = data['data'] as List? ?? [];
          final events = eventsData
              .map((eventJson) => EventModel.fromJson(eventJson))
              .map((event) => event.copyWith(isPinned: true))
              .toList();

          _logSuccess('Get Pinned Events', '${events.length} events loaded');
          return events;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch pinned events');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to fetch pinned events');
      }
    } catch (e) {
      _handleError('getPinnedEvents', e);
      throw Exception('Failed to load pinned events: $e');
    }
  }

  static Future<bool> checkPinnedStatus(String userToken, String eventToken) async {
    try {
      if (kDebugMode) {
        print('🔄 Checking pin status for event: $eventToken');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/pinned/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_token': userToken,
          'event_token': eventToken,
        }),
      ).timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        print('📡 checkPinnedStatus Response: ${response.statusCode} → ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final isPinned = data['isPinned'] ?? false;
          _logSuccess('Check Pin Status', isPinned ? 'Event is pinned' : 'Event is not pinned');
          return isPinned;
        } else {
          throw Exception(data['message'] ?? 'Failed to check pin status');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'HTTP ${response.statusCode}: Failed to check pin status');
      }
    } catch (e) {
      _handleError('checkPinnedStatus', e);
      throw Exception('Failed to check pin status: $e');
    }
  }

  static Future<Map<String, bool>> checkMultiplePinnedStatus(
    String userToken,
    List<String> eventTokens,
  ) async {
    final Map<String, bool> results = {};

    try {
      const batchSize = 10;
      for (int i = 0; i < eventTokens.length; i += batchSize) {
        final batch = eventTokens.skip(i).take(batchSize).toList();

        final futures = batch.map((token) async {
          try {
            final isPinned = await checkPinnedStatus(userToken, token);
            return MapEntry(token, isPinned);
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Failed to check pin status for $token: $e');
            }
            return MapEntry(token, false);
          }
        });

        final batchResults = await Future.wait(futures);
        for (final entry in batchResults) {
          results[entry.key] = entry.value;
        }
      }

      _logSuccess('Batch Pin Check', '${results.length} events checked');
      return results;
    } catch (e) {
      _handleError('checkMultiplePinnedStatus', e);
      return {};
    }
  }

  // ==================== COMMENTS ====================

  static Future<CommentModel> createComment({
    required String content,
    required String eventToken,
    required String userToken,
    List<File> mediaFiles = const [],
    Function(double)? onProgress,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/comment/createComment');
      var request = http.MultipartRequest('POST', uri);

      request.fields['content'] = content;
      request.fields['event_token'] = eventToken;
      request.fields['user_token'] = userToken;

      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final fileStream = http.ByteStream(file.openRead().cast());
        final fileLength = await file.length();

        final multipartFile = http.MultipartFile(
          'media',
          fileStream,
          fileLength,
          filename: path.basename(file.path),
          contentType: MediaType.parse(mimeType),
        );

        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true && responseData['data'] != null) {
          return CommentModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create comment');
      }
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  static Future<Map<String, dynamic>> getEventComments({
    required String eventToken,
    int page = 1,
    int limit = 10,
    String? userToken,
  }) async {
    final body = {
      'event_token': eventToken,
      'page': page,
      'limit': limit,
      if (userToken != null) 'user_token': userToken,
    };

    final response = await _postRequest('/comment/geteventcomment', body);

    final List<dynamic> commentsJson = response['data']['comments'] ?? [];
    final List<CommentModel> comments = commentsJson
        .map((json) => CommentModel.fromJson(json))
        .toList();

    return {
      'success': response['success'],
      'total': response['data']['total'],
      'page': response['data']['page'],
      'totalPages': response['data']['totalPages'],
      'comments': comments,
    };
  }

  static Future<Map<String, dynamic>> toggleCommentLike({
    required String commentToken,
    required String userToken,
  }) async {
    final body = {
'comment_token': commentToken,
      'user_token': userToken,
    };

    final response = await _postRequest('/comment/liketoggle', body);
    return {
      'success': response['success'],
      'isLiked': response['data']['isLiked'],
      'likeCount': response['data']['likeCount'],
    };
  }

  static Future<CommentModel> createReply({
    required String content,
    required String userToken,
    required String commentToken,
    List<File> mediaFiles = const [],
    Function(double)? onProgress,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/comment/createcommentreply');
      var request = http.MultipartRequest('POST', uri);

      request.fields['content'] = content;
      request.fields['user_token'] = userToken;
      request.fields['comment_token'] = commentToken;

      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final fileStream = http.ByteStream(file.openRead().cast());
        final fileLength = await file.length();

        final multipartFile = http.MultipartFile(
          'media',
          fileStream,
          fileLength,
          filename: path.basename(file.path),
          contentType: MediaType.parse(mimeType),
        );

        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true && responseData['data'] != null) {
          return CommentModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create reply');
      }
    } catch (e) {
      throw Exception('Failed to create reply: $e');
    }
  }

  static Future<CommentModel> updateComment({
    required String content,
    required String commentToken,
    required String userToken,
    List<File> mediaFiles = const [],
    Function(double)? onProgress,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/comment/updateComment');
      var request = http.MultipartRequest('POST', uri);

      request.fields['content'] = content;
      request.fields['comment_token'] = commentToken;
      request.fields['user_token'] = userToken;

      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final fileStream = http.ByteStream(file.openRead().cast());
        final fileLength = await file.length();

        final multipartFile = http.MultipartFile(
          'media',
          fileStream,
          fileLength,
          filename: path.basename(file.path),
          contentType: MediaType.parse(mimeType),
        );

        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseData = jsonDecode(responseString);

      if (response.statusCode == 200) {
        if (responseData['success'] == true && responseData['data'] != null) {
          return CommentModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update comment');
      }
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

  static Future<bool> deleteComment({
    required String commentToken,
    required String userToken,
  }) async {
    final body = {
      'comment_token': commentToken,
      'user_token': userToken,
    };

    final response = await _postRequest('/comment/deleteComment', body);
    return response['success'] == true;
  }

  static Future<List<Map<String, dynamic>>> getRecentlyCommentedEvents({
    int limit = 5,
  }) async {
    final body = {'limit': limit};
    final response = await _postRequest('/comment/getrecentlycommentedevents', body);
    return List<Map<String, dynamic>>.from(response['data'] ?? []);
  }

  // ==================== EVENT INVITATIONS ====================

  static Future<List<EventModel>> getInvitedEvents() async {
    final userToken = await getUserToken();
    if (userToken == null) throw Exception('User not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/event/getInvitedEvents'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_token': userToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((event) => EventModel.fromJson(event))
          .toList();
    } else {
      throw Exception('Failed to load invited events: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> inviteUsers({
    required String eventToken,
    required List<String> phoneNumbers,
  }) async {
    final userToken = await getUserToken();
    if (userToken == null) throw Exception('User not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/event/inviteUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'event_token': eventToken,
        'user_token': userToken,
        'phone_numbers': phoneNumbers,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception('Failed to send invitations: ${data['message'] ?? response.body}');
    }
  }

  static Future<EventModel> acceptInvitation(String invitationToken) async {
    final userToken = await getUserToken();
    if (userToken == null) throw Exception('User not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/event/acceptInvitation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'invitation_token': invitationToken,
        'user_token': userToken,
      }),
    );

    if (kDebugMode) {
      print('acceptInvitation response: ${response.body}');
      print('response $response');
      print('acceptInvitation: ${response.statusCode} → ${response.body}');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return EventModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to accept invitation: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> acceptEventInvitation(String invitationToken) async {
    try {
      final userToken = await getUserToken();
      if (userToken == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/event/acceptInvitation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'invitation_token': invitationToken,
          'user_token': userToken,
        }),
      );

      if (kDebugMode) {
        print('acceptEventInvitation response: ${response.body}');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Failed to accept invitation: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Error accepting invitation: $e');
    }
  }

  static Future<Map<String, dynamic>> getInvitationDetails(String invitationToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/event/getInvitationDetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'invitation_token': invitationToken}),
      );

      if (kDebugMode) {
        print('getInvitationDetails response: ${response.body}');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Failed to get invitation details: ${data['message']}');
      }
    } catch (e) {
      throw Exception('Error getting invitation details: $e');
    }
  }

  static Future<Map<String, dynamic>> inviteUsersToPrivateEvent({
    required String eventToken,
    required List<ContactInvitation> contacts,
  }) async {
    try {
      final userToken = await getUserToken();
      if (userToken == null) throw Exception('User not authenticated');

      if (kDebugMode) {
        print('Original phone numbers:');
        for (var contact in contacts) {
          print('${contact.name}: ${contact.phoneNumber}');
        }
      }

      final cleanedContacts = contacts.map((contact) {
        final cleanedNumber = _cleanPhoneNumberForServer(contact.phoneNumber);

        if (kDebugMode) {
          print('Cleaned: ${contact.phoneNumber} -> $cleanedNumber');
        }

        return {
          'name': contact.name,
          'phone_number': cleanedNumber,
          'is_registered': contact.isRegistered,
        };
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/event/inviteUsersToPrivateEvent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event_token': eventToken,
          'user_token': userToken,
          'contacts': cleanedContacts,
        }),
      );

      if (kDebugMode) {
        print('inviteUsersToPrivateEvent response: ${response.body}');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Failed to send invitations: ${data['message'] ?? response.body}');
      }
    } catch (e) {
      throw Exception('Error sending invitations: $e');
    }
  }

  // ==================== CONTACT MANAGEMENT ====================

  static Future<Map<String, dynamic>> checkRegisteredUsers(List<String> phoneNumbers) async {
    try {
      final cleanedNumbers = phoneNumbers.map((phone) => phone.replaceAll(RegExp(r'[^0-9+]'), '')).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/user/check-users'),
        headers: await _getHeaders(),
        body: json.encode({'phoneNumbers': cleanedNumbers}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to check registered users');
      }
    } catch (e) {
      throw Exception('Error checking users: $e');
    }
  }

  static Future<Map<String, dynamic>> checkContactsForRegisteredUsers(List<ContactInfo> contacts) async {
    try {
      final phoneNumbers = contacts.map((c) => c.phoneNumber).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/user/check-users'),
        headers: await _getHeaders(),
        body: json.encode({'phoneNumbers': phoneNumbers}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final registeredUsers = List<Map<String, dynamic>>.from(responseData['registered'] ?? []);
        final unregisteredNumbers = List<String>.from(responseData['unregistered'] ?? []);

        final registeredPhones = registeredUsers
            .map((user) => user['phone_number'] as String)
            .toSet();

        final enrichedContacts = contacts.map((contact) {
          final isRegistered = registeredPhones.contains(contact.phoneNumber);
          final registeredUser = registeredUsers.firstWhere(
            (user) => user['phone_number'] == contact.phoneNumber,
            orElse: () => {},
          );

          return {
            'name': contact.name,
            'phoneNumber': contact.phoneNumber,
            'isRegistered': isRegistered,
            'userData': isRegistered ? registeredUser : null,
          };
        }).toList();

        return {
          'success': true,
          'contacts': enrichedContacts,
          'registered_count': registeredUsers.length,
          'unregistered_count': unregisteredNumbers.length,
          'total_checked': contacts.length,
        };
      } else {
        throw Exception(responseData['message'] ?? 'Failed to check registered users');
      }
    } catch (e) {
      throw Exception('Error checking users: $e');
    }
  }
}