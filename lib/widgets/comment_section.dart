// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 10;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _scrollController.addListener(_scrollListener);
//     _focusNode.addListener(_onFocusChange);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus && _showEmojiPicker) {
//       setState(() => _showEmojiPicker = false);
//     }
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >= 
//         _scrollController.position.maxScrollExtent - 100) {
//       if (!_isLoading && _hasMore) {
//         _loadComments();
//       }
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );
//     // Clear existing comments if it's the first page
//     if (_page == 1) {
//       _comments.clear();
//     }
//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error loading comments: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

// Future<void> _postComment() async {
//   if (_isPosting) return;
  
//   final content = _controller.text.trim();
//   if (content.isEmpty && _selectedMedia.isEmpty) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please add content or media")),
//       );
//     }
//     return;
//   }

//   final authProvider = context.read<AuthProvider>();
//   if (authProvider.user == null) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("You need to be logged in to comment")),
//       );
//     }
//     return;
//   }

//   setState(() => _isPosting = true);

//   try {
//     CommentModel comment;
    
//     if (_selectedMedia.isNotEmpty) {
//       comment = await NetworkService.createCommentWithMedia(
//         content: content,
//         eventToken: widget.eventToken,
//         userToken: authProvider.user!.userToken,
//         mediaFiles: _selectedMedia,
//       );
//     } else {
//       comment = await NetworkService.createComment(
//         content: content,
//         eventToken: widget.eventToken,
//         userToken: authProvider.user!.userToken,
//       );
//     }

//     if (mounted) {
//       setState(() {
//         _comments.insert(0, comment);
//         _selectedMedia.clear();
//         _controller.clear();
//         _focusNode.unfocus();
//       });
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error posting comment: ${e.toString()}")),
//       );
//     }
//   } finally {
//     if (mounted) {
//       setState(() => _isPosting = false);
//     }
//   }
// }

// Future<List<File>?> _pickMedia() async {
//   try {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickMedia(
//       maxWidth: 1920,
//       maxHeight: 1080,
//       imageQuality: 85,
//     );

//     if (pickedFile != null) {
//       final file = File(pickedFile.path);

//       // Check file size (limit to 50MB to match your backend)
//       final fileSize = await file.length();
//       if (fileSize > 50 * 1024 * 1024) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Media size should be less than 50MB")),
//           );
//         }
//         return null;
//       }

//       return [file];
//     }
//     return null;
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking media: ${e.toString()}")),
//       );
//     }
//     return null;
//   }
// }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png');

//     return Container(
//       width: 100,
//       height: 100,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.videocam, size: 40),
//                     Text(
//                       'Video',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildInputField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Emoji button
//           IconButton(
//             icon: Icon(
//               Icons.emoji_emotions_outlined,
//               color: Theme.of(context).hintColor,
//             ),
//             onPressed: _toggleEmojiPicker,
//           ),
          
//           // Text field
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               focusNode: _focusNode,
//               decoration: InputDecoration(
//                 hintText: "Type a message...",
//                 hintStyle: TextStyle(color: Theme.of(context).hintColor),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//               ),
//               maxLines: null,
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ),
          
//           // Media buttons
//           IconButton(
//             icon: Icon(Icons.add_circle_outline, color: Theme.of(context).hintColor),
//             onPressed: _showMediaOptions,
//           ),
          
//           // Send button
//           IconButton(
//             icon: _isPosting
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : Icon(
//                     Icons.send,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//             onPressed: _postComment,
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//     }
//     setState(() => _showEmojiPicker = !_showEmojiPicker);
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final picked = await _pickMedia();
//                 if (picked != null) {
//                   setState(() => _selectedMedia.addAll(picked));
//                 }
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Camera'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final picked = await ImagePicker().pickImage(
//                   source: ImageSource.camera,
//                   maxWidth: 1920,
//                   maxHeight: 1080,
//                   imageQuality: 85,
//                 );
//                 if (picked != null) {
//                   setState(() => _selectedMedia.add(File(picked.path)));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// @override
// Widget build(BuildContext context) {
//   final authProvider = context.watch<AuthProvider>();
  
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       // Title
//       Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           'Comments',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       const SizedBox(height: 16),
      
//       // Comments list (non-scrollable)
//       ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: _comments.length + (_hasMore ? 1 : 0),
//         padding: const EdgeInsets.only(bottom: 8),
//         itemBuilder: (context, index) {
//           if (index == _comments.length) {
//             return _hasMore 
//                 ? const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Center(child: CircularProgressIndicator()),
//                   )
//                 : const SizedBox.shrink();
//           }
          
//           final comment = _comments[index];
//           final isOwner = authProvider.user?.userToken == comment.userToken;

//           return CommentTile(
//             comment: comment,
//             isOwner: isOwner,
//             formatDate: _formatDate,
//             onLike: () => _toggleLike(comment),
//             onReply: () => _addReply(comment),
//             onEdit: isOwner ? () => _editComment(comment) : null,
//             onDelete: isOwner ? () => _deleteComment(comment) : null,
//           );
//         },
//       ),
      
//       // Media preview
//       if (_selectedMedia.isNotEmpty)
//         SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _selectedMedia.length,
//             itemBuilder: (context, index) {
//               return Stack(
//                 children: [
//                   _buildMediaPreview(_selectedMedia[index]),
//                   Positioned(
//                     top: 4,
//                     right: 4,
//                     child: CircleAvatar(
//                       radius: 12,
//                       backgroundColor: Colors.black54,
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: const Icon(Icons.close, size: 12, color: Colors.white),
//                         onPressed: () => setState(() => _selectedMedia.removeAt(index)),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
      
//       // Input field
//       Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 8,
//           right: 8,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildInputField(),
//             if (_showEmojiPicker)
//               Container(
//                 height: 250,
//                 color: Theme.of(context).cardColor,
//                 child: Center(
//                   child: Text(
//                     'Emoji Picker',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

//     Future<void> _toggleLike(CommentModel comment) async {
//       final authProvider = context.read<AuthProvider>();
//       if (authProvider.user == null) return;

//       try {
//         final result = await NetworkService.toggleCommentLike(
//           commentToken: comment.commentToken,
//           userToken: authProvider.user!.userToken,
//         );

//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = _comments[index].copyWith(
//               likeCount: result['likeCount'],
//               isLiked: result['isLiked'],
//             );
//           }
//         });
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error toggling like: ${e.toString()}")),
//           );
//         }
//       }
//     }

//     Future<void> _addReply(CommentModel parentComment) async {
//       final replyController = TextEditingController();
//       final replyMedia = <File>[];

//       await showDialog(
//         context: context,
//         builder: (context) => StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text("Write a reply"),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: replyController,
//                       decoration: const InputDecoration(hintText: "Your reply"),
//                       autofocus: true,
//                       maxLines: 3,
//                     ),
//                     if (replyMedia.isNotEmpty)
//                       SizedBox(
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: replyMedia.length,
//                           itemBuilder: (context, index) {
//                             return Stack(
//                               children: [
//                                 _buildMediaPreview(replyMedia[index]),
//                                 Positioned(
//                                   top: 4,
//                                   right: 4,
//                                   child: GestureDetector(
//                                     onTap: () => setState(() => replyMedia.removeAt(index)),
//                                     child: const Icon(Icons.close, color: Colors.red),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     TextButton(
//                       child: const Text("Add Media"),
//                       onPressed: () async {
//                         final picked = await _pickMedia();
//                         if (picked != null) {
//                           setState(() {
//                             replyMedia.addAll(picked);
//                           });
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final content = replyController.text.trim();
//                     if (content.isEmpty && replyMedia.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please add content or media")),
//                       );
//                       return;
//                     }

//                     final authProvider = context.read<AuthProvider>();
//                     if (authProvider.user == null) return;

//                     try {
//                       CommentModel reply;
                      
//                       if (replyMedia.isNotEmpty) {
//                         reply = await NetworkService.createCommentWithMedia(
//                           content: content,
//                           eventToken: widget.eventToken,
//                           userToken: authProvider.user!.userToken,
//                           mediaFiles: replyMedia,
//                         );
//                       } else {
//                         reply = await NetworkService.createReply(
//                           content: content,
//                           commentToken: parentComment.commentToken,
//                           userToken: authProvider.user!.userToken,
//                         );
//                       }

//                       if (mounted) {
//                         setState(() {
//                           final index = _comments.indexWhere(
//                             (c) => c.commentToken == parentComment.commentToken);
//                           if (index != -1) {
//                             _comments.insert(index + 1, reply);
//                           }
//                         });
//                         Navigator.pop(context);
//                       }
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Error posting reply: ${e.toString()}")),
//                       );
//                     }
//                   },
//                   child: const Text("Reply"),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//     }

//   Future<void> _editComment(CommentModel comment) async {
//     final editController = TextEditingController(text: comment.content);
//     final editMedia = <File>[];
    
//     await showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: const Text("Edit Comment"),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: editController,
//                     decoration: const InputDecoration(hintText: "Edit your comment"),
//                     autofocus: true,
//                     maxLines: 3,
//                   ),
//                   if (editMedia.isNotEmpty)
//                     SizedBox(
//                       height: 100,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: editMedia.length,
//                         itemBuilder: (context, index) {
//                           return Stack(
//                             children: [
//                               _buildMediaPreview(editMedia[index]),
//                               Positioned(
//                                 top: 4,
//                                 right: 4,
//                                 child: GestureDetector(
//                                   onTap: () => setState(() => editMedia.removeAt(index)),
//                                   child: const Icon(Icons.close, color: Colors.red),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   TextButton(
//                     child: const Text("Add Media"),
//                     onPressed: () async {
//                       final pickedFiles = await _pickMedia();
//                       if (pickedFiles != null) {
//                         setState(() {
//                           editMedia.addAll(pickedFiles);
//                           // Limit to 5 media files
//                           if (editMedia.length > 5) {
//                             editMedia.removeRange(5, editMedia.length);
//                           }
//                         });
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("Cancel"),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final content = editController.text.trim();
//                   if (content.isEmpty && editMedia.isEmpty) {
//                     if (mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please add content or media")),
//                       );
//                     }
//                     return;
//                   }

//                   final authProvider = context.read<AuthProvider>();
//                   if (authProvider.user == null) return;

//                   try {
//                     CommentModel updated;
                    
//                     if (editMedia.isNotEmpty) {
//                       updated = await NetworkService.updateCommentWithMedia(
//                         content: content,
//                         commentToken: comment.commentToken,
//                         userToken: authProvider.user!.userToken,
//                         mediaFiles: editMedia,
//                       );
//                     } else {
//                       updated = await NetworkService.updateComment(
//                         content: content,
//                         commentToken: comment.commentToken,
//                         userToken: authProvider.user!.userToken,
//                       );
//                     }

//                     if (mounted) {
//                       setState(() {
//                         final index = _comments.indexWhere(
//                           (c) => c.commentToken == comment.commentToken);
//                         if (index != -1) {
//                           _comments[index] = updated;
//                         }
//                       });
//                       Navigator.pop(context);
//                     }
//                   } catch (e) {
//                     if (mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Error updating comment: ${e.toString()}")),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text("Update"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//     Future<void> _deleteComment(CommentModel comment) async {
//       final authProvider = context.read<AuthProvider>();
//       if (authProvider.user == null) return;

//       final confirm = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Delete Comment"),
//           content: const Text("Are you sure you want to delete this comment?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text("Delete"),
//             ),
//           ],
//         ),
//       );

//       if (confirm != true) return;

//       try {
//         final success = await NetworkService.deleteComment(
//           commentToken: comment.commentToken,
//           userToken: authProvider.user!.userToken,
//         );

//         if (success && mounted) {
//           setState(() {
//             _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//           });
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Error deleting comment: ${e.toString()}")),
//           );
//         }
//       }
//     }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//     } catch (_) {
//       return '';
//     }
//   }
// }

// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

              
// GestureDetector(
//   onTap: () {
//     if (comment.userPhoto != null && comment.userPhoto!.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProfilePhotoViewer(
//             imageUrl: NetworkService.getImageUrl(comment.userPhoto!),
//           ),
//         ),
//       );
//     }
//   },
//   child: CircleAvatar(
//     radius: 20,
//     backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//         ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//         : null,
//     child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//         ? Text(comment.userName != null && comment.userName!.isNotEmpty
//             ? comment.userName![0].toUpperCase()
//             : '?')
//         : null,
//   ),
// ),
//               const SizedBox(width: 8),
              
              
//               // Comment content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // User name and time
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Unknown',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
                    
//                     // Comment text
//                     Text(
//                       comment.content,
//                       style: theme.textTheme.bodyMedium,
//                     ),
                    
//                     // Attachments
//         // Attachments
//         if (comment.attachments.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: SizedBox(
//               height: 150,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: comment.attachments.length,
//                 itemBuilder: (context, index) {
//                   final attachment = comment.attachments[index];
//                   return GestureDetector(
//                     onTap: () => _showMediaDialog(context, attachment),
//                     child: Container(
//                       width: 150,
//                       margin: const EdgeInsets.only(right: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: theme.cardColor,
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: attachment.type == 'image'
//                             ? Image.network(
//                                 attachment.url,
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(
//                                     child: CircularProgressIndicator(
//                                       value: loadingProgress.expectedTotalBytes != null
//                                           ? loadingProgress.cumulativeBytesLoaded /
//                                               loadingProgress.expectedTotalBytes!
//                                           : null,
//                                     ),
//                                   );
//                                 },
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Center(
//                                     child: Icon(Icons.broken_image),
//                                   );
//                                 },
//                               )
//                             : Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   if (attachment.thumbnailUrl != null)
//                                     Image.network(
//                                       attachment.thumbnailUrl!,
//                                       fit: BoxFit.cover,
//                                       width: 150,
//                                       height: 150,
//                                     ),
//                                   const Icon(Icons.play_circle_fill, 
//                                     size: 50, 
//                                     color: Colors.white70),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
                    
//                     // Actions
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                               size: 20,
//                               color: comment.isLiked ? Colors.red : theme.iconTheme.color,
//                             ),
//                             onPressed: onLike,
//                           ),
//                           Text(
//                             comment.likeCount.toString(),
//                             style: theme.textTheme.bodySmall,
//                           ),
//                           const SizedBox(width: 8),
//                           TextButton(
//                             onPressed: onReply,
//                             child: Text(
//                               'Reply',
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                           if (isOwner) ...[
//                             const Spacer(),
//                             TextButton(
//                               onPressed: onEdit,
//                               child: Text(
//                                 'Edit',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: theme.colorScheme.primary,
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: onDelete,
//                               child: Text(
//                                 'Delete',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//             //         if (comment.replies.isNotEmpty)
//             // Padding(
//             //   padding: const EdgeInsets.only(left: 48.0, top: 8),
//             //   child: Column(
//             //     children: [
//             //       // Reply indicator line
//             //       Container(
//             //         width: 2,
//             //         height: 8,
//             //         color: Colors.grey[300],
//             //         margin: const EdgeInsets.only(left: 20),
//             //       ),
//             //       // Replies list
//             //       ...comment.replies.map((reply) => CommentTile(
//             //         comment: reply,
//             //         isOwner: isOwner, // You might want to adjust this for replies
//             //         formatDate: formatDate,
//             //         onLike: () => onLike(reply),
//             //         onReply: () => onReply(reply),
//             //         onEdit: isOwner ? () => onEdit?.call(reply) : null,
//             //         onDelete: isOwner ? () => onDelete?.call(reply) : null,
//             //       )).toList(),
//             //     ],
//             //   ),
//             // ),
//                     // Display replies if they exist
//           if (comment.replies.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(left: 48.0, top: 8),
//               child: Column(
//                 children: [
//                   // Reply indicator line
//                   Container(
//                     width: 2,
//                     height: 8,
//                     color: Colors.grey[300],
//                     margin: const EdgeInsets.only(left: 20),
//                   ),
//                   // Replies list
//                   ...comment.replies.map((reply) => CommentTile(
//                     comment: reply,
//                     isOwner: isOwner, // You might want to adjust this for replies
//                     formatDate: formatDate,
//                     onLike: onLike,
//                     onReply: onReply,
//                     onEdit: onEdit,
//                     onDelete: onDelete,
//                   )).toList(),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: attachment.type == 'image'
//               ? InteractiveViewer(
//                   child: Image.network(
//                     attachment.url,
//                     fit: BoxFit.contain,
//                   ),
//                 )
//               : VideoPlayerWidget(videoUrl: attachment.url),
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               IconButton(
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 50,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isPlaying = !_isPlaying;
//                     _isPlaying ? _controller.play() : _controller.pause();
//                   });
//                 },
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }


//  class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Hero(
//             tag: imageUrl,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(Icons.error, color: Colors.white),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 10;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _scrollController.addListener(_scrollListener);
//     _focusNode.addListener(_onFocusChange);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus && _showEmojiPicker) {
//       setState(() => _showEmojiPicker = false);
//     }
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >= 
//         _scrollController.position.maxScrollExtent - 100) {
//       if (!_isLoading && _hasMore) {
//         _loadComments();
//       }
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error loading comments: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please add content or media")),
//         );
//       }
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("You need to be logged in to comment")),
//         );
//       }
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//       }

//       if (mounted) {
//         setState(() {
//           _comments.insert(0, comment);
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error posting comment: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);

//         // Check file size (limit to 50MB)
//         final fileSize = await file.length();
//         if (fileSize > 50 * 1024 * 1024) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Media size should be less than 50MB")),
//             );
//           }
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("You can only attach up to 5 files")),
//             );
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error picking media: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png');

//     return Container(
//       width: 100,
//       height: 100,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.videocam, size: 40),
//                     Text(
//                       'Video',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildInputField() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           if (_replyingTo != null || _editingComment != null)
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, bottom: 4),
//               child: Row(
//                 children: [
//                   Text(
//                     _editingComment != null 
//                         ? "Editing comment..." 
//                         : "Replying to ${_replyingTo ?? ''}",
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Theme.of(context).hintColor,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.close, size: 16),
//                     onPressed: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.emoji_emotions_outlined,
//                   color: Theme.of(context).hintColor,
//                 ),
//                 onPressed: _toggleEmojiPicker,
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   focusNode: _focusNode,
//                   decoration: InputDecoration(
//                     hintText: _editingComment != null 
//                         ? "Edit your comment..." 
//                         : "Type a message...",
//                     hintStyle: TextStyle(color: Theme.of(context).hintColor),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                   ),
//                   maxLines: null,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.add_circle_outline, 
//                   color: Theme.of(context).hintColor,
//                 ),
//                 onPressed: _showMediaOptions,
//               ),
//               IconButton(
//                 icon: _isPosting
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : Icon(
//                         Icons.send,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                 onPressed: _postComment,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//     }
//     setState(() => _showEmojiPicker = !_showEmojiPicker);
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickMedia();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Camera'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 final picked = await ImagePicker().pickImage(
//                   source: ImageSource.camera,
//                   maxWidth: 1920,
//                   maxHeight: 1080,
//                   imageQuality: 85,
//                 );
//                 if (picked != null) {
//                   setState(() => _selectedMedia.add(File(picked.path)));
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error toggling like: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Comment"),
//         content: const Text("Are you sure you want to delete this comment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error deleting comment: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//     } catch (_) {
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
    
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Title
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Comments',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         // Comments list
//         Expanded(
//           child: RefreshIndicator(
//             onRefresh: () async {
//               setState(() {
//                 _page = 1;
//                 _hasMore = true;
//               });
//               await _loadComments();
//             },
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _comments.length + (_hasMore ? 1 : 0),
//               padding: const EdgeInsets.only(bottom: 8),
//               itemBuilder: (context, index) {
//                 if (index == _comments.length) {
//                   return _hasMore 
//                       ? const Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Center(child: CircularProgressIndicator()),
//                         )
//                       : const SizedBox.shrink();
//                 }
                
//                 final comment = _comments[index];
//                 final isOwner = authProvider.user?.userToken == comment.userToken;

//                 return CommentTile(
//                   comment: comment,
//                   isOwner: isOwner,
//                   formatDate: _formatDate,
//                   onLike: () => _toggleLike(comment),
//                   onReply: () => _startReply(comment),
//                   onEdit: isOwner ? () => _startEdit(comment) : null,
//                   onDelete: isOwner ? () => _deleteComment(comment) : null,
//                 );
//               },
//             ),
//           ),
//         ),
        
//         // Media preview
//         if (_selectedMedia.isNotEmpty)
//           SizedBox(
//             height: 100,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _selectedMedia.length,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   children: [
//                     _buildMediaPreview(_selectedMedia[index]),
//                     Positioned(
//                       top: 4,
//                       right: 4,
//                       child: CircleAvatar(
//                         radius: 12,
//                         backgroundColor: Colors.black54,
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: const Icon(Icons.close, size: 12, color: Colors.white),
//                           onPressed: () => setState(() => _selectedMedia.removeAt(index)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
        
//         // Input field
//         Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 8,
//             right: 8,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildInputField(),
//               if (_showEmojiPicker)
//                 Container(
//                   height: 250,
//                   color: Theme.of(context).cardColor,
//                   child: Center(
//                     child: Text(
//                       'Emoji Picker',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (comment.userPhoto != null && comment.userPhoto!.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProfilePhotoViewer(
//                           imageUrl: NetworkService.getImageUrl(comment.userPhoto!),
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                       ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                       : null,
//                   child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                       ? Text(comment.userName != null && comment.userName!.isNotEmpty
//                           ? comment.userName![0].toUpperCase()
//                           : '?')
//                       : null,
//                 ),
//               ),
//               const SizedBox(width: 8),
              
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Unknown',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
                    
//                     Text(
//                       comment.content,
//                       style: theme.textTheme.bodyMedium,
//                     ),
                    
//                     if (comment.attachments.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: SizedBox(
//                           height: 150,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: comment.attachments.length,
//                             itemBuilder: (context, index) {
//                               final attachment = comment.attachments[index];
//                               return GestureDetector(
//                                 onTap: () => _showMediaDialog(context, attachment),
//                                 child: Container(
//                                   width: 150,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: theme.cardColor,
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: attachment.isImage
//                                         ? Image.network(
//                                             attachment.url,
//                                             fit: BoxFit.cover,
//                                             loadingBuilder: (context, child, loadingProgress) {
//                                               if (loadingProgress == null) return child;
//                                               return Center(
//                                                 child: CircularProgressIndicator(
//                                                   value: loadingProgress.expectedTotalBytes != null
//                                                       ? loadingProgress.cumulativeBytesLoaded /
//                                                           loadingProgress.expectedTotalBytes!
//                                                       : null,
//                                                 ),
//                                               );
//                                             },
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return const Center(
//                                                 child: Icon(Icons.broken_image),
//                                               );
//                                             },
//                                           )
//                                         : Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               if (attachment.thumbnailUrl != null)
//                                                 Image.network(
//                                                   attachment.thumbnailUrl!,
//                                                   fit: BoxFit.cover,
//                                                   width: 150,
//                                                   height: 150,
//                                                 ),
//                                               const Icon(Icons.play_circle_fill, 
//                                                 size: 50, 
//                                                 color: Colors.white70),
//                                             ],
//                                           ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
                    
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                               size: 20,
//                               color: comment.isLiked ? Colors.red : theme.iconTheme.color,
//                             ),
//                             onPressed: onLike,
//                           ),
//                           Text(
//                             comment.likeCount.toString(),
//                             style: theme.textTheme.bodySmall,
//                           ),
//                           const SizedBox(width: 8),
//                           TextButton(
//                             onPressed: onReply,
//                             child: Text(
//                               'Reply',
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                           if (isOwner) ...[
//                             const Spacer(),
//                             TextButton(
//                               onPressed: onEdit,
//                               child: Text(
//                                 'Edit',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: theme.colorScheme.primary,
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: onDelete,
//                               child: Text(
//                                 'Delete',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           if (comment.replies.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(left: 48.0, top: 8),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 2,
//                     height: 8,
//                     color: Colors.grey[300],
//                     margin: const EdgeInsets.only(left: 20),
//                   ),
//                   ...comment.replies.map((reply) => CommentTile(
//                     comment: reply,
//                     isOwner: isOwner,
//                     formatDate: formatDate,
//                     onLike: onLike,
//                     onReply: onReply,
//                     onEdit: onEdit,
//                     onDelete: onDelete,
//                   )).toList(),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: attachment.isImage
//               ? InteractiveViewer(
//                   child: Image.network(
//                     attachment.url,
//                     fit: BoxFit.contain,
//                   ),
//                 )
//               : VideoPlayerWidget(videoUrl: attachment.url),
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     // ignore: deprecated_member_use
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               IconButton(
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 50,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isPlaying = !_isPlaying;
//                     _isPlaying ? _controller.play() : _controller.pause();
//                   });
//                 },
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Hero(
//             tag: imageUrl,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(Icons.error, color: Colors.white),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


















//working code 13-8-25

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 10;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _scrollController.addListener(_scrollListener);
//     _focusNode.addListener(_onFocusChange);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus && _showEmojiPicker) {
//       setState(() => _showEmojiPicker = false);
//     }
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >= 
//         _scrollController.position.maxScrollExtent - 100) {
//       if (!_isLoading && _hasMore) {
//         _loadComments();
//       }
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error loading comments: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please add content or media")),
//         );
//       }
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("You need to be logged in to comment")),
//         );
//       }
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_editingComment != null) {
//         comment = await NetworkService.updateComment(
//           commentToken: _editingComment!.commentToken,
//           content: content,
//           userToken: authProvider.user!.userToken,
//         );
        
//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = comment;
//           }
//         });
//       } else if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//         _comments.insert(0, comment);
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//         _comments.insert(0, comment);
//       }

//       if (mounted) {
//         setState(() {
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error posting comment: ${e.toString()}")),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Media size should be less than 50MB")),
//             );
//           }
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("You can only attach up to 5 files")),
//             );
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error picking media: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error taking photo: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Video size should be less than 50MB")),
//             );
//           }
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error recording video: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png');

//     return Container(
//       width: 100,
//       height: 100,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.grey[200],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   const Icon(Icons.videocam, size: 40),
//                   FutureBuilder<Duration>(
//                     future: _getVideoDuration(file),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         final duration = snapshot.data!;
//                         return Positioned(
//                           bottom: 4,
//                           right: 4,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: Colors.black54,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Future<Duration> _getVideoDuration(File file) async {
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     final duration = controller.value.duration;
//     await controller.dispose();
//     return duration;
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Photo Library'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickMedia();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Take Photo'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickImageFromCamera();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.videocam),
//               title: const Text('Record Video'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickVideoFromCamera();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.close),
//               title: const Text('Cancel'),
//               onTap: () => Navigator.pop(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error toggling like: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Comment"),
//         content: const Text("Are you sure you want to delete this comment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error deleting comment: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildInputField() {
//     final theme = Theme.of(context);
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           if (_replyingTo != null || _editingComment != null)
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, bottom: 4),
//               child: Row(
//                 children: [
//                   Text(
//                     _editingComment != null 
//                         ? "Editing comment..." 
//                         : "Replying to ${_replyingTo ?? ''}",
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: theme.hintColor,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.close, size: 16),
//                     onPressed: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.emoji_emotions_outlined,
//                   color: theme.hintColor,
//                 ),
//                 onPressed: _toggleEmojiPicker,
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   focusNode: _focusNode,
//                   decoration: InputDecoration(
//                     hintText: _editingComment != null 
//                         ? "Edit your comment..." 
//                         : "Type a message...",
//                     hintStyle: TextStyle(color: theme.hintColor),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//                   ),
//                   maxLines: null,
//                   style: theme.textTheme.bodyMedium,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.attach_file, 
//                   color: theme.hintColor,
//                 ),
//                 onPressed: _showMediaOptions,
//               ),
//               const SizedBox(width: 4),
//               _isPosting
//                   ? const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                     )
//                   : IconButton(
//                       icon: Icon(
//                         Icons.send,
//                         color: theme.colorScheme.primary,
//                       ),
//                       onPressed: _postComment,
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         setState(() => _showEmojiPicker = !_showEmojiPicker);
//       });
//     }
//   }

// @override
// Widget build(BuildContext context) {
//   final authProvider = context.watch<AuthProvider>();
//   Theme.of(context);

//   return Column(
//     children: [
//       // Remove the Expanded widget and use SizedBox with fixed height instead
//       SizedBox(
//         height: 400, // Set a fixed height for the comments list
//         child: RefreshIndicator(
//           onRefresh: () async {
//             setState(() {
//               _page = 1;
//               _hasMore = true;
//             });
//             await _loadComments();
//           },
//           child: ListView.builder(
//             controller: _scrollController,
//             itemCount: _comments.length + (_hasMore ? 1 : 0),
//             padding: const EdgeInsets.only(bottom: 8),
//             itemBuilder: (context, index) {
//               if (index == _comments.length) {
//                 return _hasMore
//                     ? const Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Center(child: CircularProgressIndicator()),
//                       )
//                     : const SizedBox.shrink();
//               }

//               final comment = _comments[index];
//               final isOwner = authProvider.user?.userToken == comment.userToken;

//               return CommentTile(
//                 comment: comment,
//                 isOwner: isOwner,
//                 formatDate: _formatDate,
//                 onLike: () => _toggleLike(comment),
//                 onReply: () => _startReply(comment),
//                 onEdit: isOwner ? () => _startEdit(comment) : null,
//                 onDelete: isOwner ? () => _deleteComment(comment) : null,
//               );
//             },
//           ),
//         ),
//       ),

//       if (_selectedMedia.isNotEmpty)
//         SizedBox(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//             itemCount: _selectedMedia.length,
//             itemBuilder: (context, index) {
//               return Stack(
//                 children: [
//                   _buildMediaPreview(_selectedMedia[index]),
//                   Positioned(
//                     top: 4,
//                     right: 4,
//                     child: GestureDetector(
//                       onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.black54,
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           size: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),

//       Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//           left: 8,
//           right: 8,
//         ),
//         child: Column(
//           children: [
//             _buildInputField(),
//             if (_showEmojiPicker)
//               SizedBox(
//                 height: 250,
//                 child: EmojiPicker(
//                   onEmojiSelected: (category, emoji) {
//                     _controller.text = _controller.text + emoji.emoji;
//                   },
//                   config: const Config(
//                     emojiViewConfig: EmojiViewConfig(
//                       emojiSizeMax: 32,
//                     ),
//                     skinToneConfig: SkinToneConfig(),
//                     categoryViewConfig: CategoryViewConfig(),
//                     bottomActionBarConfig: BottomActionBarConfig(),
//                     searchViewConfig: SearchViewConfig(),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
// }


// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                     ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                     : null,
//                 child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                     ? Text(comment.userName != null && comment.userName!.isNotEmpty
//                         ? comment.userName![0].toUpperCase()
//                         : '?')
//                     : null,
//               ),
//               const SizedBox(width: 8),
              
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Unknown',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.hintColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
                    
//                     Text(
//                       comment.content,
//                       style: theme.textTheme.bodyMedium,
//                     ),
                    
//                     if (comment.attachments.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8),
//                         child: SizedBox(
//                           height: 150,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: comment.attachments.length,
//                             itemBuilder: (context, index) {
//                               final attachment = comment.attachments[index];
//                               return GestureDetector(
//                                 onTap: () => _showMediaDialog(context, attachment),
//                                 child: Container(
//                                   width: 150,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: theme.cardColor,
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: attachment.isImage
//                                         ? Image.network(
//                                             attachment.url,
//                                             fit: BoxFit.cover,
//                                             loadingBuilder: (context, child, loadingProgress) {
//                                               if (loadingProgress == null) return child;
//                                               return Center(
//                                                 child: CircularProgressIndicator(
//                                                   value: loadingProgress.expectedTotalBytes != null
//                                                       ? loadingProgress.cumulativeBytesLoaded /
//                                                           loadingProgress.expectedTotalBytes!
//                                                       : null,
//                                                 ),
//                                               );
//                                             },
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return const Center(
//                                                 child: Icon(Icons.broken_image),
//                                               );
//                                             },
//                                           )
//                                         : Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               if (attachment.thumbnailUrl != null)
//                                                 Image.network(
//                                                   attachment.thumbnailUrl!,
//                                                   fit: BoxFit.cover,
//                                                   width: 150,
//                                                   height: 150,
//                                                 ),
//                                               const Icon(Icons.play_circle_fill, 
//                                                 size: 50, 
//                                                 color: Colors.white70),
//                                             ],
//                                           ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
                    
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Row(
//                         children: [
//                           IconButton(
//                             icon: Icon(
//                               comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                               size: 20,
//                               color: comment.isLiked ? Colors.red : theme.iconTheme.color,
//                             ),
//                             onPressed: onLike,
//                           ),
//                           Text(
//                             comment.likeCount.toString(),
//                             style: theme.textTheme.bodySmall,
//                           ),
//                           const SizedBox(width: 8),
//                           TextButton(
//                             onPressed: onReply,
//                             child: Text(
//                               'Reply',
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ),
//                           ),
//                           if (isOwner) ...[
//                             const Spacer(),
//                             TextButton(
//                               onPressed: onEdit,
//                               child: Text(
//                                 'Edit',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: theme.colorScheme.primary,
//                                 ),
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: onDelete,
//                               child: Text(
//                                 'Delete',
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           if (comment.replies.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(left: 48.0, top: 8),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 2,
//                     height: 8,
//                     color: Colors.grey[300],
//                     margin: const EdgeInsets.only(left: 20),
//                   ),
//                   ...comment.replies.map((reply) => CommentTile(
//                     comment: reply,
//                     isOwner: isOwner,
//                     formatDate: formatDate,
//                     onLike: onLike,
//                     onReply: onReply,
//                     onEdit: onEdit,
//                     onDelete: onDelete,
//                   )),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(16),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: attachment.isImage
//               ? InteractiveViewer(
//                   child: Image.network(
//                     attachment.url,
//                     fit: BoxFit.contain,
//                   ),
//                 )
//               : VideoPlayerWidget(videoUrl: attachment.url),
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//               IconButton(
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   size: 50,
//                   color: Colors.white.withOpacity(0.8),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isPlaying = !_isPlaying;
//                     _isPlaying ? _controller.play() : _controller.pause();
//                   });
//                 },
//               ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Hero(
//             tag: imageUrl,
//             child: Image.network(
//               imageUrl,
//               fit: BoxFit.contain,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return const Center(
//                   child: Icon(Icons.error, color: Colors.white),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
















// //claude ai 14-8-25


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 10;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
  
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _scrollController.addListener(_scrollListener);
//     _focusNode.addListener(_onFocusChange);
    
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus && _showEmojiPicker) {
//       setState(() => _showEmojiPicker = false);
//     }
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >= 
//         _scrollController.position.maxScrollExtent - 100) {
//       if (!_isLoading && _hasMore) {
//         _loadComments();
//       }
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error loading comments: ${e.toString()}");
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       if (mounted) {
//         _showErrorSnackBar("Please add content or media");
//       }
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       if (mounted) {
//         _showErrorSnackBar("You need to be logged in to comment");
//       }
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_editingComment != null) {
//         comment = await NetworkService.updateComment(
//           commentToken: _editingComment!.commentToken,
//           content: content,
//           userToken: authProvider.user!.userToken,
//         );
        
//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = comment;
//           }
//         });
//       } else if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//         _comments.insert(0, comment);
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//         _comments.insert(0, comment);
//       }

//       if (mounted) {
//         setState(() {
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
//         _showSuccessSnackBar("Comment posted successfully!");
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error posting comment: ${e.toString()}");
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           if (mounted) {
//             _showErrorSnackBar("Media size should be less than 50MB");
//           }
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             _showErrorSnackBar("You can only attach up to 5 files");
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error picking media: ${e.toString()}");
//       }
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error taking photo: ${e.toString()}");
//       }
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           if (mounted) {
//             _showErrorSnackBar("Video size should be less than 50MB");
//           }
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error recording video: ${e.toString()}");
//       }
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png');

//     return Container(
//       width: 80,
//       height: 80,
//       margin: const EdgeInsets.only(right: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey[50],
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.purple.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
//                       ),
//                     ),
//                   ),
//                   const Icon(Icons.videocam_rounded, size: 32, color: Color(0xFF6366F1)),
//                   FutureBuilder<Duration>(
//                     future: _getVideoDuration(file),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         final duration = snapshot.data!;
//                         return Positioned(
//                           bottom: 6,
//                           right: 6,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.7),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(
//                               '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                       return const SizedBox();
//                     },
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Future<Duration> _getVideoDuration(File file) async {
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     final duration = controller.value.duration;
//     await controller.dispose();
//     return duration;
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(top: 12, bottom: 24),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture a moment',
//                 gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFEF4444)]),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture a video',
//                 gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   width: 48,
//                   height: 48,
//                   decoration: BoxDecoration(
//                     gradient: gradient,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: Colors.white, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error toggling like: ${e.toString()}");
//       }
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Delete Comment", style: TextStyle(fontWeight: FontWeight.w600)),
//         content: const Text("Are you sure you want to delete this comment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFEF4444),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text("Delete", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSuccessSnackBar("Comment deleted successfully");
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar("Error deleting comment: ${e.toString()}");
//       }
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);
      
//       if (difference.inDays > 0) {
//         return '${difference.inDays}d ago';
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inMinutes > 0) {
//         return '${difference.inMinutes}m ago';
//       } else {
//         return 'now';
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildInputField() {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           if (_replyingTo != null || _editingComment != null)
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6366F1).withOpacity(0.05),
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _editingComment != null ? Icons.edit_rounded : Icons.reply_rounded,
//                     size: 16,
//                     color: const Color(0xFF6366F1),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _editingComment != null 
//                         ? "Editing comment..." 
//                         : "Replying to @${_replyingTo ?? ''}",
//                     style: const TextStyle(
//                       color: Color(0xFF6366F1),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.close_rounded, size: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(4),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: _toggleEmojiPicker,
//                   child: Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: _showEmojiPicker ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     child: Icon(
//                       Icons.emoji_emotions_rounded,
//                       color: _showEmojiPicker ? const Color(0xFF6366F1) : Colors.grey[500],
//                       size: 22,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     focusNode: _focusNode,
//                     decoration: InputDecoration(
//                       hintText: _editingComment != null 
//                           ? "Edit your comment..." 
//                           : "What's on your mind?",
//                       hintStyle: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     maxLines: null,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: _showMediaOptions,
//                   child: Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                     child: Icon(
//                       Icons.attach_file_rounded,
//                       color: Colors.grey[600],
//                       size: 20,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 _isPosting
//                     ? Container(
//                         width: 44,
//                         height: 44,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF6366F1).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(22),
//                         ),
//                         child: const Center(
//                           child: SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Color(0xFF6366F1),
//                             ),
//                           ),
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: _postComment,
//                         child: Container(
//                           width: 44,
//                           height: 44,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                             ),
//                             borderRadius: BorderRadius.circular(22),
//                           ),
//                           child: const Icon(
//                             Icons.send_rounded,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         setState(() => _showEmojiPicker = !_showEmojiPicker);
//       });
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFFEF4444),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFFFAFAFA),
//         ),
//         child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.chat_rounded, color: Colors.white, size: 20),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Comments',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1F2937),
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     '${_comments.length}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Comments List
//                         ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: MediaQuery.of(context).size.height - 200, // Adjust as needed
//               ),
//               child: RefreshIndicator(
//                 onRefresh: () async {
//                   setState(() {
//                     _page = 1;
//                     _hasMore = true;
//                   });
//                   await _loadComments();
//                 },
//                 color: const Color(0xFF6366F1),
//                 child: _comments.isEmpty && !_isLoading
//                     ? _buildEmptyState()
//                     : ListView.builder(
//                                 shrinkWrap: true, // Important
//           physics: const NeverScrollableScrollPhysics(), // Important
//                         controller: _scrollController,
//                         itemCount: _comments.length + (_hasMore ? 1 : 0),
//                         padding: const EdgeInsets.only(top: 8, bottom: 100),
//                         itemBuilder: (context, index) {
//                           if (index == _comments.length) {
//                             return _hasMore
//                                 ? const Padding(
//                                     padding: EdgeInsets.all(16),
//                                     child: Center(
//                                       child: CircularProgressIndicator(
//                                         color: Color(0xFF6366F1),
//                                       ),
//                                     ),
//                                   )
//                                 : const SizedBox.shrink();
//                           }

//                           final comment = _comments[index];
//                           final isOwner = authProvider.user?.userToken == comment.userToken;

//                           return ModernCommentTile(
//                             comment: comment,
//                             isOwner: isOwner,
//                             formatDate: _formatDate,
//                             onLike: () => _toggleLike(comment),
//                             onReply: () => _startReply(comment),
//                             onEdit: isOwner ? () => _startEdit(comment) : null,
//                             onDelete: isOwner ? () => _deleteComment(comment) : null,
//                           );
//                         },
//                       ),
//               ),
//             ),

//             // Media Preview
//             if (_selectedMedia.isNotEmpty)
//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       child: Text(
//                         'Media attachments',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 100,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: _selectedMedia.length,
//                         itemBuilder: (context, index) {
//                           return Stack(
//                             children: [
//                               _buildMediaPreview(_selectedMedia[index]),
//                               Positioned(
//                                 top: -4,
//                                 right: 4,
//                                 child: GestureDetector(
//                                   onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                                   child: Container(
//                                     width: 24,
//                                     height: 24,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xFFEF4444),
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black26,
//                                           blurRadius: 4,
//                                           offset: Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: const Icon(
//                                       Icons.close_rounded,
//                                       size: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//                 ),
//               ),

//             // Input Section
//             Container(
//               color: Colors.white,
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//               ),
//               child: Column(
//                 children: [
//                   _buildInputField(),
//                   if (_showEmojiPicker)
//                     Container(
//                       height: 280,
//                       margin: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 16,
//                             offset: const Offset(0, -4),
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: EmojiPicker(
//                           onEmojiSelected: (category, emoji) {
//                             _controller.text = _controller.text + emoji.emoji;
//                           },
//                           config: const Config(
//                             emojiViewConfig: EmojiViewConfig(
//                               emojiSizeMax: 28,
//                               backgroundColor: Colors.white,
//                               columns: 7,
//                               verticalSpacing: 0,
//                               horizontalSpacing: 0,
//                             ),
//                             skinToneConfig: SkinToneConfig(),
//                             categoryViewConfig: CategoryViewConfig(
//                               backgroundColor: Colors.white,
//                               iconColor: Color(0xFF6B7280),
//                               iconColorSelected: Color(0xFF6366F1),
//                               indicatorColor: Color(0xFF6366F1),
//                             ),
//                             bottomActionBarConfig: BottomActionBarConfig(
//                               backgroundColor: Colors.white,
//                               buttonColor: Color(0xFF6366F1),
//                             ),
//                             searchViewConfig: SearchViewConfig(
//                               backgroundColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//       );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   const Color(0xFF6366F1).withOpacity(0.1),
//                   const Color(0xFF8B5CF6).withOpacity(0.1),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(40),
//             ),
//             child: const Icon(
//               Icons.chat_bubble_outline_rounded,
//               size: 40,
//               color: Color(0xFF6366F1),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No comments yet',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF374151),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Be the first to share your thoughts!',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ModernCommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const ModernCommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   Widget _buildAvatarFallback() {
//     return Container(
//       width: 44,
//       height: 44,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//         ),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Center(
//         child: Text(
//           comment.userName != null && comment.userName!.isNotEmpty
//               ? comment.userName![0].toUpperCase()
//               : '?',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12), // FIXED padding error
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Avatar
//             comment.userPhoto != null
//                 ? ClipRRect(
//                     borderRadius: BorderRadius.circular(22),
//                     child: Image.network(
//                       comment.userPhoto!,
//                       width: 44,
//                       height: 44,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 : _buildAvatarFallback(),
//             const SizedBox(width: 12),

//             // Comment Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         comment.userName ?? 'Unknown',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       if (isOwner)
//                         Container(
//                           margin: const EdgeInsets.only(left: 8),
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Text(
//                             'You',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFFD97706),
//                             ),
//                           ),
//                         ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           formatDate(comment.createdAt),
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),

//                   // Comment text
//                   Text(
//                     comment.content,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF374151),
//                       height: 1.4,
//                     ),
//                   ),

//                   // Attachments
//                   if (comment.attachments.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 12),
//                       child: SizedBox(
//                         height: 120,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: comment.attachments.length,
//                           itemBuilder: (context, index) {
//                             final attachment = comment.attachments[index];
//                             return GestureDetector(
//                               onTap: () => _showMediaDialog(context, attachment),
//                               child: Container(
//                                 width: 120,
//                                 margin: const EdgeInsets.only(right: 12),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: attachment.isImage
//                                       ? Image.network(
//                                           attachment.url,
//                                           fit: BoxFit.cover,
//                                           loadingBuilder: (context, child, progress) {
//                                             if (progress == null) return child;
//                                             return Container(
//                                               color: Colors.grey[100],
//                                               child: Center(
//                                                 child: CircularProgressIndicator(
//                                                   value: progress.expectedTotalBytes != null
//                                                       ? progress.cumulativeBytesLoaded /
//                                                           progress.expectedTotalBytes!
//                                                       : null,
//                                                   color: const Color(0xFF6366F1),
//                                                   strokeWidth: 2,
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return Container(
//                                               color: Colors.grey[100],
//                                               child: const Center(
//                                                 child: Icon(Icons.broken_image_rounded, color: Colors.grey),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       : Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             if (attachment.thumbnailUrl != null)
//                                               Image.network(
//                                                 attachment.thumbnailUrl!,
//                                                 fit: BoxFit.cover,
//                                                 width: 120,
//                                                 height: 120,
//                                               )
//                                             else
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   gradient: LinearGradient(
//                                                     colors: [
//                                                       Colors.purple.withOpacity(0.1),
//                                                       Colors.blue.withOpacity(0.1)
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             Container(
//                                               width: 40,
//                                               height: 40,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black.withOpacity(0.7),
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: const Icon(
//                                                 Icons.play_arrow_rounded,
//                                                 size: 24,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),

//                   const SizedBox(height: 12),

//                   // Like / Reply / Menu
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: onLike,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: comment.isLiked
//                                 ? const Color(0xFFEF4444).withOpacity(0.1)
//                                 : Colors.grey[50],
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: comment.isLiked
//                                   ? const Color(0xFFEF4444).withOpacity(0.3)
//                                   : Colors.grey[200]!,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 comment.isLiked
//                                     ? Icons.favorite_rounded
//                                     : Icons.favorite_border_rounded,
//                                 size: 16,
//                                 color: comment.isLiked
//                                     ? const Color(0xFFEF4444)
//                                     : Colors.grey[600],
//                               ),
//                               if (comment.likeCount > 0) ...[
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   comment.likeCount.toString(),
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                     color: comment.isLiked
//                                         ? const Color(0xFFEF4444)
//                                         : Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//                         onTap: onReply,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF6366F1).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: const Color(0xFF6366F1).withOpacity(0.3),
//                             ),
//                           ),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.reply_rounded,
//                                 size: 16,
//                                 color: Color(0xFF6366F1),
//                               ),
//                               SizedBox(width: 4),
//                               Text(
//                                 'Reply',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF6366F1),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (isOwner) ...[
//                         const Spacer(),
//                         PopupMenuButton<String>(
//                           onSelected: (value) {
//                             if (value == 'edit') {
//                               onEdit?.call();
//                             } else if (value == 'delete') {
//                               onDelete?.call();
//                             }
//                           },
//                           icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[500], size: 20),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           itemBuilder: (context) => [
//                             const PopupMenuItem(
//                               value: 'edit',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.edit_rounded, size: 18, color: Color(0xFF6366F1)),
//                                   SizedBox(width: 8),
//                                   Text('Edit', style: TextStyle(fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                             ),
//                             const PopupMenuItem(
//                               value: 'delete',
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.delete_rounded, size: 18, color: Color(0xFFEF4444)),
//                                   SizedBox(width: 8),
//                                   Text('Delete', style: TextStyle(fontWeight: FontWeight.w500)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),

//                   // Replies
//                   if (comment.replies.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(left: 32, top: 12),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 2,
//                             height: 12,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                               ),
//                               borderRadius: BorderRadius.circular(1),
//                             ),
//                             margin: const EdgeInsets.only(left: 22, bottom: 8),
//                           ),
//                           ...comment.replies.map((reply) => ModernCommentTile(
//                                 comment: reply,
//                                 isOwner: isOwner,
//                                 formatDate: formatDate,
//                                 onLike: onLike,
//                                 onReply: onReply,
//                                 onEdit: onEdit,
//                                 onDelete: onDelete,
//                               )),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             Center(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width - 40,
//                   maxHeight: MediaQuery.of(context).size.height - 100,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: attachment.isImage
//                       ? InteractiveViewer(
//                           child: Image.network(
//                             attachment.url,
//                             fit: BoxFit.contain,
//                           ),
//                         )
//                       : VideoPlayerWidget(videoUrl: attachment.url),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initializeVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _isPlaying = !_isPlaying;
//                       _isPlaying ? _controller.play() : _controller.pause();
//                     });
//                   },
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.7),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                       size: 32,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Center(
//               child: CircularProgressIndicator(color: Color(0xFF6366F1)),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Hero(
//             tag: imageUrl,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null,
//                         color: const Color(0xFF6366F1),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Center(
//                       child: Icon(Icons.error_rounded, color: Colors.white),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
































// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 20; // Load more comments at once since we're not scrolling
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
//   late AnimationController _inputAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _focusNode.addListener(_onFocusChange);
//     _inputAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _inputAnimationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _inputAnimationController.forward();
//       if (_showEmojiPicker) {
//         setState(() => _showEmojiPicker = false);
//       }
//     } else {
//       _inputAnimationController.reverse();
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text("Error loading comments: ${e.toString()}"),
//               ],
//             ),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _loadMoreComments() async {
//     if (_hasMore && !_isLoading) {
//       await _loadComments();
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       _showSnackBar("Please add content or media", isError: true);
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       _showSnackBar("You need to be logged in to comment", isError: true);
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_editingComment != null) {
//         comment = await NetworkService.updateComment(
//           commentToken: _editingComment!.commentToken,
//           content: content,
//           userToken: authProvider.user!.userToken,
//         );
        
//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = comment;
//           }
//         });
//       } else if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//         _comments.insert(0, comment);
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//         _comments.insert(0, comment);
//       }

//       if (mounted) {
//         setState(() {
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
        
//         _showSnackBar(
//           _editingComment != null ? "Comment updated!" : "Comment posted!",
//           isError: false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   void _showSnackBar(String message, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Media size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             _showSnackBar("You can only attach up to 5 files", isError: true);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error picking media: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Video size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error recording video: ${e.toString()}", isError: true);
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png') ||
//         file.path.toLowerCase().endsWith('.gif') ||
//         file.path.toLowerCase().endsWith('.webp');

//     return Container(
//       width: 100,
//       height: 100,
//       margin: const EdgeInsets.only(right: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Container(
//                 color: const Color(0xFF374151),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const Icon(Icons.videocam_rounded, size: 40, color: Colors.white),
//                     FutureBuilder<Duration>(
//                       future: _getVideoDuration(file),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final duration = snapshot.data!;
//                           return Positioned(
//                             bottom: 8,
//                             right: 8,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.7),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Text(
//                                 '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<Duration> _getVideoDuration(File file) async {
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     final duration = controller.value.duration;
//     await controller.dispose();
//     return duration;
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//                 color: const Color(0xFF3B82F6),
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture with camera',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//                 color: const Color(0xFF10B981),
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture video',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//                 color: const Color(0xFFE53E3E),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: color.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           "Delete Comment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("Are you sure you want to delete this comment? This action cannot be undone."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFE53E3E), Color(0xFFDC2626)],
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text("Delete", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSnackBar("Comment deleted successfully", isError: false);
//       }
//     } catch (e) {
//       _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);

//       if (difference.inMinutes < 1) {
//         return 'Just now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m ago';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d ago';
//       } else {
//         return DateFormat('MMM dd, yyyy').format(dt);
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildInputField() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOutCubic,
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(_focusNode.hasFocus ? 0.15 : 0.05),
//             blurRadius: _focusNode.hasFocus ? 20 : 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: _focusNode.hasFocus 
//               ? const Color(0xFF8B5CF6).withOpacity(0.3)
//               : Colors.transparent,
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           if (_replyingTo != null || _editingComment != null)
//             Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _editingComment != null 
//                         ? Icons.edit_rounded 
//                         : Icons.reply_rounded,
//                     size: 16,
//                     color: const Color(0xFF8B5CF6),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _editingComment != null 
//                           ? "Editing comment..." 
//                           : "Replying to ${_replyingTo ?? ''}",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF8B5CF6),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF8B5CF6).withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(
//                         Icons.close_rounded,
//                         size: 16,
//                         color: Color(0xFF8B5CF6),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Row(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF3F4F6),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   icon: Icon(
//                     _showEmojiPicker 
//                         ? Icons.keyboard_rounded 
//                         : Icons.emoji_emotions_rounded,
//                     color: const Color(0xFF6B7280),
//                   ),
//                   onPressed: _toggleEmojiPicker,
//                 ),
//               ),
//               const SizedBox(width: 12),
//              Expanded(
//   child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), // reduced vertical padding
//     decoration: BoxDecoration(
//       color: const Color(0xFFF9FAFB),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: TextField(
//       controller: _controller,
//       focusNode: _focusNode,
//       maxLines: 1, // keep it horizontal
//       decoration: InputDecoration(
//         hintText: _editingComment != null
//             ? "Edit your comment..."
//             : "Share your thoughts...",
//         hintStyle: TextStyle(
//           color: Colors.grey[500],
//           fontSize: 16,
//         ),
//         border: InputBorder.none,
//         isDense: true, // helps keep height compact
//         contentPadding: const EdgeInsets.symmetric(vertical: 8), // balanced
//       ),
//       style: const TextStyle(
//         fontSize: 16,
//         color: Color(0xFF1F2937),
//       ),
//     ),
//   ),
// ),

//               const SizedBox(width: 12),
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF3F4F6),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.attach_file_rounded,
//                     color: Color(0xFF6B7280),
//                   ),
//                   onPressed: _showMediaOptions,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               _isPosting
//                   ? Container(
//                       padding: const EdgeInsets.all(12),
//                       child: const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                         ),
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.send_rounded,
//                           color: Colors.white,
//                         ),
//                         onPressed: _postComment,
//                       ),
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           setState(() => _showEmojiPicker = !_showEmojiPicker);
//         }
//       });
//     }
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.all(40),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFF8B5CF6).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Icon(
//               Icons.chat_bubble_outline_rounded,
//               size: 48,
//               color: Color(0xFF8B5CF6),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'No comments yet',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Be the first to share your thoughts!',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();

//     return Column(
//       children: [
//         // Non-scrollable comments list
//         if (_comments.isEmpty && !_isLoading)
//           _buildEmptyState()
//         else
//           Column(
//             children: [
//               // Display all comments without scrolling
//               ..._comments.map((comment) {
//                 final isOwner = authProvider.user?.userToken == comment.userToken;
//                 return CommentTile(
//                   comment: comment,
//                   isOwner: isOwner,
//                   formatDate: _formatDate,
//                   onLike: () => _toggleLike(comment),
//                   onReply: () => _startReply(comment),
//                   onEdit: isOwner ? () => _startEdit(comment) : null,
//                   onDelete: isOwner ? () => _deleteComment(comment) : null,
//                 );
//               }).toList(),
              
//               // Load more button if there are more comments
//               if (_hasMore)
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
//                           ),
//                         )
//                       : TextButton.icon(
//                           onPressed: _loadMoreComments,
//                           icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF8B5CF6)),
//                           label: const Text(
//                             'Load More Comments',
//                             style: TextStyle(
//                               color: Color(0xFF8B5CF6),
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           style: TextButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                             backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                 ),
//             ],
//           ),

//         // Selected media preview
//         if (_selectedMedia.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Selected Media',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _selectedMedia.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           _buildMediaPreview(_selectedMedia[index]),
//                           Positioned(
//                             top: 4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.7),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.close_rounded,
//                                   size: 16,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // Input field at the bottom
//         Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 8,
//           ),
//           child: Column(
//             children: [
//               _buildInputField(),
//               if (_showEmojiPicker)
//                 Container(
//                   height: 250,
//                   margin: const EdgeInsets.only(top: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: EmojiPicker(
//                       onEmojiSelected: (category, emoji) {
//                         _controller.text = _controller.text + emoji.emoji;
//                       },
//                       config: const Config(
//                         emojiViewConfig: EmojiViewConfig(
//                           emojiSizeMax: 32,
//                         ),
//                         skinToneConfig: SkinToneConfig(),
//                         categoryViewConfig: CategoryViewConfig(),
//                         bottomActionBarConfig: BottomActionBarConfig(),
//                         searchViewConfig: SearchViewConfig(),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 20,
//                   backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                       ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                       : null,
//                   backgroundColor: const Color(0xFF8B5CF6),
//                   child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                       ? Text(
//                           comment.userName != null && comment.userName!.isNotEmpty
//                               ? comment.userName![0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//               const SizedBox(width: 12),
              
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Anonymous',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1F2937),
//                           ),
//                         ),
//                         if (isOwner) ...[
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Text(
//                               'YOU',
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                         const Spacer(),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
                    
//                     Text(
//                       comment.content,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         height: 1.4,
//                         color: Color(0xFF374151),
//                       ),
//                     ),
                    
//                     if (comment.attachments.isNotEmpty)
//                       Container(
//                         margin: const EdgeInsets.only(top: 12),
//                         height: 150,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: comment.attachments.length,
//                           itemBuilder: (context, index) {
//                             final attachment = comment.attachments[index];
//                             return GestureDetector(
//                               onTap: () => _showMediaDialog(context, attachment),
//                               child: Container(
//                                 width: 150,
//                                 margin: const EdgeInsets.only(right: 12),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: attachment.isImage
//                                       ? Hero(
//                                           tag: attachment.url,
//                                           child: Image.network(
//                                             attachment.url,
//                                             fit: BoxFit.cover,
//                                             loadingBuilder: (context, child, loadingProgress) {
//                                               if (loadingProgress == null) return child;
//                                               return Container(
//                                                 color: Colors.grey[100],
//                                                 child: Center(
//                                                   child: CircularProgressIndicator(
//                                                     value: loadingProgress.expectedTotalBytes != null
//                                                         ? loadingProgress.cumulativeBytesLoaded /
//                                                             loadingProgress.expectedTotalBytes!
//                                                         : null,
//                                                     strokeWidth: 2,
//                                                     valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             errorBuilder: (context, error, stackTrace) {
//                                               return Container(
//                                                 color: Colors.grey[100],
//                                                 child: const Center(
//                                                   child: Icon(Icons.broken_image, color: Colors.grey),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         )
//                                       : Container(
//                                           color: const Color(0xFF374151),
//                                           child: Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               if (attachment.thumbnailUrl != null)
//                                                 Image.network(
//                                                   attachment.thumbnailUrl!,
//                                                   fit: BoxFit.cover,
//                                                   width: 150,
//                                                   height: 150,
//                                                 ),
//                                               Container(
//                                                 padding: const EdgeInsets.all(12),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.black.withOpacity(0.5),
//                                                   borderRadius: BorderRadius.circular(20),
//                                                 ),
//                                                 child: const Icon(
//                                                   Icons.play_arrow_rounded,
//                                                   size: 32,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
                    
//                     Container(
//                       margin: const EdgeInsets.only(top: 12),
//                       child: Row(
//                         children: [
//                           GestureDetector(
//                             onTap: onLike,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: comment.isLiked 
//                                     ? const Color(0xFFE53E3E).withOpacity(0.1)
//                                     : Colors.grey[50],
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: comment.isLiked 
//                                       ? const Color(0xFFE53E3E).withOpacity(0.2)
//                                       : Colors.grey[200]!,
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     comment.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
//                                     size: 16,
//                                     color: comment.isLiked ? const Color(0xFFE53E3E) : Colors.grey[600],
//                                   ),
//                                   if (comment.likeCount > 0) ...[
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       comment.likeCount.toString(),
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500,
//                                         color: comment.isLiked ? const Color(0xFFE53E3E) : Colors.grey[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           GestureDetector(
//                             onTap: onReply,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color: const Color(0xFF8B5CF6).withOpacity(0.2),
//                                 ),
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.reply_rounded,
//                                     size: 16,
//                                     color: Color(0xFF8B5CF6),
//                                   ),
//                                   SizedBox(width: 4),
//                                   Text(
//                                     'Reply',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xFF8B5CF6),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           if (isOwner) ...[
//                             const Spacer(),
//                             PopupMenuButton<String>(
//                               icon: Icon(Icons.more_vert_rounded, size: 20, color: Colors.grey[600]),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                               offset: const Offset(0, 40),
//                               onSelected: (value) {
//                                 if (value == 'edit' && onEdit != null) {
//                                   onEdit!();
//                                 } else if (value == 'delete' && onDelete != null) {
//                                   onDelete!();
//                                 }
//                               },
//                               itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                   value: 'edit',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.edit_rounded, size: 18, color: Colors.grey[600]),
//                                       const SizedBox(width: 8),
//                                       const Text('Edit'),
//                                     ],
//                                   ),
//                                 ),
//                                 const PopupMenuItem(
//                                   value: 'delete',
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.delete_rounded, size: 18, color: Color(0xFFE53E3E)),
//                                       SizedBox(width: 8),
//                                       Text('Delete', style: TextStyle(color: Color(0xFFE53E3E))),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           if (comment.replies.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(left: 48, top: 12),
//               padding: const EdgeInsets.only(left: 16),
//               decoration: BoxDecoration(
//                 border: Border(
//                   left: BorderSide(
//                     color: Colors.grey[200]!,
//                     width: 2,
//                   ),
//                 ),
//               ),
//               child: Column(
//                 children: comment.replies.map((reply) => CommentTile(
//                   comment: reply,
//                   isOwner: isOwner,
//                   formatDate: formatDate,
//                   onLike: onLike,
//                   onReply: onReply,
//                   onEdit: onEdit,
//                   onDelete: onDelete,
//                 )).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: attachment.isImage
//                     ? Hero(
//                         tag: attachment.url,
//                         child: InteractiveViewer(
//                           child: Image.network(
//                             attachment.url,
//                             fit: BoxFit.contain,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 padding: const EdgeInsets.all(40),
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     value: loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                         : null,
//                                     valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     : VideoPlayerWidget(videoUrl: attachment.url),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
    
//     // Hide controls after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//       _showControls = true;
//     });

//     if (_isPlaying) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted && _isPlaying) {
//           setState(() => _showControls = false);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.black,
//               ),
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     VideoPlayer(_controller),
//                     if (_showControls)
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.3),
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     if (_showControls)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Icon(
//                             _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                             size: 48,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               padding: const EdgeInsets.all(40),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Hero(
//                   tag: imageUrl,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                           valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(Icons.error, color: Colors.white, size: 48),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






















//22-8-25



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 20;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
//   late AnimationController _inputAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _focusNode.addListener(_onFocusChange);
//     _inputAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _inputAnimationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _inputAnimationController.forward();
//       if (_showEmojiPicker) {
//         setState(() => _showEmojiPicker = false);
//       }
//     } else {
//       _inputAnimationController.reverse();
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text("Error loading comments: ${e.toString()}"),
//               ],
//             ),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _loadMoreComments() async {
//     if (_hasMore && !_isLoading) {
//       await _loadComments();
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       _showSnackBar("Please add content or media", isError: true);
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       _showSnackBar("You need to be logged in to comment", isError: true);
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_editingComment != null) {
//         comment = await NetworkService.updateComment(
//           commentToken: _editingComment!.commentToken,
//           content: content,
//           userToken: authProvider.user!.userToken,
//         );
        
//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = comment;
//           }
//         });
//       } else if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//         _comments.insert(0, comment);
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//         _comments.insert(0, comment);
//       }

//       if (mounted) {
//         setState(() {
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
        
//         _showSnackBar(
//           _editingComment != null ? "Comment updated!" : "Comment posted!",
//           isError: false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   void _showSnackBar(String message, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Media size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             _showSnackBar("You can only attach up to 5 files", isError: true);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error picking media: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Video size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error recording video: ${e.toString()}", isError: true);
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png') ||
//         file.path.toLowerCase().endsWith('.gif') ||
//         file.path.toLowerCase().endsWith('.webp');

//     return Container(
//       width: 80,
//       height: 80,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Container(
//                 color: const Color(0xFF374151),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const Icon(Icons.videocam_rounded, size: 32, color: Colors.white),
//                     FutureBuilder<Duration>(
//                       future: _getVideoDuration(file),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final duration = snapshot.data!;
//                           return Positioned(
//                             bottom: 4,
//                             right: 4,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.7),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<Duration> _getVideoDuration(File file) async {
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     final duration = controller.value.duration;
//     await controller.dispose();
//     return duration;
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//                 color: const Color(0xFF3B82F6),
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture with camera',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//                 color: const Color(0xFF10B981),
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture video',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//                 color: const Color(0xFFE53E3E),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: color.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           "Delete Comment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("Are you sure you want to delete this comment? This action cannot be undone."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFE53E3E), Color(0xFFDC2626)],
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text("Delete", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSnackBar("Comment deleted successfully", isError: false);
//       }
//     } catch (e) {
//       _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);

//       if (difference.inMinutes < 1) {
//         return 'Just now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m ago';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d ago';
//       } else {
//         return DateFormat('MMM dd, yyyy').format(dt);
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildInputField() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Column(
//         children: [
//           if (_replyingTo != null || _editingComment != null)
//             Container(
//               margin: const EdgeInsets.only(bottom: 8),
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _editingComment != null 
//                         ? Icons.edit_rounded 
//                         : Icons.reply_rounded,
//                     size: 16,
//                     color: Colors.grey[600],
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _editingComment != null 
//                           ? "Editing comment..." 
//                           : "Replying to ${_replyingTo ?? ''}",
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                     child: Icon(
//                       Icons.close,
//                       size: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: _toggleEmojiPicker,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   child: Icon(
//                     _showEmojiPicker 
//                         ? Icons.keyboard 
//                         : Icons.emoji_emotions_outlined,
//                     color: Colors.grey[600],
//                     size: 24,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   child: TextField(
//                     controller: _controller,
//                     focusNode: _focusNode,
//                     maxLines: null,
//                     minLines: 1,
//                     decoration: InputDecoration(
//                       hintText: _editingComment != null
//                           ? "Edit your comment..."
//                           : "Type a message...",
//                       hintStyle: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 16,
//                       ),
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: _showMediaOptions,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   child: Icon(
//                     Icons.attach_file,
//                     color: Colors.grey[600],
//                     size: 24,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 4),
//               _isPosting
//                   ? Container(
//                       padding: const EdgeInsets.all(8),
//                       child: const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25D366)),
//                         ),
//                       ),
//                     )
//                   : GestureDetector(
//                       onTap: _postComment,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           // color: Color(0xFF25D366),
//                           color: Theme.of(context).primaryColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.send,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           setState(() => _showEmojiPicker = !_showEmojiPicker);
//         }
//       });
//     }
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: const EdgeInsets.all(32),
//       child: Column(
//         children: [
//           Icon(
//             Icons.chat_bubble_outline,
//             size: 48,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No comments yet',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Be the first to share your thoughts!',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();

//     return Column(
//       children: [
//         // Selected media preview - full width
//         if (_selectedMedia.isNotEmpty)
//           Container(
//             width: double.infinity,
//             color: Colors.grey[50],
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Selected Media',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 80,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _selectedMedia.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           _buildMediaPreview(_selectedMedia[index]),
//                           Positioned(
//                             top: -4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                               child: Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 12,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // Comments list - no containers, full width
//         if (_comments.isEmpty && !_isLoading)
//           _buildEmptyState()
//         else
//           Column(
//             children: [
//               ..._comments.map((comment) {
//                 final isOwner = authProvider.user?.userToken == comment.userToken;
//                 return CommentTile(
//                   comment: comment,
//                   isOwner: isOwner,
//                   formatDate: _formatDate,
//                   onLike: () => _toggleLike(comment),
//                   onReply: () => _startReply(comment),
//                   onEdit: isOwner ? () => _startEdit(comment) : null,
//                   onDelete: isOwner ? () => _deleteComment(comment) : null,
//                 );
//               }).toList(),
              
//               if (_hasMore)
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   child: _isLoading
//                       ? const Center(
//                           child: SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25D366)),
//                             ),
//                           ),
//                         )
//                       : TextButton(
//                           onPressed: _loadMoreComments,
//                           child: Text(
//                             'Load More Comments',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                 ),
//             ],
//           ),

//         // Input field at bottom - full width
//         _buildInputField(),

//         // Emoji picker
//         if (_showEmojiPicker)
//           Container(
//             height: 250,
//             width: double.infinity,
//             color: Colors.white,
//             child: EmojiPicker(
//               onEmojiSelected: (category, emoji) {
//                 _controller.text = _controller.text + emoji.emoji;
//               },
//               config: const Config(
//                 emojiViewConfig: EmojiViewConfig(
//                   emojiSizeMax: 28,
//                 ),
//                 skinToneConfig: SkinToneConfig(),
//                 categoryViewConfig: CategoryViewConfig(),
//                 bottomActionBarConfig: BottomActionBarConfig(),
//                 searchViewConfig: SearchViewConfig(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 radius: 18,
//                 backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                     ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                     : null,
//                 backgroundColor: Colors.grey[300],
//                 child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                     ? Text(
//                         comment.userName != null && comment.userName!.isNotEmpty
//                             ? comment.userName![0].toUpperCase()
//                             : '?',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 12),
              
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Anonymous',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         if (isOwner) ...[
//                           const SizedBox(width: 6),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF25D366),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text(
//                               'YOU',
//                               style: TextStyle(
//                                 fontSize: 8,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                         const Spacer(),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                         if (isOwner) ...[
//                           const SizedBox(width: 8),
//                           PopupMenuButton<String>(
//                             icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[500]),
//                             iconSize: 16,
//                             padding: EdgeInsets.zero,
//                             onSelected: (value) {
//                               if (value == 'edit' && onEdit != null) {
//                                 onEdit!();
//                               } else if (value == 'delete' && onDelete != null) {
//                                 onDelete!();
//                               }
//                             },
//                             itemBuilder: (context) => [
//                               const PopupMenuItem(
//                                 value: 'edit',
//                                 height: 36,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.edit, size: 16),
//                                     SizedBox(width: 8),
//                                     Text('Edit', style: TextStyle(fontSize: 14)),
//                                   ],
//                                 ),
//                               ),
//                               const PopupMenuItem(
//                                 value: 'delete',
//                                 height: 36,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.delete, size: 16, color: Colors.red),
//                                     SizedBox(width: 8),
//                                     Text('Delete', style: TextStyle(fontSize: 14, color: Colors.red)),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 4),
                    
//                     if (comment.content.isNotEmpty)
//                       Text(
//                         comment.content,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           height: 1.3,
//                           color: Colors.black87,
//                         ),
//                       ),
                    
//                     // Full width images
//                     if (comment.attachments.isNotEmpty) ...[
//                       const SizedBox(height: 8),
//                       ...comment.attachments.map((attachment) {
//                         return Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.only(bottom: 8),
//                           child: GestureDetector(
//                             onTap: () => _showMediaDialog(context, attachment),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: attachment.isImage
//                                   ? Hero(
//                                       tag: attachment.url,
//                                       child: Image.network(
//                                         attachment.url,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null) return child;
//                                           return Container(
//                                             height: 200,
//                                             color: Colors.grey[100],
//                                             child: Center(
//                                               child: CircularProgressIndicator(
//                                                 value: loadingProgress.expectedTotalBytes != null
//                                                     ? loadingProgress.cumulativeBytesLoaded /
//                                                         loadingProgress.expectedTotalBytes!
//                                                     : null,
//                                                 strokeWidth: 2,
//                                                 valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF25D366)),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Container(
//                                             height: 200,
//                                             color: Colors.grey[100],
//                                             child: const Center(
//                                               child: Icon(Icons.broken_image, color: Colors.grey),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                   : Container(
//                                       width: double.infinity,
//                                       height: 200,
//                                       color: const Color(0xFF374151),
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           if (attachment.thumbnailUrl != null)
//                                             Image.network(
//                                               attachment.thumbnailUrl!,
//                                               width: double.infinity,
//                                               height: 200,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           Container(
//                                             padding: const EdgeInsets.all(12),
//                                             decoration: BoxDecoration(
//                                               color: Colors.black.withOpacity(0.6),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.play_arrow,
//                                               size: 32,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
                    
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: onLike,
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                                 size: 16,
//                                 color: comment.isLiked ? Colors.red : Colors.grey[600],
//                               ),
//                               if (comment.likeCount > 0) ...[
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   comment.likeCount.toString(),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         GestureDetector(
//                           onTap: onReply,
//                           child: Text(
//                             'Reply',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // Replies with reduced indentation
//           if (comment.replies.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(left: 32, top: 4),
//               child: Column(
//                 children: comment.replies.map((reply) => CommentTile(
//                   comment: reply,
//                   isOwner: isOwner,
//                   formatDate: formatDate,
//                   onLike: onLike,
//                   onReply: onReply,
//                   onEdit: onEdit,
//                   onDelete: onDelete,
//                 )).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: attachment.isImage
//                     ? Hero(
//                         tag: attachment.url,
//                         child: InteractiveViewer(
//                           child: Image.network(
//                             attachment.url,
//                             fit: BoxFit.contain,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 padding: const EdgeInsets.all(40),
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     value: loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                         : null,
//                                     valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     : VideoPlayerWidget(videoUrl: attachment.url),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
    
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//       _showControls = true;
//     });

//     if (_isPlaying) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted && _isPlaying) {
//           setState(() => _showControls = false);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.black,
//               ),
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     VideoPlayer(_controller),
//                     if (_showControls)
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.3),
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     if (_showControls)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Icon(
//                             _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                             size: 48,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               padding: const EdgeInsets.all(40),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Hero(
//                   tag: imageUrl,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                           valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(Icons.error, color: Colors.white, size: 48),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



































// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 20;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
//   late AnimationController _inputAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _focusNode.addListener(_onFocusChange);
//     _inputAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _inputAnimationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _inputAnimationController.forward();
//       if (_showEmojiPicker) {
//         setState(() => _showEmojiPicker = false);
//       }
//     } else {
//       _inputAnimationController.reverse();
//     }
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Row(
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Text("Error loading comments: ${e.toString()}"),
//               ],
//             ),
//             backgroundColor: const Color(0xFFE53E3E),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             margin: const EdgeInsets.all(16),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _loadMoreComments() async {
//     if (_hasMore && !_isLoading) {
//       await _loadComments();
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       _showSnackBar("Please add content or media", isError: true);
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       _showSnackBar("You need to be logged in to comment", isError: true);
//       return;
//     }

//     setState(() => _isPosting = true);

//     try {
//       CommentModel comment;
      
//       if (_editingComment != null) {
//         comment = await NetworkService.updateComment(
//           commentToken: _editingComment!.commentToken,
//           content: content,
//           userToken: authProvider.user!.userToken,
//         );
        
//         setState(() {
//           final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//           if (index != -1) {
//             _comments[index] = comment;
//           }
//         });
//       } else if (_selectedMedia.isNotEmpty) {
//         comment = await NetworkService.createCommentWithMedia(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: _selectedMedia,
//         );
//         _comments.insert(0, comment);
//       } else {
//         comment = await NetworkService.createComment(
//           content: content,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//         );
//         _comments.insert(0, comment);
//       }

//       if (mounted) {
//         setState(() {
//           _selectedMedia.clear();
//           _controller.clear();
//           _focusNode.unfocus();
//           _replyingTo = null;
//           _editingComment = null;
//         });
        
//         _showSnackBar(
//           _editingComment != null ? "Comment updated!" : "Comment posted!",
//           isError: false,
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   void _showSnackBar(String message, {required bool isError}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Media size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           } else {
//             _showSnackBar("You can only attach up to 5 files", isError: true);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error picking media: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Video size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error recording video: ${e.toString()}", isError: true);
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = file.path.toLowerCase().endsWith('.jpg') ||
//         file.path.toLowerCase().endsWith('.jpeg') ||
//         file.path.toLowerCase().endsWith('.png') ||
//         file.path.toLowerCase().endsWith('.gif') ||
//         file.path.toLowerCase().endsWith('.webp');

//     return Container(
//       width: 80,
//       height: 80,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Container(
//                 color: const Color(0xFF374151),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     const Icon(Icons.videocam_rounded, size: 32, color: Colors.white),
//                     FutureBuilder<Duration>(
//                       future: _getVideoDuration(file),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final duration = snapshot.data!;
//                           return Positioned(
//                             bottom: 4,
//                             right: 4,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.7),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<Duration> _getVideoDuration(File file) async {
//     final controller = VideoPlayerController.file(file);
//     await controller.initialize();
//     final duration = controller.value.duration;
//     await controller.dispose();
//     return duration;
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//                 color: const Color(0xFF3B82F6),
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture with camera',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//                 color: const Color(0xFF10B981),
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture video',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//                 color: const Color(0xFFE53E3E),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: color.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(icon, color: color, size: 24),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.userName ?? 'user';
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text(
//           "Delete Comment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("Are you sure you want to delete this comment? This action cannot be undone."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFE53E3E), Color(0xFFDC2626)],
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ElevatedButton(
//               onPressed: () => Navigator.pop(context, true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text("Delete", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSnackBar("Comment deleted successfully", isError: false);
//       }
//     } catch (e) {
//       _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);

//       if (difference.inMinutes < 1) {
//         return 'Just now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m ago';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h ago';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d ago';
//       } else {
//         return DateFormat('MMM dd, yyyy').format(dt);
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildInputField() {
//     return Column(
//       children: [
//         // Selected media preview - full width at top
//         if (_selectedMedia.isNotEmpty)
//           Container(
//             width: double.infinity,
//             color: const Color(0xFFF8FAFC),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Selected Media',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   height: 80,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _selectedMedia.length,
//                     itemBuilder: (context, index) {
//                       return Stack(
//                         children: [
//                           _buildMediaPreview(_selectedMedia[index]),
//                           Positioned(
//                             top: -4,
//                             right: 4,
//                             child: GestureDetector(
//                               onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                               child: Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: const BoxDecoration(
//                                   color: Colors.red,
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 12,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // Input field container
//         Container(
//           width: double.infinity,
//           color: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             children: [
//               // Reply/Edit indicator
//               if (_replyingTo != null || _editingComment != null)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF3F4F6),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _editingComment != null 
//                             ? Icons.edit_rounded 
//                             : Icons.reply_rounded,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           _editingComment != null 
//                               ? "Editing comment..." 
//                               : "Replying to ${_replyingTo ?? ''}",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             _replyingTo = null;
//                             _editingComment = null;
//                             _controller.clear();
//                             _selectedMedia.clear();
//                           });
//                         },
//                         child: Icon(
//                           Icons.close,
//                           size: 18,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//               // Main input row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // Emoji button
//                   GestureDetector(
//                     onTap: _toggleEmojiPicker,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       child: Icon(
//                         _showEmojiPicker 
//                             ? Icons.keyboard 
//                             : Icons.emoji_emotions_outlined,
//                         color: Colors.grey[600],
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),

//                   // Text input field - expanded and larger
//                   Expanded(
//                     child: Container(
//                       constraints: const BoxConstraints(minHeight: 44),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF9FAFB),
//                         borderRadius: BorderRadius.circular(22),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: TextField(
//                         controller: _controller,
//                         focusNode: _focusNode,
//                         maxLines: null,
//                         minLines: 1,
//                         textAlignVertical: TextAlignVertical.center,
//                         decoration: InputDecoration(
//                           hintText: _editingComment != null
//                               ? "Edit your comment..."
//                               : "Add a comment...",
//                           hintStyle: TextStyle(
//                             color: Colors.grey[500],
//                             fontSize: 16,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16, 
//                             vertical: 12
//                           ),
//                           isDense: false,
//                         ),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),

//                   // Media attachment button
//                   GestureDetector(
//                     onTap: _showMediaOptions,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       child: Icon(
//                         Icons.camera_alt_outlined,
//                         color: Colors.grey[600],
//                         size: 26,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 4),

//                   // Send button
//                   _isPosting
//                       ? Container(
//                           padding: const EdgeInsets.all(8),
//                           child: const SizedBox(
//                             width: 28,
//                             height: 28,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                             ),
//                           ),
//                         )
//                       : GestureDetector(
//                           onTap: _postComment,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: (_controller.text.trim().isNotEmpty || _selectedMedia.isNotEmpty)
//                                     ? [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]
//                                     : [Colors.grey[400]!, Colors.grey[400]!],
//                               ),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.send_rounded,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _toggleEmojiPicker() {
//     if (_showEmojiPicker) {
//       _focusNode.requestFocus();
//     } else {
//       _focusNode.unfocus();
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (mounted) {
//           setState(() => _showEmojiPicker = !_showEmojiPicker);
//         }
//       });
//     }
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.all(40),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Color(0xFFF3F4F6),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.chat_bubble_outline_rounded,
//               size: 40,
//               color: Colors.grey[500],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No comments yet',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Be the first to share your thoughts!',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Comments list - full width, no containers
//         if (_comments.isEmpty && !_isLoading)
//           _buildEmptyState()
//         else ...[
//           // Comments
//           ..._comments.map((comment) {
//             final authProvider = context.watch<AuthProvider>();
//             final isOwner = authProvider.user?.userToken == comment.userToken;
//             return CommentTile(
//               comment: comment,
//               isOwner: isOwner,
//               formatDate: _formatDate,
//               onLike: () => _toggleLike(comment),
//               onReply: () => _startReply(comment),
//               onEdit: isOwner ? () => _startEdit(comment) : null,
//               onDelete: isOwner ? () => _deleteComment(comment) : null,
//             );
//           }).toList(),
          
//           // Load more button
//           if (_hasMore)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: _isLoading
//                   ? const Center(
//                       child: SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                         ),
//                       ),
//                     )
//                   : TextButton(
//                       onPressed: _loadMoreComments,
//                       child: Text(
//                         'Load More Comments',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//             ),
//         ],

//         // Input field at bottom - full width
//         _buildInputField(),

//         // Emoji picker - full width
//         if (_showEmojiPicker)
//           Container(
//             height: 250,
//             width: double.infinity,
//             color: Colors.white,
//             child: EmojiPicker(
//               onEmojiSelected: (category, emoji) {
//                 _controller.text = _controller.text + emoji.emoji;
//               },
//               config: const Config(
//                 emojiViewConfig: EmojiViewConfig(
//                   emojiSizeMax: 28,
//                 ),
//                 skinToneConfig: SkinToneConfig(),
//                 categoryViewConfig: CategoryViewConfig(),
//                 bottomActionBarConfig: BottomActionBarConfig(),
//                 searchViewConfig: SearchViewConfig(),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class CommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const CommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile picture
//               CircleAvatar(
//                 radius: 18,
//                 backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                     ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                     : null,
//                 backgroundColor: Colors.grey[300],
//                 child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                     ? Text(
//                         comment.userName != null && comment.userName!.isNotEmpty
//                             ? comment.userName![0].toUpperCase()
//                             : '?',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       )
//                     : null,
//               ),
//               const SizedBox(width: 12),
              
//               // Comment content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header row with name, time, and menu
//                     Row(
//                       children: [
//                         Text(
//                           comment.userName ?? 'Anonymous',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         if (isOwner) ...[
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF3B82F6),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text(
//                               'YOU',
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                         const Spacer(),
//                         Text(
//                           formatDate(comment.createdAt),
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                         if (isOwner) ...[
//                           const SizedBox(width: 8),
//                           PopupMenuButton<String>(
//                             icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[500]),
//                             iconSize: 16,
//                             padding: EdgeInsets.zero,
//                             onSelected: (value) {
//                               if (value == 'edit' && onEdit != null) {
//                                 onEdit!();
//                               } else if (value == 'delete' && onDelete != null) {
//                                 onDelete!();
//                               }
//                             },
//                             itemBuilder: (context) => [
//                               const PopupMenuItem(
//                                 value: 'edit',
//                                 height: 36,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.edit, size: 16),
//                                     SizedBox(width: 8),
//                                     Text('Edit', style: TextStyle(fontSize: 14)),
//                                   ],
//                                 ),
//                               ),
//                               const PopupMenuItem(
//                                 value: 'delete',
//                                 height: 36,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.delete, size: 16, color: Colors.red),
//                                     SizedBox(width: 8),
//                                     Text('Delete', style: TextStyle(fontSize: 14, color: Colors.red)),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ],
//                     ),
//                     const SizedBox(height: 6),
                    
//                     // Comment text
//                     if (comment.content.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           comment.content,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             height: 1.4,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
                    
//                     // Media attachments - full width
//                     if (comment.attachments.isNotEmpty) ...[
//                       ...comment.attachments.map((attachment) {
//                         return Container(
//                           width: double.infinity,
//                           margin: const EdgeInsets.only(bottom: 8),
//                           child: GestureDetector(
//                             onTap: () => _showMediaDialog(context, attachment),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: attachment.isImage
//                                   ? Hero(
//                                       tag: attachment.url,
//                                       child: Image.network(
//                                         attachment.url,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         loadingBuilder: (context, child, loadingProgress) {
//                                           if (loadingProgress == null) return child;
//                                           return Container(
//                                             height: 200,
//                                             color: Colors.grey[100],
//                                             child: Center(
//                                               child: CircularProgressIndicator(
//                                                 value: loadingProgress.expectedTotalBytes != null
//                                                     ? loadingProgress.cumulativeBytesLoaded /
//                                                         loadingProgress.expectedTotalBytes!
//                                                     : null,
//                                                 strokeWidth: 2,
//                                                 valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                         errorBuilder: (context, error, stackTrace) {
//                                           return Container(
//                                             height: 200,
//                                             color: Colors.grey[100],
//                                             child: Center(
//                                               child: Icon(Icons.broken_image, color: Colors.grey[400]),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     )
//                                   : Container(
//                                       width: double.infinity,
//                                       height: 200,
//                                       color: const Color(0xFF374151),
//                                       child: Stack(
//                                         alignment: Alignment.center,
//                                         children: [
//                                           if (attachment.thumbnailUrl != null)
//                                             Image.network(
//                                               attachment.thumbnailUrl!,
//                                               width: double.infinity,
//                                               height: 200,
//                                               fit: BoxFit.cover,
//                                             ),
//                                           Container(
//                                             padding: const EdgeInsets.all(12),
//                                             decoration: BoxDecoration(
//                                               color: Colors.black.withOpacity(0.6),
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.play_arrow,
//                                               size: 32,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
                    
//                     // Action buttons (like, reply)
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: onLike,
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                                 size: 18,
//                                 color: comment.isLiked ? Colors.red : Colors.grey[600],
//                               ),
//                               if (comment.likeCount > 0) ...[
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   comment.likeCount.toString(),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey[600],
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         GestureDetector(
//                           onTap: onReply,
//                           child: Text(
//                             'Reply',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           // Replies with indentation
//           if (comment.replies.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.only(left: 42, top: 8),
//               child: Column(
//                 children: comment.replies.map((reply) => CommentTile(
//                   comment: reply,
//                   isOwner: isOwner,
//                   formatDate: formatDate,
//                   onLike: onLike,
//                   onReply: onReply,
//                   onEdit: onEdit,
//                   onDelete: onDelete,
//                 )).toList(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: attachment.isImage
//                     ? Hero(
//                         tag: attachment.url,
//                         child: InteractiveViewer(
//                           child: Image.network(
//                             attachment.url,
//                             fit: BoxFit.contain,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Container(
//                                 padding: const EdgeInsets.all(40),
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     value: loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                         : null,
//                                     valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//                     : VideoPlayerWidget(videoUrl: attachment.url),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               right: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
    
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//       _showControls = true;
//     });

//     if (_isPlaying) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted && _isPlaying) {
//           setState(() => _showControls = false);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.black,
//               ),
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     VideoPlayer(_controller),
//                     if (_showControls)
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.3),
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     if (_showControls)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(0.5),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Icon(
//                             _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                             size: 48,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               padding: const EdgeInsets.all(40),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Hero(
//                   tag: imageUrl,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                           valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(Icons.error, color: Colors.white, size: 48),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



















































































// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 20;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
//   late AnimationController _inputAnimationController;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _focusNode.addListener(_onFocusChange);
//     _scrollController.addListener(_onScroll);
//     _inputAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _scrollController.dispose();
//     _inputAnimationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _inputAnimationController.forward();
//       if (_showEmojiPicker) {
//         setState(() => _showEmojiPicker = false);
//       }
//     } else {
//       _inputAnimationController.reverse();
//     }
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
//       _loadMoreComments();
//     }
//   }

//   Future<void> _refreshComments() async {
//     setState(() {
//       _page = 1;
//       _hasMore = true;
//     });
//     await _loadComments();
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar("Error loading comments: ${e.toString()}", isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _loadMoreComments() async {
//     if (_hasMore && !_isLoading) {
//       await _loadComments();
//     }
//   }

//   // FIXED: Main issue was here - improved state management and error handling
//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       _showSnackBar("Please add content or media", isError: true);
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       _showSnackBar("You need to be logged in to comment", isError: true);
//       return;
//     }

//     // Clear input immediately to prevent double submission
//     final tempContent = content;
//     final tempMedia = List<File>.from(_selectedMedia);
//     final tempReplyingTo = _replyingTo;
//     final tempEditingComment = _editingComment;

//     setState(() {
//       _isPosting = true;
//       _controller.clear();
//       _selectedMedia.clear();
//       _replyingTo = null;
//       _editingComment = null;
//       _focusNode.unfocus();
//     });

//     try {
//       CommentModel comment;
      
//       if (tempEditingComment != null) {
//         // Update comment
//         comment = await NetworkService.updateComment(
//           content: tempContent,
//           commentToken: tempEditingComment.commentToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: tempMedia,
//         );
        
//         // Update the comment in the list
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           setState(() {
//             _comments[index] = comment;
//           });
//         }
//         _showSnackBar("Comment updated successfully!", isError: false);
        
//       } else if (tempReplyingTo != null) {
//         // Create reply
//         comment = await NetworkService.createReply(
//           content: tempContent,
//           userToken: authProvider.user!.userToken,
//           commentToken: tempReplyingTo,
//           mediaFiles: tempMedia,
//         );
        
//         // Add the new reply to the list
//         setState(() {
//           _comments.add(comment);
//         });
//         _showSnackBar("Reply posted successfully!", isError: false);
        
//       } else {
//         // Create new comment
//         comment = await NetworkService.createComment(
//           content: tempContent,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: tempMedia,
//         );
        
//         // Add the new comment to the beginning of the list
//         setState(() {
//           _comments.insert(0, comment);
//         });
//         _showSnackBar("Comment posted successfully!", isError: false);
//       }
      
//     } catch (e) {
//       // On error, restore the input values
//       setState(() {
//         _controller.text = tempContent;
//         _selectedMedia.addAll(tempMedia);
//         _replyingTo = tempReplyingTo;
//         _editingComment = tempEditingComment;
//       });
//       _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   void _showSnackBar(String message, {required bool isError}) {
//     if (!mounted) return;
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: Duration(seconds: isError ? 4 : 2),
//       ),
//     );
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFiles = await picker.pickMultipleMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFiles.isNotEmpty) {
//         for (var pickedFile in pickedFiles) {
//           if (_selectedMedia.length >= 5) break;
          
//           final file = File(pickedFile.path);
//           final fileSize = await file.length();
          
//           if (fileSize > 50 * 1024 * 1024) {
//             _showSnackBar("Media size should be less than 50MB", isError: true);
//             continue;
//           }

//           setState(() => _selectedMedia.add(file));
//         }
//       }
//     } catch (e) {
//       _showSnackBar("Error picking media: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Video size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error recording video: ${e.toString()}", isError: true);
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = _isImageFile(file.path);

//     return Container(
//       width: 60,
//       height: 60,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Container(
//                 color: const Color(0xFF374151),
//                 child: const Icon(
//                   Icons.videocam_rounded, 
//                   size: 24, 
//                   color: Colors.white
//                 ),
//               ),
//       ),
//     );
//   }

//   bool _isImageFile(String path) {
//     final ext = path.toLowerCase();
//     return ext.endsWith('.jpg') || 
//            ext.endsWith('.jpeg') || 
//            ext.endsWith('.png') || 
//            ext.endsWith('.gif') || 
//            ext.endsWith('.webp');
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//                 color: const Color(0xFF3B82F6),
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture with camera',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//                 color: const Color(0xFF10B981),
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture video',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//                 color: const Color(0xFFE53E3E),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, color: color, size: 20),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.commentToken;
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           "Delete Comment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("Are you sure you want to delete this comment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE53E3E),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text("Delete", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSnackBar("Comment deleted successfully", isError: false);
//       }
//     } catch (e) {
//       _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);

//       if (difference.inMinutes < 1) {
//         return 'now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d';
//       } else {
//         return DateFormat('MMM d').format(dt);
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildStickyInput() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(
//             color: Colors.grey[200]!,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Selected media preview
//           if (_selectedMedia.isNotEmpty)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: _selectedMedia.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final file = entry.value;
//                     return Stack(
//                       children: [
//                         _buildMediaPreview(file),
//                         Positioned(
//                           top: -4,
//                           right: 4,
//                           child: GestureDetector(
//                             onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                             child: Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFE53E3E),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//           // Reply/Edit indicator
//           if (_replyingTo != null || _editingComment != null)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _editingComment != null ? Icons.edit : Icons.reply,
//                     size: 16,
//                     color: Colors.grey[600],
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _editingComment != null 
//                           ? "Editing comment..." 
//                           : "Replying...",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                     child: Icon(
//                       Icons.close,
//                       size: 18,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Input field
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       constraints: const BoxConstraints(maxHeight: 120),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           // Emoji button
//                           GestureDetector(
//                             onTap: _toggleEmojiPicker,
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Icon(
//                                 _showEmojiPicker 
//                                     ? Icons.keyboard 
//                                     : Icons.emoji_emotions_outlined,
//                                 color: Colors.grey[600],
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                           // Text field
//                           Expanded(
//                             child: TextField(
//                               controller: _controller,
//                               focusNode: _focusNode,
//                               maxLines: null,
//                               minLines: 1,
//                               textInputAction: TextInputAction.newline,
//                               decoration: InputDecoration(
//                                 hintText: _editingComment != null
//                                     ? "Edit your comment..."
//                                     : "Add a comment...",
//                                 hintStyle: TextStyle(
//                                   color: Colors.grey[500],
//                                   fontSize: 16,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 12,
//                                 ),
//                               ),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           // Media button
//                           GestureDetector(
//                             onTap: _showMediaOptions,
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Icon(
//                                 Icons.attach_file,
//                                 color: Colors.grey[600],
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // FIXED: Send button logic - always enabled but checks content on tap
//                   GestureDetector(
//                     onTap: !_isPosting ? _postComment : null,
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: _isPosting 
//                             ? Colors.grey[400] 
//                             : Theme.of(context).primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: _isPosting
//                           ? const Center(
//                               child: SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               ),
//                             )
//                           : const Icon(
//                               Icons.send_rounded,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     setState(() {
//       _showEmojiPicker = !_showEmojiPicker;
//       if (_showEmojiPicker) {
//         _focusNode.unfocus();
//       } else {
//         _focusNode.requestFocus();
//       }
//     });
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.chat_bubble_outline_rounded,
//                 size: 48,
//                 color: Colors.grey[400],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'No comments yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Be the first to share your thoughts!',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500, // Fixed height for comment section
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, -8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Comments header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey[200]!,
//                   width: 0.5,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.chat_bubble_rounded,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Comments',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1F2937),
//                   ),
//                 ),
//                 const Spacer(),
//                 if (_comments.isNotEmpty)
//                   Text(
//                     '${_comments.length}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Comments list
//           Expanded(
//             child: _comments.isEmpty && !_isLoading
//                 ? _buildEmptyState()
//                 : RefreshIndicator(
//                     onRefresh: _refreshComments,
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.zero,
//                       itemCount: _comments.length + (_hasMore ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index >= _comments.length) {
//                           return _isLoading
//                               ? Container(
//                                   padding: const EdgeInsets.all(20),
//                                   child: const Center(
//                                     child: SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox.shrink();
//                         }

//                         final comment = _comments[index];
//                         final authProvider = context.watch<AuthProvider>();
//                         final isOwner = authProvider.user?.userToken == comment.userToken;

//                         if (kDebugMode) {
//                           print('Comment by: ${comment.userName} (${comment.userToken})');
//                           print('Current user: ${authProvider.user?.userToken}');
//                           print('Is owner: $isOwner');
//                           print('---');
//                         }
//                         return InstagramStyleCommentTile(
//                           comment: comment,
//                           isOwner: isOwner,
//                           formatDate: _formatDate,
//                           onLike: () => _toggleLike(comment),
//                           onReply: () => _startReply(comment),
//                           onEdit: isOwner ? () => _startEdit(comment) : null,
//                           onDelete: isOwner ? () => _deleteComment(comment) : null,
//                         );
//                       },
//                     ),

//           ),
// ),


//           // Sticky input at bottom
//           _buildStickyInput(),

//           // Emoji picker
//           if (_showEmojiPicker)
//             Container(
//               height: 250,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   top: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: EmojiPicker(
//                 onEmojiSelected: (category, emoji) {
//                   _controller.text += emoji.emoji;
//                 },
//                 config: Config(
//                   emojiViewConfig: const EmojiViewConfig(
//                     emojiSizeMax: 28,
//                     backgroundColor: Colors.white,
//                   ),
//                   skinToneConfig: const SkinToneConfig(),
//                   categoryViewConfig: const CategoryViewConfig(),
//                   bottomActionBarConfig: BottomActionBarConfig(
//                     backgroundColor: Colors.grey[50]!,
//                   ),
//                   searchViewConfig: const SearchViewConfig(),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class InstagramStyleCommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;

//   const InstagramStyleCommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//   });

//   void _showProfilePhoto(BuildContext context, String imageUrl) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         opaque: false,
//         pageBuilder: (context, animation, _) => ProfilePhotoViewer(imageUrl: imageUrl),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile picture with tap to view
//           GestureDetector(
//             onTap: () {
//               if (comment.userPhoto != null && comment.userPhoto!.isNotEmpty) {
//                 _showProfilePhoto(
//                   context, 
//                   NetworkService.getImageUrl(comment.userPhoto!)
//                 );
//               }
//             },
//             child: Hero(
//               tag: 'profile_${comment.userToken}',
//               child: Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Colors.grey[300]!,
//                     width: 0.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 18,
//                   backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                       ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                       : null,
//                   backgroundColor: Colors.grey[200],
//                   child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                       ? Text(
//                           comment.userName != null && comment.userName!.isNotEmpty
//                               ? comment.userName![0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
          
//           // Comment content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Username and content in one line (Instagram style)
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: comment.userName ?? 'Anonymous',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       if (comment.content.isNotEmpty) ...[
//                         const TextSpan(text: ' '),
//                         TextSpan(
//                           text: comment.content,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
                
//                 // Media attachments
//                 if (comment.attachments.isNotEmpty) ...[
//                   const SizedBox(height: 8),
//                   ...comment.attachments.map((attachment) => Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: GestureDetector(
//                       onTap: () => _showMediaDialog(context, attachment),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: attachment.isImage
//                             ? Hero(
//                                 tag: attachment.url,
//                                 child: Image.network(
//                                   attachment.url,
//                                   height: 200,
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return Container(
//                                       height: 200,
//                                       color: Colors.grey[100],
//                                       child: const Center(
//                                         child: CircularProgressIndicator(strokeWidth: 2),
//                                       ),
//                                     );
//                                   },
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       height: 200,
//                                       color: Colors.grey[100],
//                                       child: Center(
//                                         child: Icon(Icons.broken_image, color: Colors.grey[400]),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               )
//                             : VideoThumbnailWidget(
//                                 videoUrl: attachment.url,
//                                 thumbnailUrl: attachment.thumbnailUrl,
//                               ),
//                       ),
//                     ),
//                   )).toList(),
//                 ],
                
//                 const SizedBox(height: 8),
                
//                 // Action row (like Instagram)
//                 Row(
//                   children: [
//                     Text(
//                       formatDate(comment.createdAt),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (comment.likeCount > 0) ...[
//                       const SizedBox(width: 16),
//                       Text(
//                         '${comment.likeCount} ${comment.likeCount == 1 ? 'like' : 'likes'}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                     const SizedBox(width: 16),
//                     GestureDetector(
//                       onTap: onReply,
//                       child: Text(
//                         'Reply',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: onLike,
//                       child: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         child: Icon(
//                           comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                           key: ValueKey(comment.isLiked),
//                           size: 16,
//                           color: comment.isLiked ? Colors.red : Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     if (isOwner) ...[
//                       const SizedBox(width: 8),
//                       PopupMenuButton<String>(
//                         icon: Icon(Icons.more_horiz, size: 16, color: Colors.grey[500]),
//                         iconSize: 16,
//                         padding: EdgeInsets.zero,
//                         onSelected: (value) {
//                           if (value == 'edit' && onEdit != null) {
//                             onEdit!();
//                           } else if (value == 'delete' && onDelete != null) {
//                             onDelete!();
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.edit, size: 16),
//                                 SizedBox(width: 8),
//                                 Text('Edit'),
//                               ],
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.delete, size: 16, color: Colors.red),
//                                 SizedBox(width: 8),
//                                 Text('Delete', style: TextStyle(color: Colors.red)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
                
//                 // Replies
//                 if (comment.replies.isNotEmpty)
//                   Container(
//                     margin: const EdgeInsets.only(left: 20, top: 12),
//                     child: Column(
//                       children: comment.replies.map((reply) => InstagramStyleCommentTile(
//                         comment: reply,
//                         isOwner: reply.userToken == context.read<AuthProvider>().user?.userToken,
//                         formatDate: formatDate,
//                         onLike: onLike,
//                         onReply: onReply,
//                         onEdit: onEdit,
//                         onDelete: onDelete,
//                       )).toList(),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (context) => Dialog.fullscreen(
//         backgroundColor: Colors.transparent,
//         child: Stack(
//           children: [
//             Center(
//               child: attachment.isImage
//                   ? Hero(
//                       tag: attachment.url,
//                       child: InteractiveViewer(
//                         child: Image.network(
//                           attachment.url,
//                           fit: BoxFit.contain,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     )
//                   : VideoPlayerWidget(videoUrl: attachment.url),
//             ),
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 16,
//               right: 16,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoThumbnailWidget extends StatelessWidget {
//   final String videoUrl;
//   final String? thumbnailUrl;

//   const VideoThumbnailWidget({
//     super.key,
//     required this.videoUrl,
//     this.thumbnailUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           if (thumbnailUrl != null)
//             Image.network(
//               thumbnailUrl!,
//               width: double.infinity,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.play_arrow,
//               size: 32,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
    
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//       _showControls = true;
//     });

//     if (_isPlaying) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted && _isPlaying) {
//           setState(() => _showControls = false);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.black,
//               ),
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: VideoPlayer(_controller),
//                     ),
//                     if (_showControls)
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.3),
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     if (_showControls)
//                       GestureDetector(
//                         onTap: _togglePlayPause,
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                             size: 32,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Hero(
//                   tag: imageUrl,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                           valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(Icons.error, color: Colors.white, size: 48),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

















//old working code 10-9-25


// // ignore_for_file: unused_local_variable

// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:video_player/video_player.dart';
// import 'package:moments/models/comment_model.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:moments/providers/auth_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// class CommentSection extends StatefulWidget {
//   final String eventToken;
//   const CommentSection({super.key, required this.eventToken});

//   @override
//   State<CommentSection> createState() => _CommentSectionState();
// }

// class _CommentSectionState extends State<CommentSection> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<CommentModel> _comments = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   int _page = 1;
//   final int _limit = 20;
//   final List<File> _selectedMedia = [];
//   bool _isPosting = false;
//   bool _showEmojiPicker = false;
//   final FocusNode _focusNode = FocusNode();
//   String? _replyingTo;
//   CommentModel? _editingComment;
//   late AnimationController _inputAnimationController;
//   final Dio _dio = Dio();

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//     _focusNode.addListener(_onFocusChange);
//     _scrollController.addListener(_onScroll);
//     _inputAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//     _scrollController.dispose();
//     _inputAnimationController.dispose();
//     super.dispose();
//   }

//   void _onFocusChange() {
//     if (_focusNode.hasFocus) {
//       _inputAnimationController.forward();
//       if (_showEmojiPicker) {
//         setState(() => _showEmojiPicker = false);
//       }
//     } else {
//       _inputAnimationController.reverse();
//     }
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
//       _loadMoreComments();
//     }
//   }

//   Future<void> _refreshComments() async {
//     setState(() {
//       _page = 1;
//       _hasMore = true;
//     });
//     await _loadComments();
//   }

//   Future<void> _loadComments() async {
//     if (_isLoading) return;
    
//     setState(() => _isLoading = true);
    
//     try {
//       final authProvider = context.read<AuthProvider>();
//       final response = await NetworkService.getEventComments(
//         eventToken: widget.eventToken,
//         page: _page,
//         limit: _limit,
//         userToken: authProvider.user?.userToken,
//       );

//       if (_page == 1) {
//         _comments.clear();
//       }

//       setState(() {
//         _comments.addAll(response['comments']);
//         _hasMore = _comments.length < response['total'];
//         _page += 1;
//       });
//     } catch (e) {
//       if (mounted) {
//         _showSnackBar("Error loading comments: ${e.toString()}", isError: true);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _loadMoreComments() async {
//     if (_hasMore && !_isLoading) {
//       await _loadComments();
//     }
//   }

//   // ENHANCED: Added download functionality
//   Future<bool> _requestStoragePermission() async {
//     if (Platform.isAndroid) {
//       final deviceInfo = DeviceInfoPlugin();
//       final androidInfo = await deviceInfo.androidInfo;
      
//       if (androidInfo.version.sdkInt >= 33) {
//         // Android 13+ doesn't need WRITE_EXTERNAL_STORAGE permission
//         return true;
//       } else {
//         // Android 12 and below
//         final status = await Permission.storage.request();
//         return status.isGranted;
//       }
//     } else if (Platform.isIOS) {
//       final status = await Permission.photos.request();
//       return status.isGranted;
//     }
//     return false;
//   }

//   Future<void> _downloadMedia(MediaAttachment attachment) async {
//     try {
//       // Request permission
//       final hasPermission = await _requestStoragePermission();
//       if (!hasPermission) {
//         _showSnackBar("Storage permission is required to download media", isError: true);
//         return;
//       }

//       // Show downloading progress
//       _showSnackBar("Downloading...", isError: false);

//       // Get appropriate directory
//       Directory? directory;
//       String fileName;
      
//       if (Platform.isAndroid) {
//         directory = await getExternalStorageDirectory();
//         if (directory != null) {
//           // Create Downloads folder in app directory
//           final downloadsDir = Directory('${directory.path}/Downloads');
//           if (!await downloadsDir.exists()) {
//             await downloadsDir.create(recursive: true);
//           }
//           directory = downloadsDir;
//         }
//       } else if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       }

//       if (directory == null) {
//         _showSnackBar("Could not access storage directory", isError: true);
//         return;
//       }

//       // Generate unique filename
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final extension = attachment.isImage ? 'jpg' : 'mp4';
//       fileName = 'moments_${attachment.isImage ? 'image' : 'video'}_$timestamp.$extension';
      
//       final filePath = '${directory.path}/$fileName';

//       // Download the file
//       await _dio.download(
//         attachment.url,
//         filePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             final progress = (received / total * 100).toStringAsFixed(0);
//             // You could show progress here if needed
//           }
//         },
//       );

//       // Save to gallery for easier access
//       if (Platform.isAndroid || Platform.isIOS) {
//         try {
//           final file = File(filePath);
//           final bytes = await file.readAsBytes();
          
//           if (attachment.isImage) {
//             // For images, you might want to use a package like image_gallery_saver
//             // await ImageGallerySaver.saveImage(bytes, name: fileName);
//           } else {
//             // For videos, similar approach
//             // await ImageGallerySaver.saveFile(filePath, name: fileName);
//           }
//         } catch (e) {
//           // Fallback - file is still saved in app directory
//           if (kDebugMode) {
//             print('Could not save to gallery: $e');
//           }
//         }
//       }

//       _showSnackBar(
//         "Downloaded to: ${directory.path}/$fileName", 
//         isError: false
//       );

//     } catch (e) {
//       _showSnackBar("Download failed: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _postComment() async {
//     if (_isPosting) return;
    
//     final content = _controller.text.trim();
//     if (content.isEmpty && _selectedMedia.isEmpty) {
//       _showSnackBar("Please add content or media", isError: true);
//       return;
//     }

//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) {
//       _showSnackBar("You need to be logged in to comment", isError: true);
//       return;
//     }

//     // Clear input immediately to prevent double submission
//     final tempContent = content;
//     final tempMedia = List<File>.from(_selectedMedia);
//     final tempReplyingTo = _replyingTo;
//     final tempEditingComment = _editingComment;

//     setState(() {
//       _isPosting = true;
//       _controller.clear();
//       _selectedMedia.clear();
//       _replyingTo = null;
//       _editingComment = null;
//       _focusNode.unfocus();
//     });

//     try {
//       CommentModel comment;
      
//       if (tempEditingComment != null) {
//         // Update comment
//         comment = await NetworkService.updateComment(
//           content: tempContent,
//           commentToken: tempEditingComment.commentToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: tempMedia,
//         );
        
//         // Update the comment in the list
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           setState(() {
//             _comments[index] = comment;
//           });
//         }
//         _showSnackBar("Comment updated successfully!", isError: false);
        
//       } else if (tempReplyingTo != null) {
//         // Create reply
//         comment = await NetworkService.createReply(
//           content: tempContent,
//           userToken: authProvider.user!.userToken,
//           commentToken: tempReplyingTo,
//           mediaFiles: tempMedia,
//         );
        
//         // Add the new reply to the list
//         setState(() {
//           _comments.add(comment);
//         });
//         _showSnackBar("Reply posted successfully!", isError: false);
        
//       } else {
//         // Create new comment
//         comment = await NetworkService.createComment(
//           content: tempContent,
//           eventToken: widget.eventToken,
//           userToken: authProvider.user!.userToken,
//           mediaFiles: tempMedia,
//         );
        
//         // Add the new comment to the beginning of the list
//         setState(() {
//           _comments.insert(0, comment);
//         });
//         _showSnackBar("Comment posted successfully!", isError: false);
//       }
      
//     } catch (e) {
//       // On error, restore the input values
//       setState(() {
//         _controller.text = tempContent;
//         _selectedMedia.addAll(tempMedia);
//         _replyingTo = tempReplyingTo;
//         _editingComment = tempEditingComment;
//       });
//       _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
//     } finally {
//       if (mounted) {
//         setState(() => _isPosting = false);
//       }
//     }
//   }

//   void _showSnackBar(String message, {required bool isError}) {
//     if (!mounted) return;
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isError ? Icons.error_outline : Icons.check_circle_outline,
//               color: Colors.white,
//             ),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: Duration(seconds: isError ? 4 : 2),
//       ),
//     );
//   }

//   Future<void> _pickMedia() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFiles = await picker.pickMultipleMedia(
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFiles.isNotEmpty) {
//         for (var pickedFile in pickedFiles) {
//           if (_selectedMedia.length >= 5) break;
          
//           final file = File(pickedFile.path);
//           final fileSize = await file.length();
          
//           if (fileSize > 50 * 1024 * 1024) {
//             _showSnackBar("Media size should be less than 50MB", isError: true);
//             continue;
//           }

//           setState(() => _selectedMedia.add(file));
//         }
//       }
//     } catch (e) {
//       _showSnackBar("Error picking media: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickImageFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1920,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
//     }
//   }

//   Future<void> _pickVideoFromCamera() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(minutes: 5),
//       );

//       if (pickedFile != null) {
//         final file = File(pickedFile.path);
//         final fileSize = await file.length();
        
//         if (fileSize > 50 * 1024 * 1024) {
//           _showSnackBar("Video size should be less than 50MB", isError: true);
//           return;
//         }

//         setState(() {
//           if (_selectedMedia.length < 5) {
//             _selectedMedia.add(file);
//           }
//         });
//       }
//     } catch (e) {
//       _showSnackBar("Error recording video: ${e.toString()}", isError: true);
//     }
//   }

//   Widget _buildMediaPreview(File file) {
//     final isImage = _isImageFile(file.path);

//     return Container(
//       width: 60,
//       height: 60,
//       margin: const EdgeInsets.only(right: 8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: isImage
//             ? Image.file(file, fit: BoxFit.cover)
//             : Container(
//                 color: const Color(0xFF374151),
//                 child: const Icon(
//                   Icons.videocam_rounded, 
//                   size: 24, 
//                   color: Colors.white
//                 ),
//               ),
//       ),
//     );
//   }

//   bool _isImageFile(String path) {
//     final ext = path.toLowerCase();
//     return ext.endsWith('.jpg') || 
//            ext.endsWith('.jpeg') || 
//            ext.endsWith('.png') || 
//            ext.endsWith('.gif') || 
//            ext.endsWith('.webp');
//   }

//   void _showMediaOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 8),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Add Media',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.photo_library_rounded,
//                 title: 'Photo Library',
//                 subtitle: 'Choose from gallery',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickMedia();
//                 },
//                 color: const Color(0xFF3B82F6),
//               ),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_rounded,
//                 title: 'Take Photo',
//                 subtitle: 'Capture with camera',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickImageFromCamera();
//                 },
//                 color: const Color(0xFF10B981),
//               ),
//               _buildMediaOption(
//                 icon: Icons.videocam_rounded,
//                 title: 'Record Video',
//                 subtitle: 'Capture video',
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _pickVideoFromCamera();
//                 },
//                 color: const Color(0xFFE53E3E),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.1)),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: color.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, color: color, size: 20),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1F2937),
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleLike(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     try {
//       final result = await NetworkService.toggleCommentLike(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       setState(() {
//         final index = _comments.indexWhere((c) => c.commentToken == comment.commentToken);
//         if (index != -1) {
//           _comments[index] = _comments[index].copyWith(
//             likeCount: result['likeCount'],
//             isLiked: result['isLiked'],
//           );
//         }
//       });
//     } catch (e) {
//       _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
//     }
//   }

//   void _startReply(CommentModel comment) {
//     setState(() {
//       _replyingTo = comment.commentToken;
//       _editingComment = null;
//       _controller.clear();
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   void _startEdit(CommentModel comment) {
//     setState(() {
//       _editingComment = comment;
//       _replyingTo = null;
//       _controller.text = comment.content;
//       _selectedMedia.clear();
//       _focusNode.requestFocus();
//     });
//   }

//   Future<void> _deleteComment(CommentModel comment) async {
//     final authProvider = context.read<AuthProvider>();
//     if (authProvider.user == null) return;

//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           "Delete Comment",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text("Are you sure you want to delete this comment?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: Text(
//               "Cancel",
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE53E3E),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text("Delete", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (confirm != true) return;

//     try {
//       final success = await NetworkService.deleteComment(
//         commentToken: comment.commentToken,
//         userToken: authProvider.user!.userToken,
//       );

//       if (success && mounted) {
//         setState(() {
//           _comments.removeWhere((c) => c.commentToken == comment.commentToken);
//         });
//         _showSnackBar("Comment deleted successfully", isError: false);
//       }
//     } catch (e) {
//       _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
//     }
//   }

//   String _formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       final now = DateTime.now();
//       final difference = now.difference(dt);

//       if (difference.inMinutes < 1) {
//         return 'now';
//       } else if (difference.inHours < 1) {
//         return '${difference.inMinutes}m';
//       } else if (difference.inDays < 1) {
//         return '${difference.inHours}h';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d';
//       } else {
//         return DateFormat('MMM d').format(dt);
//       }
//     } catch (_) {
//       return date;
//     }
//   }

//   Widget _buildStickyInput() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(
//             color: Colors.grey[200]!,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Selected media preview
//           if (_selectedMedia.isNotEmpty)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: _selectedMedia.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final file = entry.value;
//                     return Stack(
//                       children: [
//                         _buildMediaPreview(file),
//                         Positioned(
//                           top: -4,
//                           right: 4,
//                           child: GestureDetector(
//                             onTap: () => setState(() => _selectedMedia.removeAt(index)),
//                             child: Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFE53E3E),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 12,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//           // Reply/Edit indicator
//           if (_replyingTo != null || _editingComment != null)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     _editingComment != null ? Icons.edit : Icons.reply,
//                     size: 16,
//                     color: Colors.grey[600],
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _editingComment != null 
//                           ? "Editing comment..." 
//                           : "Replying...",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _replyingTo = null;
//                         _editingComment = null;
//                         _controller.clear();
//                         _selectedMedia.clear();
//                       });
//                     },
//                     child: Icon(
//                       Icons.close,
//                       size: 18,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Input field
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       constraints: const BoxConstraints(maxHeight: 120),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           // Emoji button
//                           GestureDetector(
//                             onTap: _toggleEmojiPicker,
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Icon(
//                                 _showEmojiPicker 
//                                     ? Icons.keyboard 
//                                     : Icons.emoji_emotions_outlined,
//                                 color: Colors.grey[600],
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                           // Text field
//                           Expanded(
//                             child: TextField(
//                               controller: _controller,
//                               focusNode: _focusNode,
//                               maxLines: null,
//                               minLines: 1,
//                               textInputAction: TextInputAction.newline,
//                               decoration: InputDecoration(
//                                 hintText: _editingComment != null
//                                     ? "Edit your comment..."
//                                     : "Add a comment...",
//                                 hintStyle: TextStyle(
//                                   color: Colors.grey[500],
//                                   fontSize: 16,
//                                 ),
//                                 border: InputBorder.none,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 12,
//                                 ),
//                               ),
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                           // Media button
//                           GestureDetector(
//                             onTap: _showMediaOptions,
//                             child: Padding(
//                               padding: const EdgeInsets.all(12),
//                               child: Icon(
//                                 Icons.attach_file,
//                                 color: Colors.grey[600],
//                                 size: 24,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Send button
//                   GestureDetector(
//                     onTap: !_isPosting ? _postComment : null,
//                     child: Container(
//                       width: 40,
//                       height: 40,
//                       decoration: BoxDecoration(
//                         color: _isPosting 
//                             ? Colors.grey[400] 
//                             : Theme.of(context).primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: _isPosting
//                           ? const Center(
//                               child: SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               ),
//                             )
//                           : const Icon(
//                               Icons.send_rounded,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggleEmojiPicker() {
//     setState(() {
//       _showEmojiPicker = !_showEmojiPicker;
//       if (_showEmojiPicker) {
//         _focusNode.unfocus();
//       } else {
//         _focusNode.requestFocus();
//       }
//     });
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(40),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.chat_bubble_outline_rounded,
//                 size: 48,
//                 color: Colors.grey[400],
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'No comments yet',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Be the first to share your thoughts!',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500, // Fixed height for comment section
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, -8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Comments header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey[200]!,
//                   width: 0.5,
//                 ),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF8B5CF6), Color(0xFFA855F7)],
//                     ),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.chat_bubble_rounded,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Comments',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF1F2937),
//                   ),
//                 ),
//                 const Spacer(),
//                 if (_comments.isNotEmpty)
//                   Text(
//                     '${_comments.length}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           // Comments list
//           Expanded(
//             child: _comments.isEmpty && !_isLoading
//                 ? _buildEmptyState()
//                 : RefreshIndicator(
//                     onRefresh: _refreshComments,
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.zero,
//                       itemCount: _comments.length + (_hasMore ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index >= _comments.length) {
//                           return _isLoading
//                               ? Container(
//                                   padding: const EdgeInsets.all(20),
//                                   child: const Center(
//                                     child: SizedBox(
//                                       width: 20,
//                                       height: 20,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : const SizedBox.shrink();
//                         }

//                         final comment = _comments[index];
//                         final authProvider = context.watch<AuthProvider>();
//                         final isOwner = authProvider.user?.userToken == comment.userToken;

//                         if (kDebugMode) {
//                           print('Comment by: ${comment.userName} (${comment.userToken})');
//                           print('Current user: ${authProvider.user?.userToken}');
//                           print('Is owner: $isOwner');
//                           print('---');
//                         }
//                         return InstagramStyleCommentTile(
//                           comment: comment,
//                           isOwner: isOwner,
//                           formatDate: _formatDate,
//                           onLike: () => _toggleLike(comment),
//                           onReply: () => _startReply(comment),
//                           onEdit: isOwner ? () => _startEdit(comment) : null,
//                           onDelete: isOwner ? () => _deleteComment(comment) : null,
//                           onDownload: _downloadMedia, // Pass download function
//                         );
//                       },
//                     ),
//                   ),
//           ),

//           // Sticky input at bottom
//           _buildStickyInput(),

//           // Emoji picker
//           if (_showEmojiPicker)
//             Container(
//               height: 250,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(
//                   top: BorderSide(color: Colors.grey[200]!),
//                 ),
//               ),
//               child: EmojiPicker(
//                 onEmojiSelected: (category, emoji) {
//                   _controller.text += emoji.emoji;
//                 },
//                 config: Config(
//                   emojiViewConfig: const EmojiViewConfig(
//                     emojiSizeMax: 28,
//                     backgroundColor: Colors.white,
//                   ),
//                   skinToneConfig: const SkinToneConfig(),
//                   categoryViewConfig: const CategoryViewConfig(),
//                   bottomActionBarConfig: BottomActionBarConfig(
//                     backgroundColor: Colors.grey[50]!,
//                   ),
//                   searchViewConfig: const SearchViewConfig(),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class InstagramStyleCommentTile extends StatelessWidget {
//   final CommentModel comment;
//   final bool isOwner;
//   final String Function(String) formatDate;
//   final VoidCallback onLike;
//   final VoidCallback onReply;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final Future<void> Function(MediaAttachment) onDownload; // Added download callback

//   const InstagramStyleCommentTile({
//     super.key,
//     required this.comment,
//     required this.isOwner,
//     required this.formatDate,
//     required this.onLike,
//     required this.onReply,
//     this.onEdit,
//     this.onDelete,
//     required this.onDownload, // Added required parameter
//   });

//   void _showProfilePhoto(BuildContext context, String imageUrl) {
//     Navigator.push(
//       context,
//       PageRouteBuilder(
//         opaque: false,
//         pageBuilder: (context, animation, _) => ProfilePhotoViewer(imageUrl: imageUrl),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(opacity: animation, child: child);
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile picture with tap to view
//           GestureDetector(
//             onTap: () {
//               if (comment.userPhoto != null && comment.userPhoto!.isNotEmpty) {
//                 _showProfilePhoto(
//                   context, 
//                   NetworkService.getImageUrl(comment.userPhoto!)
//                 );
//               }
//             },
//             child: Hero(
//               tag: 'profile_${comment.userToken}',
//               child: Container(
//                 width: 36,
//                 height: 36,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: Colors.grey[300]!,
//                     width: 0.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 18,
//                   backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
//                       ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
//                       : null,
//                   backgroundColor: Colors.grey[200],
//                   child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
//                       ? Text(
//                           comment.userName != null && comment.userName!.isNotEmpty
//                               ? comment.userName![0].toUpperCase()
//                               : '?',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         )
//                       : null,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
          
//           // Comment content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Username and content in one line (Instagram style)
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(
//                         text: comment.userName ?? 'Anonymous',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       if (comment.content.isNotEmpty) ...[
//                         const TextSpan(text: ' '),
//                         TextSpan(
//                           text: comment.content,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
                
//                 // ENHANCED: Media attachments with download button
//                 if (comment.attachments.isNotEmpty) ...[
//                   const SizedBox(height: 8),
//                   ...comment.attachments.map((attachment) => Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: Stack(
//                       children: [
//                         GestureDetector(
//                           onTap: () => _showMediaDialog(context, attachment),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: attachment.isImage
//                                 ? Hero(
//                                     tag: attachment.url,
//                                     child: Image.network(
//                                       attachment.url,
//                                       height: 200,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover,
//                                       loadingBuilder: (context, child, loadingProgress) {
//                                         if (loadingProgress == null) return child;
//                                         return Container(
//                                           height: 200,
//                                           color: Colors.grey[100],
//                                           child: const Center(
//                                             child: CircularProgressIndicator(strokeWidth: 2),
//                                           ),
//                                         );
//                                       },
//                                       errorBuilder: (context, error, stackTrace) {
//                                         return Container(
//                                           height: 200,
//                                           color: Colors.grey[100],
//                                           child: Center(
//                                             child: Icon(Icons.broken_image, color: Colors.grey[400]),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   )
//                                 : VideoThumbnailWidget(
//                                     videoUrl: attachment.url,
//                                     thumbnailUrl: attachment.thumbnailUrl,
//                                   ),
//                           ),
//                         ),
//                         // Download button overlay
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: () => onDownload(attachment),
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.black.withOpacity(0.7),
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.download_rounded,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )).toList(),
//                 ],
                
//                 const SizedBox(height: 8),
                
//                 // Action row (like Instagram)
//                 Row(
//                   children: [
//                     Text(
//                       formatDate(comment.createdAt),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[500],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (comment.likeCount > 0) ...[
//                       const SizedBox(width: 16),
//                       Text(
//                         '${comment.likeCount} ${comment.likeCount == 1 ? 'like' : 'likes'}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                     const SizedBox(width: 16),
//                     GestureDetector(
//                       onTap: onReply,
//                       child: Text(
//                         'Reply',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[500],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: onLike,
//                       child: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         child: Icon(
//                           comment.isLiked ? Icons.favorite : Icons.favorite_border,
//                           key: ValueKey(comment.isLiked),
//                           size: 16,
//                           color: comment.isLiked ? Colors.red : Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     if (isOwner) ...[
//                       const SizedBox(width: 8),
//                       PopupMenuButton<String>(
//                         icon: Icon(Icons.more_horiz, size: 16, color: Colors.grey[500]),
//                         iconSize: 16,
//                         padding: EdgeInsets.zero,
//                         onSelected: (value) {
//                           if (value == 'edit' && onEdit != null) {
//                             onEdit!();
//                           } else if (value == 'delete' && onDelete != null) {
//                             onDelete!();
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           const PopupMenuItem(
//                             value: 'edit',
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.edit, size: 16),
//                                 SizedBox(width: 8),
//                                 Text('Edit'),
//                               ],
//                             ),
//                           ),
//                           const PopupMenuItem(
//                             value: 'delete',
//                             height: 40,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.delete, size: 16, color: Colors.red),
//                                 SizedBox(width: 8),
//                                 Text('Delete', style: TextStyle(color: Colors.red)),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
                
//                 // Replies
//                 if (comment.replies.isNotEmpty)
//                   Container(
//                     margin: const EdgeInsets.only(left: 20, top: 12),
//                     child: Column(
//                       children: comment.replies.map((reply) => InstagramStyleCommentTile(
//                         comment: reply,
//                         isOwner: reply.userToken == context.read<AuthProvider>().user?.userToken,
//                         formatDate: formatDate,
//                         onLike: onLike,
//                         onReply: onReply,
//                         onEdit: onEdit,
//                         onDelete: onDelete,
//                         onDownload: onDownload, // Pass download function to replies
//                       )).toList(),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ENHANCED: Updated media dialog with download button
//   void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
//     showDialog(
//       context: context,
//       barrierColor: Colors.black87,
//       builder: (context) => Dialog.fullscreen(
//         backgroundColor: Colors.transparent,
//         child: Stack(
//           children: [
//             Center(
//               child: attachment.isImage
//                   ? Hero(
//                       tag: attachment.url,
//                       child: InteractiveViewer(
//                         child: Image.network(
//                           attachment.url,
//                           fit: BoxFit.contain,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return const Center(
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     )
//                   : VideoPlayerWidget(videoUrl: attachment.url),
//             ),
//             // Close button
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 16,
//               right: 16,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.close_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//             // Download button
//             Positioned(
//               top: MediaQuery.of(context).padding.top + 16,
//               right: 72, // Position next to close button
//               child: GestureDetector(
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await onDownload(attachment);
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.download_rounded,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ENHANCED: Video thumbnail with download button
// class VideoThumbnailWidget extends StatelessWidget {
//   final String videoUrl;
//   final String? thumbnailUrl;

//   const VideoThumbnailWidget({
//     super.key,
//     required this.videoUrl,
//     this.thumbnailUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           if (thumbnailUrl != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 thumbnailUrl!,
//                 width: double.infinity,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.play_arrow,
//               size: 32,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _isPlaying = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
    
//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted && _isPlaying) {
//         setState(() => _showControls = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _isPlaying ? _controller.play() : _controller.pause();
//       _showControls = true;
//     });

//     if (_isPlaying) {
//       Future.delayed(const Duration(seconds: 3), () {
//         if (mounted && _isPlaying) {
//           setState(() => _showControls = false);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => setState(() => _showControls = !_showControls),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Colors.black,
//               ),
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: VideoPlayer(_controller),
//                     ),
//                     if (_showControls)
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.black.withOpacity(0.3),
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     if (_showControls)
//                       GestureDetector(
//                         onTap: _togglePlayPause,
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.5),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
//                             size: 32,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             );
//           } else {
//             return Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class ProfilePhotoViewer extends StatelessWidget {
//   final String imageUrl;
//   const ProfilePhotoViewer({super.key, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: InteractiveViewer(
//                 panEnabled: true,
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Hero(
//                   tag: imageUrl,
//                   child: Image.network(
//                     imageUrl,
//                     fit: BoxFit.contain,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                               : null,
//                           valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return const Center(
//                         child: Icon(Icons.error, color: Colors.white, size: 48),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 20,
//               left: 20,
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:moments/models/comment_model.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:moments/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CommentSection extends StatefulWidget {
  final String eventToken;
  final ScrollController scrollController;
  
  const CommentSection({
    super.key, 
    required this.eventToken,
    required this.scrollController,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> 
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<CommentModel> _comments = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 20;
  final List<File> _selectedMedia = [];
  bool _isPosting = false;
  double _uploadProgress = 0.0;
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  String? _replyingTo;
  CommentModel? _editingComment;
  late AnimationController _inputAnimationController;
  late AnimationController _progressAnimationController;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadComments();
    _focusNode.addListener(_onFocusChange);
    widget.scrollController.addListener(_onScroll);
    _inputAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _inputAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _inputAnimationController.forward();
      if (_showEmojiPicker) {
        setState(() => _showEmojiPicker = false);
      }
    } else {
      _inputAnimationController.reverse();
    }
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >= 
        widget.scrollController.position.maxScrollExtent * 0.9) {
      _loadMoreComments();
    }
  }

  Future<void> _refreshComments() async {
    setState(() {
      _page = 1;
      _hasMore = true;
    });
    await _loadComments();
  }

  Future<void> _loadComments() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      final authProvider = context.read<AuthProvider>();
      final response = await NetworkService.getEventComments(
        eventToken: widget.eventToken,
        page: _page,
        limit: _limit,
        userToken: authProvider.user?.userToken,
      );

      if (_page == 1) {
        _comments.clear();
      }

      final List<CommentModel> newComments = response['comments'];
      setState(() {
        _comments.addAll(newComments);
        _hasMore = _comments.length < response['total'];
        _page += 1;
      });
    } catch (e) {
      if (mounted) {
        _showSnackBar("Error loading comments: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMoreComments() async {
    if (_hasMore && !_isLoading) {
      await _loadComments();
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> _downloadMedia(MediaAttachment attachment) async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showSnackBar("Storage permission is required to download media", isError: true);
        return;
      }

      _showSnackBar("Downloading...", isError: false);

      Directory? directory;
      String fileName;
      
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsDir = Directory('${directory.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          directory = downloadsDir;
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        _showSnackBar("Could not access storage directory", isError: true);
        return;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = attachment.isImage ? 'jpg' : 'mp4';
      fileName = 'moments_${attachment.isImage ? 'image' : 'video'}_$timestamp.$extension';
      
      final filePath = '${directory.path}/$fileName';

      await _dio.download(
        attachment.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            // Show download progress
          }
        },
      );

      _showSnackBar("Downloaded successfully!", isError: false);

    } catch (e) {
      _showSnackBar("Download failed: ${e.toString()}", isError: true);
    }
  }

  Future<void> _postComment() async {
    if (_isPosting) return;
    
    final content = _controller.text.trim();
    if (content.isEmpty && _selectedMedia.isEmpty) {
      _showSnackBar("Please add content or media", isError: true);
      return;
    }

    if (_selectedMedia.length > 5) {
      _showSnackBar("Maximum 5 files allowed per comment", isError: true);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) {
      _showSnackBar("You need to be logged in to comment", isError: true);
      return;
    }

    setState(() {
      _isPosting = true;
      _uploadProgress = 0.0;
    });
    _progressAnimationController.forward();

    try {
      CommentModel comment;
      
      if (_editingComment != null) {
        comment = await NetworkService.updateComment(
          content: content,
          commentToken: _editingComment!.commentToken,
          userToken: authProvider.user!.userToken,
          mediaFiles: _selectedMedia,
          onProgress: (progress) {
            setState(() => _uploadProgress = progress);
          },
        );

        _updateCommentInList(comment);
        _showSnackBar("Comment updated successfully!", isError: false);
        
      } else if (_replyingTo != null) {
        comment = await NetworkService.createReply(
          content: content,
          userToken: authProvider.user!.userToken,
          commentToken: _replyingTo!,
          mediaFiles: _selectedMedia,
          onProgress: (progress) {
            setState(() => _uploadProgress = progress);
          },
        );
        
        _addReplyToList(comment);
        _showSnackBar("Reply posted successfully!", isError: false);
        
      } else {
        comment = await NetworkService.createComment(
          content: content,
          eventToken: widget.eventToken,
          userToken: authProvider.user!.userToken,
          mediaFiles: _selectedMedia,
          onProgress: (progress) {
            setState(() => _uploadProgress = progress);
          },
        );
        
        setState(() {
          _comments.insert(0, comment);
        });
        _showSnackBar("Comment posted successfully!", isError: false);
      }
      
      _clearForm();
      
    } catch (e) {
      _showSnackBar("Error posting comment: ${e.toString()}", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
          _uploadProgress = 0.0;
        });
        _progressAnimationController.reverse();
      }
    }
  }

  void _updateCommentInList(CommentModel updatedComment) {
    setState(() {
      for (int i = 0; i < _comments.length; i++) {
        if (_comments[i].commentToken == updatedComment.commentToken) {
          _comments[i] = updatedComment;
          return;
        }
        for (int j = 0; j < _comments[i].replies.length; j++) {
          if (_comments[i].replies[j].commentToken == updatedComment.commentToken) {
            _comments[i].replies[j] = updatedComment;
            return;
          }
        }
      }
    });
  }

  void _addReplyToList(CommentModel reply) {
    setState(() {
      bool added = false;
      for (int i = 0; i < _comments.length; i++) {
        if (_comments[i].commentToken == _replyingTo) {
          _comments[i].replies.add(reply);
          _comments[i] = _comments[i].copyWith(
            replyCount: _comments[i].replyCount + 1,
          );
          added = true;
          break;
        }
        for (int j = 0; j < _comments[i].replies.length; j++) {
          if (_comments[i].replies[j].commentToken == _replyingTo) {
            _comments.insert(0, reply);
            added = true;
            break;
          }
        }
        if (added) break;
      }
      
      if (!added) {
        _comments.insert(0, reply);
      }
    });
  }

  void _clearForm() {
    setState(() {
      _controller.clear();
      _selectedMedia.clear();
      _replyingTo = null;
      _editingComment = null;
      _focusNode.unfocus();
      _showEmojiPicker = false;
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE53E3E) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Future<void> _pickMedia() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultipleMedia(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          if (_selectedMedia.length >= 5) break;
          
          final file = File(pickedFile.path);
          final fileSize = await file.length();
          
          if (fileSize > 50 * 1024 * 1024) { // 50MB limit
            _showSnackBar("File size should be less than 50MB", isError: true);
            continue;
          }

          setState(() => _selectedMedia.add(file));
        }
      }
    } catch (e) {
      _showSnackBar("Error picking media: ${e.toString()}", isError: true);
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() {
          if (_selectedMedia.length < 5) {
            _selectedMedia.add(file);
          }
        });
      }
    } catch (e) {
      _showSnackBar("Error taking photo: ${e.toString()}", isError: true);
    }
  }

  Future<void> _pickVideoFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 10),
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final fileSize = await file.length();
        
        if (fileSize > 50 * 1024 * 1024) { // 50MB limit
          _showSnackBar("Video size should be less than 50MB", isError: true);
          return;
        }

        setState(() {
          if (_selectedMedia.length < 5) {
            _selectedMedia.add(file);
          }
        });
      }
    } catch (e) {
      _showSnackBar("Error recording video: ${e.toString()}", isError: true);
    }
  }


Widget _buildMediaPreview(File file, int index) {
  final isImage = _isImageFile(file.path);
  final fileName = file.path.split('/').last;
  final fileSize = _formatFileSize(file.lengthSync());

  return Container(
    width: 80,
    height: 80,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          if (isImage)
            Image.file(
              file, 
              fit: BoxFit.cover, 
              width: 80, 
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return _buildPreviewFallback(isImage: true);
              },
            )
          else
            FutureBuilder<Widget>(
              future: _buildVideoPreview(file),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? _buildPreviewFallback(isImage: false);
                }
                return _buildPreviewFallback(isImage: false);
              },
            ),
          
          // File size indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                fileSize,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          // Remove button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _selectedMedia.removeAt(index)),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<Widget> _buildVideoPreview(File file) async {
  try {
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    final videoWidget = VideoPlayer(controller);
    await controller.dispose(); // Dispose immediately since we just want a frame
    
    return videoWidget;
  } catch (e) {
    return _buildPreviewFallback(isImage: false);
  }
}

Widget _buildPreviewFallback({required bool isImage}) {
  return Container(
    color: isImage ? Colors.grey[300] : const Color(0xFF374151),
    child: Center(
      child: Icon(
        isImage ? Icons.broken_image : Icons.videocam_rounded,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}

//old working

  // Widget _buildMediaPreview(File file, int index) {
  //   final isImage = _isImageFile(file.path);
  //   final fileName = file.path.split('/').last;
  //   final fileSize = _formatFileSize(file.lengthSync());

  //   return Container(
  //     width: 80,
  //     height: 80,
  //     margin: const EdgeInsets.only(right: 8),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(12),
  //       child: Stack(
  //         children: [
  //           if (isImage)
  //             Image.file(
  //               file, 
  //               fit: BoxFit.cover, 
  //               width: 80, 
  //               height: 80,
  //               errorBuilder: (context, error, stackTrace) {
  //                 return Container(
  //                   color: Colors.grey[300],
  //                   child: const Icon(Icons.broken_image, color: Colors.grey),
  //                 );
  //               },
  //             )
  //           else
  //             Container(
  //               color: const Color(0xFF374151),
  //               child: const Center(
  //                 child: Icon(
  //                   Icons.videocam_rounded, 
  //                   size: 32, 
  //                   color: Colors.white
  //                 ),
  //               ),
  //             ),
            
  //           // File size indicator
  //           Positioned(
  //             bottom: 0,
  //             left: 0,
  //             right: 0,
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  //               decoration: BoxDecoration(
  //                 color: Colors.black.withOpacity(0.7),
  //                 borderRadius: const BorderRadius.only(
  //                   bottomLeft: Radius.circular(12),
  //                   bottomRight: Radius.circular(12),
  //                 ),
  //               ),
  //               child: Text(
  //                 fileSize,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //                 textAlign: TextAlign.center,
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
  //           ),
            
  //           // Remove button
  //           Positioned(
  //             top: 4,
  //             right: 4,
  //             child: GestureDetector(
  //               onTap: () => setState(() => _selectedMedia.removeAt(index)),
  //               child: Container(
  //                 padding: const EdgeInsets.all(4),
  //                 decoration: const BoxDecoration(
  //                   color: Color(0xFFE53E3E),
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.close,
  //                   size: 12,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  bool _isImageFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.jpg') || 
           ext.endsWith('.jpeg') || 
           ext.endsWith('.png') || 
           ext.endsWith('.gif') || 
           ext.endsWith('.webp');
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Media',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 20),
              _buildMediaOption(
                icon: Icons.photo_library_rounded,
                title: 'Photo & Video Library',
                subtitle: 'Choose from gallery (max 50MB per file)',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickMedia();
                },
                color: const Color(0xFF3B82F6),
              ),
              _buildMediaOption(
                icon: Icons.camera_alt_rounded,
                title: 'Take Photo',
                subtitle: 'Capture with camera',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromCamera();
                },
                color: const Color(0xFF10B981),
              ),
              _buildMediaOption(
                icon: Icons.videocam_rounded,
                title: 'Record Video',
                subtitle: 'Capture video (max 10 minutes)',
                onTap: () async {
                  Navigator.pop(context);
                  await _pickVideoFromCamera();
                },
                color: const Color(0xFFE53E3E),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleLike(CommentModel comment) async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final originalLikeCount = comment.likeCount;
    final originalIsLiked = comment.isLiked;
    
    setState(() {
      _updateCommentLikeStatus(
        comment.commentToken, 
        !comment.isLiked, 
        comment.isLiked ? comment.likeCount - 1 : comment.likeCount + 1
      );
    });

    try {
      final result = await NetworkService.toggleCommentLike(
        commentToken: comment.commentToken,
        userToken: authProvider.user!.userToken,
      );

      setState(() {
        _updateCommentLikeStatus(
          comment.commentToken, 
          result['isLiked'], 
          result['likeCount']
        );
      });
    } catch (e) {
      setState(() {
        _updateCommentLikeStatus(comment.commentToken, originalIsLiked, originalLikeCount);
      });
      _showSnackBar("Error toggling like: ${e.toString()}", isError: true);
    }
  }

  void _updateCommentLikeStatus(String commentToken, bool isLiked, int likeCount) {
    for (int i = 0; i < _comments.length; i++) {
      if (_comments[i].commentToken == commentToken) {
        _comments[i] = _comments[i].copyWith(
          isLiked: isLiked,
          likeCount: likeCount,
        );
        return;
      }
      for (int j = 0; j < _comments[i].replies.length; j++) {
        if (_comments[i].replies[j].commentToken == commentToken) {
          _comments[i].replies[j] = _comments[i].replies[j].copyWith(
            isLiked: isLiked,
            likeCount: likeCount,
          );
          return;
        }
      }
    }
  }

  void _startReply(CommentModel comment) {
    setState(() {
      _replyingTo = comment.commentToken;
      _editingComment = null;
      _controller.clear();
      _selectedMedia.clear();
      _focusNode.requestFocus();
    });
  }

  void _startEdit(CommentModel comment) {
    setState(() {
      _editingComment = comment;
      _replyingTo = null;
      _controller.text = comment.content;
      _selectedMedia.clear();
      _focusNode.requestFocus();
    });
  }

  Future<void> _deleteComment(CommentModel comment) async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Comment",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to delete this comment? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await NetworkService.deleteComment(
        commentToken: comment.commentToken,
        userToken: authProvider.user!.userToken,
      );

      if (success && mounted) {
        setState(() {
          _removeCommentFromList(comment.commentToken);
        });
        _showSnackBar("Comment deleted successfully", isError: false);
      } else {
        _showSnackBar("Failed to delete comment", isError: true);
      }
    } catch (e) {
      _showSnackBar("Error deleting comment: ${e.toString()}", isError: true);
    }
  }

  void _removeCommentFromList(String commentToken) {
    _comments.removeWhere((comment) => comment.commentToken == commentToken);
    
    for (int i = 0; i < _comments.length; i++) {
      final initialReplyCount = _comments[i].replies.length;
      _comments[i].replies.removeWhere((reply) => reply.commentToken == commentToken);
      
      if (_comments[i].replies.length != initialReplyCount) {
        _comments[i] = _comments[i].copyWith(
          replyCount: _comments[i].replies.length,
        );
      }
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  Widget _buildStickyInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Upload progress bar
          if (_isPosting && _uploadProgress > 0)
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 16,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                  ),
                ],
              ),
            ),

          // Selected media preview
          if (_selectedMedia.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected files: ${_selectedMedia.length}/5',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedMedia.length,
                      itemBuilder: (context, index) {
                        return _buildMediaPreview(_selectedMedia[index], index);
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Reply/Edit indicator
          if (_replyingTo != null || _editingComment != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _editingComment != null ? Icons.edit : Icons.reply,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _editingComment != null 
                          ? "Editing comment..." 
                          : "Replying...",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyingTo = null;
                        _editingComment = null;
                        _controller.clear();
                        _selectedMedia.clear();
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: _toggleEmojiPicker,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                _showEmojiPicker 
                                    ? Icons.keyboard 
                                    : Icons.emoji_emotions_outlined,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              maxLines: null,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: _editingComment != null
                                    ? "Edit your comment..."
                                    : "Add a comment...",
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _showMediaOptions,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.grey[600],
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: !_isPosting ? _postComment : null,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _isPosting 
                            ? Colors.grey[400] 
                            : Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: _isPosting
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share your thoughts!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _comments.isEmpty && !_isLoading
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _refreshComments,
                  child: ListView.builder(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _comments.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= _comments.length) {
                        return _isLoading
                            ? Container(
                                padding: const EdgeInsets.all(20),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }

                      final comment = _comments[index];
                      final authProvider = context.watch<AuthProvider>();
                      final isOwner = authProvider.user?.userToken == comment.userToken;

                      return InstagramStyleCommentTile(
                        comment: comment,
                        isOwner: isOwner,
                        formatDate: _formatDate,
                        onLike: _toggleLike,
                        onReply: _startReply,
                        onEdit: isOwner ? _startEdit : null,
                        onDelete: isOwner ? _deleteComment : null,
                        onDownload: _downloadMedia,
                      );
                    },
                  ),
                ),
        ),

        _buildStickyInput(),

        if (_showEmojiPicker)
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                _controller.text += emoji.emoji;
              },
              config: Config(
                emojiViewConfig: const EmojiViewConfig(
                  emojiSizeMax: 28,
                  backgroundColor: Colors.white,
                ),
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: BottomActionBarConfig(
                  backgroundColor: Colors.grey[50]!,
                ),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
      ],
    );
  }
}


// Rest of the classes remain the same (InstagramStyleCommentTile, VideoThumbnailWidget, etc.)
class InstagramStyleCommentTile extends StatelessWidget {
  final CommentModel comment;
  final bool isOwner;
  // final String Function(String) formatDate;
  final String Function(DateTime) formatDate;
  final void Function(CommentModel) onLike;  // Changed to accept CommentModel
  final void Function(CommentModel) onReply; // Changed to accept CommentModel
  final void Function(CommentModel)? onEdit; // Changed to accept CommentModel
  final void Function(CommentModel)? onDelete; // Changed to accept CommentModel
  final Future<void> Function(MediaAttachment) onDownload;

  const InstagramStyleCommentTile({
    super.key,
    required this.comment,
    required this.isOwner,
    required this.formatDate,
    required this.onLike,
    required this.onReply,
    this.onEdit,
    this.onDelete,
    required this.onDownload,
  });

  void _showProfilePhoto(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, _) => ProfilePhotoViewer(imageUrl: imageUrl),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture with tap to view
          GestureDetector(
            onTap: () {
              if (comment.userPhoto != null && comment.userPhoto!.isNotEmpty) {
                _showProfilePhoto(
                  context, 
                  NetworkService.getImageUrl(comment.userPhoto!)
                );
              }
            },
            child: Hero(
              tag: 'profile_${comment.userToken}',
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 0.5,
                  ),
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
                  backgroundImage: (comment.userPhoto != null && comment.userPhoto!.isNotEmpty)
                      ? NetworkImage(NetworkService.getImageUrl(comment.userPhoto!))
                      : null,
                  backgroundColor: Colors.grey[200],
                  child: (comment.userPhoto == null || comment.userPhoto!.isEmpty)
                      ? Text(
                          comment.userName != null && comment.userName!.isNotEmpty
                              ? comment.userName![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and content in one line (Instagram style)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: comment.userName ?? 'Anonymous',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (comment.content.isNotEmpty) ...[
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: comment.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Media attachments with download button
                if (comment.attachments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...comment.attachments.map((attachment) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _showMediaDialog(context, attachment),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: attachment.isImage
                                ? Hero(
                                    tag: attachment.url,
                                    child: Image.network(
                                      attachment.url,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[100],
                                          child: const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[100],
                                          child: Center(
                                            child: Icon(Icons.broken_image, color: Colors.grey[400]),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : VideoThumbnailWidget(
                                    videoUrl: attachment.url,
                                    thumbnailUrl: attachment.thumbnailUrl,
                                  ),
                          ),
                        ),
                        // Download button overlay
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => onDownload(attachment),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.download_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
                
                const SizedBox(height: 8),
                
                // Action row (like Instagram)
                Row(
                  children: [
                    Text(
                      formatDate(comment.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (comment.likeCount > 0) ...[
                      const SizedBox(width: 16),
                      Text(
                        '${comment.likeCount} ${comment.likeCount == 1 ? 'like' : 'likes'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => onReply(comment),
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => onLike(comment),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          comment.isLiked ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(comment.isLiked),
                          size: 16,
                          color: comment.isLiked ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_horiz, size: 16, color: Colors.grey[500]),
                        iconSize: 16,
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'edit' && onEdit != null) {
                            onEdit!(comment); // Pass the comment object
                          } else if (value == 'delete' && onDelete != null) {
                            onDelete!(comment); // Pass the comment object
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            height: 40,
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            height: 40,
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                
                // Replies - FIXED VERSION
                if (comment.replies.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 12),
                    child: Column(
                      children: comment.replies.map((reply) {
                        // Get the current user to check ownership for each reply
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final isReplyOwner = authProvider.user?.userToken == reply.userToken;
                        
                        return InstagramStyleCommentTile(
                          comment: reply,
                          isOwner: isReplyOwner, // Use the reply's ownership, not parent's
                          formatDate: formatDate,
                          onLike: onLike,     // Pass the same callback
                          onReply: onReply,   // Pass the same callback
                          onEdit: isReplyOwner ? onEdit : null,   // Only if reply owner
                          onDelete: isReplyOwner ? onDelete : null, // Only if reply owner
                          onDownload: onDownload,
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMediaDialog(BuildContext context, MediaAttachment attachment) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: attachment.isImage
                  ? Hero(
                      tag: attachment.url,
                      child: InteractiveViewer(
                        child: Image.network(
                          attachment.url,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : VideoPlayerWidget(videoUrl: attachment.url),
            ),
            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            // Download button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 72,
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await onDownload(attachment);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//old working code

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    try {
      _controller = VideoPlayerController.network(widget.videoUrl);
      await _controller.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing video controller: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Try to show thumbnail first, then video frame, then fallback
          if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
            // Thumbnail from server
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.thumbnailUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingState();
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildVideoFrameOrFallback();
                },
              ),
            )
          else
            // No thumbnail provided, try to show video frame
            _buildVideoFrameOrFallback(),

          // Play button overlay
          if (_isInitialized || widget.thumbnailUrl != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 32,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoFrameOrFallback() {
    if (_isInitialized) {
      // Show actual video frame
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: VideoPlayer(_controller),
      );
    } else if (_hasError) {
      // Show error state
      return Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 48, color: Colors.grey[500]),
            const SizedBox(height: 8),
            Text(
              'Video unavailable',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    } else {
      // Show loading state
      return _buildLoadingState();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
        ),
      ),
    );
  }
}

// class VideoThumbnailWidget extends StatelessWidget {
//   final String videoUrl;
//   final String? thumbnailUrl;

//   const VideoThumbnailWidget({
//     super.key,
//     required this.videoUrl,
//     this.thumbnailUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           if (thumbnailUrl != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 thumbnailUrl!,
//                 width: double.infinity,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.black.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.play_arrow,
//               size: 32,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
      _showControls = true;
    });

    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showControls = !_showControls),
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: VideoPlayer(_controller),
                    ),
                    if (_showControls)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    if (_showControls)
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfilePhotoViewer extends StatelessWidget {
  final String imageUrl;
  const ProfilePhotoViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: imageUrl,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.white, size: 48),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





