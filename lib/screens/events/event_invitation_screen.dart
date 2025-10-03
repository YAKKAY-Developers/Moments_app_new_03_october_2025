// import 'package:flutter/material.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;

//   const EventInvitationScreen({super.key, required this.eventToken});

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final List<String> _invitedNumbers = [];
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite People'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _sendInvitations,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: _addPhoneNumber,
//                 ),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _invitedNumbers.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_invitedNumbers[index]),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.remove),
//                       onPressed: () => _removePhoneNumber(index),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _addPhoneNumber() {
//     final phone = _phoneController.text.trim();
//     if (phone.isNotEmpty && !_invitedNumbers.contains(phone)) {
//       setState(() {
//         _invitedNumbers.add(phone);
//         _phoneController.clear();
//       });
//     }
//   }

//   void _removePhoneNumber(int index) {
//     setState(() {
//       _invitedNumbers.removeAt(index);
//     });
//   }

//   Future<void> _sendInvitations() async {
//     if (_invitedNumbers.isEmpty) return;

//     setState(() => _isLoading = true);

//     try {
//       final result = await NetworkService.inviteUsers(
//         eventToken: widget.eventToken,
//         phoneNumbers: _invitedNumbers,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${result['message']} - Sent ${_invitedNumbers.length} invitations'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to send invitations: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
// }



































// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;

//   const EventInvitationScreen({super.key, required this.eventToken});

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final List<String> _invitedNumbers = [];
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite People'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _isLoading ? null : _sendInvitations,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.contacts),
//                   label: const Text('Pick from Contacts'),
//                   onPressed: _isLoading ? null : _pickContacts,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _isLoading ? null : _addPhoneNumber,
//                     ),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _invitedNumbers.isEmpty
//                       ? const Center(child: Text('No contacts added yet.'))
//                       : ListView.builder(
//                           itemCount: _invitedNumbers.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(_invitedNumbers[index]),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.remove_circle, color: Colors.red),
//                                 onPressed: _isLoading ? null : () => _removePhoneNumber(index),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }

//   void _addPhoneNumber() {
//     final phone = _cleanPhoneNumber(_phoneController.text.trim());
//     if (phone.isNotEmpty && !_invitedNumbers.contains(phone)) {
//       setState(() {
//         _invitedNumbers.add(phone);
//         _phoneController.clear();
//       });
//     }
//   }

//   void _removePhoneNumber(int index) {
//     setState(() {
//       _invitedNumbers.removeAt(index);
//     });
//   }

//   String _cleanPhoneNumber(String phone) {
//     return phone.replaceAll(RegExp(r'\D'), '');
//   }

//   Future<void> _pickContacts() async {
//     if (!await FlutterContacts.requestPermission()) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Contacts permission denied. Please enable it in settings.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       return;
//     }

//     try {
//       final contacts = await FlutterContacts.getContacts(withProperties: true);

//       if (mounted) {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           builder: (_) => SizedBox(
//             height: MediaQuery.of(context).size.height * 0.7,
//             child: ListView.builder(
//               itemCount: contacts.length,
//               itemBuilder: (context, index) {
//                 final contact = contacts[index];
//                 final phone = contact.phones.isNotEmpty
//                     ? _cleanPhoneNumber(contact.phones.first.number)
//                     : '';

//                 if (phone.isEmpty) return const SizedBox.shrink();

//                 return ListTile(
//                   leading: (contact.photoOrThumbnail != null && contact.photoOrThumbnail!.isNotEmpty)
//                       ? CircleAvatar(backgroundImage: MemoryImage(contact.photoOrThumbnail!))
//                       : const CircleAvatar(child: Icon(Icons.person)),
//                   title: Text(contact.displayName),
//                   subtitle: Text(phone),
//                   onTap: () {
//                     if (!_invitedNumbers.contains(phone)) {
//                       setState(() {
//                         _invitedNumbers.add(phone);
//                       });
//                     }
//                     Navigator.pop(context);
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch contacts: $e'), backgroundColor: Colors.red),
//         );
//       }
//     }
//   }

//   Future<void> _sendInvitations() async {
//     if (_invitedNumbers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one phone number.')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // ignore: unused_local_variable
//       final result = await NetworkService.inviteUsers(
//         eventToken: widget.eventToken,
//         phoneNumbers: _invitedNumbers,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Invitations sent successfully to ${_invitedNumbers.length} contacts.'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send invitations: $e'), backgroundColor: Colors.red),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
// }















// import 'package:flutter/material.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const EventInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final List<String> _invitedNumbers = [];
// final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite People'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _isLoading ? null : _sendInvitations,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.contacts),
//                   label: const Text('Pick from Contacts'),
//                   onPressed: _isLoading ? null : _pickContact,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _isLoading ? null : _addPhoneNumber,
//                     ),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _invitedNumbers.isEmpty
//                       ? const Center(child: Text('No contacts added yet'))
//                       : ListView.builder(
//                           itemCount: _invitedNumbers.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(_invitedNumbers[index]),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.remove_circle, color: Colors.red),
//                                 onPressed: _isLoading ? null : () => _removePhoneNumber(index),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.3),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }

//   void _addPhoneNumber() {
//     final phone = _cleanPhoneNumber(_phoneController.text.trim());
//     if (phone.isNotEmpty && !_invitedNumbers.contains(phone)) {
//       setState(() {
//         _invitedNumbers.add(phone);
//         _phoneController.clear();
//       });
//     }
//   }

//   void _removePhoneNumber(int index) {
//     setState(() {
//       _invitedNumbers.removeAt(index);
//     });
//   } 

//   String _cleanPhoneNumber(String phone) {
//     return phone.replaceAll(RegExp(r'[^0-9+]'), '');
//   }

// Future<void> _pickContact() async {
//   try {
//     final Contact? contact = await _contactPicker.selectContact();
//     if (contact != null && contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty) {
//       final phone = _cleanPhoneNumber(contact.phoneNumbers!.first);
//       if (!_invitedNumbers.contains(phone)) {
//         setState(() {
//           _invitedNumbers.add(phone);
//         });
//       }
//     } else {
//       _showMessage('Selected contact has no phone number');
//     }
//   } catch (e) {
//     _showMessage('Failed to pick contact: $e');
//   }
// }

// // Future<void> _sendInvitations() async {
// //   if (_invitedNumbers.isEmpty) {
// //     _showMessage('Please add at least one phone number');
// //     return;
// //   }

// //   setState(() => _isLoading = true);

// //   try {
// //     final result = await NetworkService.inviteUsers(
// //       eventToken: widget.eventToken,
// //       phoneNumbers: _invitedNumbers,
// //     );

// //     final message =
// //         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
// //         "Join us at: ${widget.shareLink}\n\n"
// //         "Download the app if you don't have it: https://play.google.com/store/apps/details?id=com.yourapp";

// //     final uri = Uri(scheme: 'sms', queryParameters: {'body': message});

// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri);
// //     } else {
// //       _showMessage('No SMS app found on your device. Please install a messaging app.');
// //     }

// //     if (mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('${result['message']} - Sent ${_invitedNumbers.length} invitations'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       Navigator.pop(context);
// //     }
// //   } catch (e) {
// //     _showMessage('Failed to send invitations: $e');
// //   } finally {
// //     setState(() => _isLoading = false);
// //   }
// // }


// //   void _showMessage(String message) {
// //     if (mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(message)),
// //       );
// //     }
// //   }
// // }


//   Future<void> _sendInvitations() async {
//     if (_invitedNumbers.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one phone number.')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Save invited users to your backend
//       await NetworkService.inviteUsers(
//         eventToken: widget.eventToken,
//         phoneNumbers: _invitedNumbers,
//       );

//       // Prepare SMS message
//       // final message ="Hey! You're invited to '${widget.eventName}' by ${widget.organizerName}. Join us!";
//     final message =
//         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
//         "Join us at: ${widget.shareLink}\n\n"
//         "Download the app if you don't have it: https://play.google.com/store/apps/details?id=com.yourapp";

//       // Prepare URI with all numbers
//       final uri = Uri(
//         scheme: 'sms',
//         path: _invitedNumbers.join(','),
//         queryParameters: {'body': message},
//       );

//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         throw 'Could not open SMS app.';
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('SMS app opened for ${_invitedNumbers.length} contacts.'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send invitations: $e'), backgroundColor: Colors.red),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }


//   void _showMessage(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
// }





// ignore_for_file: deprecated_member_use, unused_field

// import 'package:flutter/material.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const EventInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final List<String> _invitedNumbers = [];
//   final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
//   bool _isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite People'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _isLoading ? null : _sendInvitations,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.contacts),
//                   label: const Text('Pick from Contacts'),
//                   onPressed: _isLoading ? null : _pickContact,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _isLoading ? null : _addPhoneNumber,
//                     ),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _invitedNumbers.isEmpty
//                       ? const Center(child: Text('No contacts added yet'))
//                       : ListView.builder(
//                           itemCount: _invitedNumbers.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(_invitedNumbers[index]),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.remove_circle, color: Colors.red),
//                                 onPressed: _isLoading ? null : () => _removePhoneNumber(index),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               // ignore: deprecated_member_use
//               color: Colors.black.withOpacity(0.3),
//               child: const Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       ),
//     );
//   }

//   void _addPhoneNumber() {
//     final phone = _cleanPhoneNumber(_phoneController.text.trim());
//     if (phone.isNotEmpty && !_invitedNumbers.contains(phone)) {
//       setState(() {
//         _invitedNumbers.add(phone);
//         _phoneController.clear();
//       });
//     }
//   }

//   void _removePhoneNumber(int index) {
//     setState(() {
//       _invitedNumbers.removeAt(index);
//     });
//   }

//   String _cleanPhoneNumber(String phone) {
//     return phone.replaceAll(RegExp(r'[^0-9+]'), '');
//   }

//   Future<void> _pickContact() async {
//     try {
//       final Contact? contact = await _contactPicker.selectContact();
//       if (contact != null && contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty) {
//         final phone = _cleanPhoneNumber(contact.phoneNumbers!.first);
//         if (!_invitedNumbers.contains(phone)) {
//           setState(() {
//             _invitedNumbers.add(phone);
//           });
//         }
//       } else {
//         _showMessage('Selected contact has no phone number');
//       }
//     } catch (e) {
//       _showMessage('Failed to pick contact: $e');
//     }
//   }


// Future<void> _sendInvitations() async {
//   if (_invitedNumbers.isEmpty) {
//     _showMessage('Please add at least one phone number.');
//     return;
//   }

//   setState(() => _isLoading = true);

//   try {
//     final result = await NetworkService.inviteUsers(
//       eventToken: widget.eventToken,
//       phoneNumbers: _invitedNumbers,
//     );

//     final successfulInvites = (result['data'] as List)
//         .where((e) => e['status'] == 'invited')
//         .length;

//     final failedInvites = (result['data'] as List)
//         .where((e) => e['status'] != 'invited')
//         .length;

//     final message = 
//         "Invited: $successfulInvites\n"
//         "Failed/Existing: $failedInvites\n\n"
//         "Now share the invitation link.";

//     final shareText =
//         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
//         "Join us: ${widget.shareLink}\n\n"
//         "Download the app:\n"
//         "https://play.google.com/store/apps/details?id=com.yourapp";

//     await Share.share(shareText);

//     _showMessage(message);
//     Navigator.pop(context);
//   } catch (e) {
//     _showMessage('Failed to send invitations: $e');
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }

// // Future<void> _sendInvitations() async {
// //   if (_invitedNumbers.isEmpty) {
// //     _showMessage('Please add at least one phone number.');
// //     return;
// //   }

// //   setState(() => _isLoading = true);

// //   try {
// //     // Call your backend
// //     await NetworkService.inviteUsers(
// //       eventToken: widget.eventToken,
// //       phoneNumbers: _invitedNumbers,
// //     );

// //     // Construct invitation message
// //     final message =
// //         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
// //         "Join us at: ${widget.shareLink}\n\n"
// //         "Download the app if you don't have it:\n"
// //         "https://play.google.com/store/apps/details?id=com.yourapp";

// //     // Share using system share sheet
// //     // ignore: deprecated_member_use
// //     await Share.share(message);

// //     if (mounted) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Invitation message ready to share.'),
// //           backgroundColor: Colors.green,
// //         ),
// //       );
// //       Navigator.pop(context);
// //     }
// //   } catch (e) {
// //     _showMessage('Failed to send invitations: $e');
// //   } finally {
// //     setState(() => _isLoading = false);
// //   }
// // }

//   void _showMessage(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
// }































































//working code need changes

// import 'package:flutter/material.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:moments/network_service/network_service.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const EventInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final List<String> _invitedNumbers = [];
//   final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite People'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _isLoading ? null : _sendInvitations,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.contacts),
//                   label: const Text('Pick from Contacts'),
//                   onPressed: _isLoading ? null : _pickContact,
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     hintText: 'Enter phone number with country code',
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: _isLoading ? null : _addPhoneNumber,
//                     ),
//                   ),
//                   keyboardType: TextInputType.phone,
//                   onSubmitted: (_) => _addPhoneNumber(),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: _invitedNumbers.isEmpty
//                       ? const Center(
//                           child: Text(
//                             'No contacts added yet',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: _invitedNumbers.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(
//                                 _formatPhoneNumber(_invitedNumbers[index]),
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(Icons.remove_circle, 
//                                     color: Colors.red),
//                                 onPressed: _isLoading 
//                                     ? null 
//                                     : () => _removePhoneNumber(index),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             const ModalBarrier(
//               color: Colors.black54,
//               dismissible: false,
//             ),
//           if (_isLoading)
//             const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }

//   String _formatPhoneNumber(String phone) {
//     // Format phone number for better readability
//     if (phone.length > 10) {
//       return '+${phone.substring(0, phone.length - 10)} '
//           '${phone.substring(phone.length - 10, phone.length - 7)} '
//           '${phone.substring(phone.length - 7, phone.length - 4)} '
//           '${phone.substring(phone.length - 4)}';
//     }
//     return phone;
//   }

//   void _addPhoneNumber() {
//     final phone = _cleanPhoneNumber(_phoneController.text.trim());
//     if (phone.isEmpty) {
//       _showMessage('Please enter a valid phone number');
//       return;
//     }

//     if (!_isValidPhoneNumber(phone)) {
//       _showMessage('Please enter a valid 10-15 digit phone number');
//       return;
//     }

//     if (_invitedNumbers.contains(phone)) {
//       _showMessage('This number is already added');
//       return;
//     }

//     setState(() {
//       _invitedNumbers.add(phone);
//       _phoneController.clear();
//     });
//   }

//   bool _isValidPhoneNumber(String phone) {
//     return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
//   }

//   void _removePhoneNumber(int index) {
//     setState(() {
//       _invitedNumbers.removeAt(index);
//     });
//   }

//   String _cleanPhoneNumber(String phone) {
//     // Remove all non-digit characters except +
//     return phone.replaceAll(RegExp(r'[^0-9+]'), '');
//   }

//   Future<void> _pickContact() async {
//     try {
//       final Contact? contact = await _contactPicker.selectContact();
//       if (contact != null && contact.phoneNumbers != null && 
//           contact.phoneNumbers!.isNotEmpty) {
//         final phone = _cleanPhoneNumber(contact.phoneNumbers!.first);
        
//         if (!_isValidPhoneNumber(phone)) {
//           _showMessage('Selected contact has an invalid phone number');
//           return;
//         }

//         if (!_invitedNumbers.contains(phone)) {
//           setState(() {
//             _invitedNumbers.add(phone);
//           });
//         } else {
//           _showMessage('This number is already added');
//         }
//       } else {
//         _showMessage('Selected contact has no phone number');
//       }
//     } catch (e) {
//       _showMessage('Failed to pick contact. Please check permissions');
//       debugPrint('Contact picker error: $e');
//     }
//   }

//   Future<void> _sendInvitations() async {
//     if (_invitedNumbers.isEmpty) {
//       _showMessage('Please add at least one phone number');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final result = await NetworkService.inviteUsers(
//         eventToken: widget.eventToken,
//         phoneNumbers: _invitedNumbers,
//       );

//       // Process backend response
//       final responseData = result['data'] as List;
//       final successfulInvites = responseData
//           .where((e) => e['status'] == 'invited')
//           .length;

//       final failedInvites = responseData
//           .where((e) => e['status'] != 'invited')
//           .length;

//       if (successfulInvites > 0) {
//         // Only share if some invites were successful
//         final shareText = 
//             "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
//             "Join us: ${widget.shareLink}\n\n"
//             "Download the app:\n"
//             "https://play.google.com/store/apps/details?id=com.yourapp";

//         await Share.share(shareText);
//       }

//       _showMessage(
//         'Successfully invited $successfulInvites contacts. '
//         '${failedInvites > 0 ? '$failedInvites failed/existing' : ''}',
//       );

//       if (mounted) {
//         Navigator.pop(context, successfulInvites > 0);
//       }
//     } catch (e) {
//       debugPrint('Invitation error: $e');
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }


//   void _showMessage(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
// import 'package:flutter_native_contact_picker/model/contact.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const EventInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
//   final TextEditingController _searchController = TextEditingController();
  
//   List<Contact> _allContacts = [];
//   List<Contact> _filteredContacts = [];
//   final List<String> _selectedNumbers = [];
//   List<String> _registeredNumbers = [];
//   List<String> _unregisteredNumbers = [];
  
//   bool _isLoading = false;
//   bool _hasLoadedContacts = false;
//   bool _hasCheckedUsers = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//     _searchController.addListener(_filterContacts);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadContacts() async {
//     setState(() => _isLoading = true);
    
//     try {
//       // Get all contacts from device
//       final contacts = await _contactPicker.getAllContacts();
      
//       setState(() {
//         _allContacts = contacts.where((contact) => 
//           contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty
//         ).toList();
//         _filteredContacts = _allContacts;
//         _hasLoadedContacts = true;
//       });
      
//       // Extract phone numbers and check which are registered
//       final phoneNumbers = _allContacts
//           .expand((contact) => contact.phoneNumbers!)
//           .map((phone) => _cleanPhoneNumber(phone))
//           .where((phone) => _isValidPhoneNumber(phone))
//           .toSet()
//           .toList();
      
//       if (phoneNumbers.isNotEmpty) {
//         await _checkRegisteredUsers(phoneNumbers);
//       }
//     } catch (e) {
//       _showMessage('Failed to load contacts: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _filterContacts() {
//     final query = _searchController.text.toLowerCase();
    
//     if (query.isEmpty) {
//       setState(() => _filteredContacts = _allContacts);
//       return;
//     }
    
//     setState(() {
//       _filteredContacts = _allContacts.where((contact) {
//         final nameMatch = contact.fullName?.toLowerCase().contains(query) ?? false;
//         final phoneMatch = contact.phoneNumbers?.any(
//           (phone) => phone.toLowerCase().contains(query)
//         ) ?? false;
        
//         return nameMatch || phoneMatch;
//       }).toList();
//     });
//   }

//   Future<void> _checkRegisteredUsers(List<String> phoneNumbers) async {
//     setState(() => _isLoading = true);

//     try {
//       final result = await NetworkService.checkRegisteredUsers(phoneNumbers);
      
//       setState(() {
//         _registeredNumbers = List<String>.from(result['registered']?.map((user) => user['phone_number']) ?? []);
//         _unregisteredNumbers = List<String>.from(result['unregistered'] ?? []);
//         _hasCheckedUsers = true;
//       });
      
//     } catch (e) {
//       _showMessage('Failed to check users: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _toggleSelection(String phoneNumber) {
//     setState(() {
//       if (_selectedNumbers.contains(phoneNumber)) {
//         _selectedNumbers.remove(phoneNumber);
//       } else {
//         _selectedNumbers.add(phoneNumber);
//       }
//     });
//   }

//   Future<void> _sendInvitations() async {
//     if (_selectedNumbers.isEmpty) {
//       _showMessage('Please select at least one contact');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Separate registered and unregistered numbers from selected ones
//       final selectedRegistered = _selectedNumbers.where(
//         (num) => _registeredNumbers.contains(num)
//       ).toList();
      
//       final selectedUnregistered = _selectedNumbers.where(
//         (num) => _unregisteredNumbers.contains(num)
//       ).toList();

//       // Invite registered users to the event
//       if (selectedRegistered.isNotEmpty) {
//         final result = await NetworkService.inviteUsers(
//           eventToken: widget.eventToken,
//           phoneNumbers: selectedRegistered,
//         );

//         final successfulInvites = (result['data'] as List)
//             .where((e) => e['status'] == 'invited')
//             .length;

//         _showMessage('Successfully invited $successfulInvites users to the event');
//       }

//       // Send app download invites to unregistered users
//       if (selectedUnregistered.isNotEmpty) {
//         await _inviteUnregisteredUsers(selectedUnregistered);
//       }

//       // Clear selection after sending
//       setState(() => _selectedNumbers.clear());

//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _inviteUnregisteredUsers(List<String> phoneNumbers) async {
//     final shareText = 
//         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
//         "Join the event by downloading Moments app:\n"
//         "https://play.google.com/store/apps/details?id=com.yourapp\n\n"
//         "Event Link: ${widget.shareLink}";

//     try {
//       final uri = Uri(
//         scheme: 'sms',
//         path: phoneNumbers.join(','),
//         queryParameters: {'body': shareText},
//       );
      
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//         _showMessage('Invitation sent to ${phoneNumbers.length} contacts');
//       } else {
//         _showMessage('Cannot send SMS from this device');
//       }
//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     }
//   }

//   Widget _buildContactItem(Contact contact) {
//     // Use the first phone number for each contact
//     final phoneNumber = contact.phoneNumbers?.isNotEmpty == true 
//         ? _cleanPhoneNumber(contact.phoneNumbers!.first) 
//         : '';
    
//     final isRegistered = _registeredNumbers.contains(phoneNumber);
//     final isSelected = _selectedNumbers.contains(phoneNumber);
//     final displayName = contact.fullName ?? 'Unknown';

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: isRegistered ? Colors.green : Colors.blue,
//         child: Text(
//           displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       title: Text(displayName),
//       subtitle: Text(_formatPhoneNumber(phoneNumber)),
//       trailing: isRegistered 
//           ? Icon(
//               isSelected ? Icons.check_circle : Icons.check_circle_outline,
//               color: isSelected ? Colors.green : Colors.grey,
//             )
//           : const Icon(Icons.arrow_forward_ios, size: 16),
//       onTap: () {
//         if (isRegistered) {
//           _toggleSelection(phoneNumber);
//         } else {
//           _inviteToDownloadApp(phoneNumber);
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invite to Event'),
//         actions: [
//           if (_selectedNumbers.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.send),
//               onPressed: _isLoading ? null : _sendInvitations,
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search name or number...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//               ),
//             ),
//           ),
          
//           // Status Information
//           if (_hasCheckedUsers)
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               color: Colors.grey[100],
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${_registeredNumbers.length} Moments users • ${_unregisteredNumbers.length} to invite',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
          
//           // Contacts List
//           Expanded(
//             child: _isLoading && !_hasLoadedContacts
//                 ? const Center(child: CircularProgressIndicator())
//                 : _filteredContacts.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No contacts found',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _filteredContacts.length,
//                         itemBuilder: (context, index) {
//                           return _buildContactItem(_filteredContacts[index]);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper methods (keep these from your original code)
//   String _formatPhoneNumber(String phone) {
//     if (phone.length > 10) {
//       return '+${phone.substring(0, phone.length - 10)} '
//           '${phone.substring(phone.length - 10, phone.length - 7)} '
//           '${phone.substring(phone.length - 7, phone.length - 4)} '
//           '${phone.substring(phone.length - 4)}';
//     }
//     return phone;
//   }

//   String _cleanPhoneNumber(String phone) {
//     return phone.replaceAll(RegExp(r'[^0-9+]'), '');
//   }

//   bool _isValidPhoneNumber(String phone) {
//     return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
//   }

//   Future<void> _inviteToDownloadApp(String phoneNumber) async {
//     final shareText = 
//         "Join me on Moments app to manage events and stay connected!\n\n"
//         "Download here: https://play.google.com/store/apps/details?id=com.yourapp";

//     try {
//       final uri = Uri(
//         scheme: 'sms',
//         path: phoneNumber,
//         queryParameters: {'body': shareText},
//       );
      
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         _showMessage('Cannot send SMS from this device');
//       }
//     } catch (e) {
//       _showMessage('Failed to send invitation: ${e.toString()}');
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class EventInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const EventInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<EventInvitationScreen> createState() => _EventInvitationScreenState();
// }

// class _EventInvitationScreenState extends State<EventInvitationScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Contact> _allContacts = [];
//   List<Contact> _filteredContacts = [];
//   final List<String> _selectedNumbers = [];
//   List<String> _registeredNumbers = [];
//   List<String> _unregisteredNumbers = [];
//   final Map<String, dynamic> _userDetailsMap = {};

//   bool _isLoading = false;
//   bool _hasLoadedContacts = false;
//   bool _hasCheckedUsers = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//     _searchController.addListener(_filterContacts);
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadContacts() async {
//     setState(() => _isLoading = true);

//     try {
//       if (await FlutterContacts.requestPermission()) {
//         final contacts = await FlutterContacts.getContacts(withProperties: true);
//         setState(() {
//           _allContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
//           _filteredContacts = _allContacts;
//           _hasLoadedContacts = true;
//         });

//         // Extract phone numbers and check registered users
//         final phoneNumbers = _allContacts
//             .expand((c) => c.phones.map((p) => _cleanPhoneNumber(p.number)))
//             .where((phone) => _isValidPhoneNumber(phone))
//             .toSet()
//             .toList();

//         if (phoneNumbers.isNotEmpty) {
//           await _checkRegisteredUsers(phoneNumbers);
//         }
//       }
//     } catch (e) {
//       _showMessage('Failed to load contacts: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _filterContacts() {
//     final query = _searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       setState(() => _filteredContacts = _allContacts);
//       return;
//     }

//     setState(() {
//       _filteredContacts = _allContacts.where((c) {
//         final nameMatch = c.displayName.toLowerCase().contains(query);
//         final phoneMatch = c.phones.any(
//           (p) => p.number.toLowerCase().contains(query),
//         );
//         return nameMatch || phoneMatch;
//       }).toList();
//     });
//   }

//   Future<void> _checkRegisteredUsers(List<String> phoneNumbers) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await NetworkService.checkRegisteredUsers(phoneNumbers);
      
//       // Store user details in a map for easy access
//       final registeredUsers = List<Map<String, dynamic>>.from(result['registered'] ?? []);
//       for (var user in registeredUsers) {
//         _userDetailsMap[user['phone_number']] = user;
//       }
      
//       setState(() {
//         _registeredNumbers = registeredUsers.map((u) => u['phone_number'] as String).toList();
//         _unregisteredNumbers = List<String>.from(result['unregistered'] ?? []);
//         _hasCheckedUsers = true;
//       });
//     } catch (e) {
//       _showMessage('Failed to check users: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _toggleSelection(String phoneNumber) {
//     setState(() {
//       if (_selectedNumbers.contains(phoneNumber)) {
//         _selectedNumbers.remove(phoneNumber);
//       } else {
//         _selectedNumbers.add(phoneNumber);
//       }
//     });
//   }

//   Future<void> _sendInvitations() async {
//     if (_selectedNumbers.isEmpty) {
//       _showMessage('Please select at least one contact');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final selectedRegistered = _selectedNumbers
//           .where((num) => _registeredNumbers.contains(num))
//           .toList();
//       final selectedUnregistered = _selectedNumbers
//           .where((num) => _unregisteredNumbers.contains(num))
//           .toList();

//       // Invite registered users to the event
//       if (selectedRegistered.isNotEmpty) {
//         final result = await NetworkService.inviteUsers(
//           eventToken: widget.eventToken,
//           phoneNumbers: selectedRegistered,
//         );
        
//         final successful = (result['data'] as List)
//             .where((e) => e['status'] == 'invited')
//             .length;
//         _showMessage('Successfully invited $successful users to the event');
//       }

//       // Send SMS invites to unregistered users
//       if (selectedUnregistered.isNotEmpty) {
//         await _inviteUnregisteredUsers(selectedUnregistered);
//       }

//       setState(() => _selectedNumbers.clear());
//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _inviteUnregisteredUsers(List<String> phoneNumbers) async {
//     final shareText =
//         "You're invited to '${widget.eventName}' by ${widget.organizerName}!\n\n"
//         "Join the event by downloading Moments app:\n"
//         "https://play.google.com/store/apps/details?id=com.yourapp\n\n"
//         "Event Link: ${widget.shareLink}";

//     try {
//       for (final phone in phoneNumbers) {
//         final uri = Uri(
//           scheme: 'sms',
//           path: phone,
//           queryParameters: {'body': shareText},
//         );

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri);
//           await Future.delayed(const Duration(milliseconds: 500)); // Delay to avoid rate limiting
//         }
//       }
      
//       _showMessage('Invitation sent to ${phoneNumbers.length} contacts');
//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     }
//   }

//   Widget _buildContactItem(Contact contact) {
//     final phoneNumber = contact.phones.isNotEmpty
//         ? _cleanPhoneNumber(contact.phones.first.number)
//         : '';

//     final isRegistered = _registeredNumbers.contains(phoneNumber);
//     final isSelected = _selectedNumbers.contains(phoneNumber);
//     final userDetails = isRegistered ? _userDetailsMap[phoneNumber] : null;

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: isRegistered ? Colors.green : Colors.blue,
//         backgroundImage: userDetails != null && userDetails['photo'] != null 
//             ? NetworkImage(userDetails['photo']) 
//             : null,
//         child: userDetails != null && userDetails['photo'] == null
//             ? Text(
//                 contact.displayName.isNotEmpty
//                     ? contact.displayName[0].toUpperCase()
//                     : '?',
//                 style: const TextStyle(color: Colors.white),
//               )
//             : null,
//       ),
//       title: Text(contact.displayName),
//       subtitle: Text(_formatPhoneNumber(phoneNumber)),
//       trailing: isRegistered
//           ? Checkbox(
//               value: isSelected,
//               onChanged: (value) => _toggleSelection(phoneNumber),
//             )
//           : IconButton(
//               icon: const Icon(Icons.person_add_alt_rounded),
//               onPressed: () => _inviteToDownloadApp(phoneNumber),
//             ),
//       onTap: () {
//         if (isRegistered) {
//           _toggleSelection(phoneNumber);
//         } else {
//           _inviteToDownloadApp(phoneNumber);
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Select contact'),
//             if (_hasLoadedContacts)
//               Text(
//                 '${_allContacts.length} contacts',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//               ),
//           ],
//         ),
//         actions: [
//           if (_selectedNumbers.isNotEmpty)
//             TextButton(
//               onPressed: _isLoading ? null : _sendInvitations,
//               child: Text(
//                 'INVITE (${_selectedNumbers.length})',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search name or number...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               ),
//             ),
//           ),
//           if (_hasCheckedUsers)
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               color: Colors.grey[100],
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${_registeredNumbers.length} Moments users • ${_unregisteredNumbers.length} to invite',
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//           Expanded(
//             child: _isLoading && !_hasLoadedContacts
//                 ? const Center(child: CircularProgressIndicator())
//                 : _filteredContacts.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No contacts found',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: _filteredContacts.length,
//                         itemBuilder: (context, index) {
//                           return _buildContactItem(_filteredContacts[index]);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Helper methods
//   String _cleanPhoneNumber(String phone) {
//     String cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    
//     // Handle Indian numbers specifically
//     if (cleaned.startsWith('91') && cleaned.length == 12) {
//       return '+$cleaned';
//     } else if (cleaned.length == 10) {
//       return '+91$cleaned';
//     } else if (cleaned.startsWith('+')) {
//       return cleaned;
//     } else if (cleaned.length > 10) {
//       return '+$cleaned';
//     }
//     return cleaned;
//   }

//   bool _isValidPhoneNumber(String phone) {
//     return RegExp(r'^\+[0-9]{10,15}$').hasMatch(phone);
//   }

//   String _formatPhoneNumber(String phone) {
//     if (phone.startsWith('+91') && phone.length == 13) {
//       return '+91 ${phone.substring(3, 8)} ${phone.substring(8)}';
//     }
//     return phone;
//   }

//   Future<void> _inviteToDownloadApp(String phoneNumber) async {
//     final shareText =
//         "Join me on Moments app to manage events and stay connected!\n\n"
//         "Download here: https://play.google.com/store/apps/details?id=com.yourapp";

//     try {
//       final uri = Uri(
//         scheme: 'sms',
//         path: phoneNumber,
//         queryParameters: {'body': shareText},
//       );
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         _showMessage('Cannot send SMS from this device');
//       }
//     } catch (e) {
//       _showMessage('Failed to send invitation: ${e.toString()}');
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
//     );
//   }
// }






























// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';

// class WhatsAppInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const WhatsAppInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<WhatsAppInvitationScreen> createState() => _WhatsAppInvitationScreenState();
// }

// class _WhatsAppInvitationScreenState extends State<WhatsAppInvitationScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Contact> _allContacts = [];
//   List<Contact> _filteredContacts = [];
//   final Set<ContactInvitation> _selectedContacts = {};
//   final Map<String, bool> _registrationStatus = {};

//   bool _isLoading = false;
//   bool _hasLoadedContacts = false;
//   bool _hasCheckedUsers = false;
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.toLowerCase();
//         _filterContacts();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadContacts() async {
//     setState(() => _isLoading = true);

//     try {
//       // Request permission
//       final permissionStatus = await Permission.contacts.request();
//       if (permissionStatus.isDenied) {
//         _showMessage('Contact permission is required to invite friends');
//         setState(() => _isLoading = false);
//         return;
//       }

//       if (await FlutterContacts.requestPermission()) {
//         final contacts = await FlutterContacts.getContacts(withProperties: true);
        
//         // Filter contacts with phone numbers
//         final validContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        
//         setState(() {
//           _allContacts = validContacts;
//           _filteredContacts = validContacts;
//           _hasLoadedContacts = true;
//         });

//         // Check registration status
//         await _checkRegistrationStatus();
//       }
//     } catch (e) {
//       _showMessage('Failed to load contacts: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

// Future<void> _checkRegistrationStatus() async {
//   setState(() => _isLoading = true);
  
//   try {
//     final contactInfos = _allContacts.map((contact) {
//       final phoneNumber = _cleanPhoneNumber(contact.phones.first.number);
//       return ContactInfo(
//         name: contact.displayName,
//         phoneNumber: phoneNumber,
//       );
//     }).toList();

//     final result = await NetworkService.checkContactsForRegisteredUsers(contactInfos);
    
//     if (result['success'] == true) {
//       final enrichedContacts = List<Map<String, dynamic>>.from(result['contacts'] ?? []);
      
//       setState(() {
//         // Update registration status map
//         _registrationStatus.clear();
//         for (var contactData in enrichedContacts) {
//           _registrationStatus[contactData['phoneNumber']] = contactData['isRegistered'];
//         }
//         _hasCheckedUsers = true;
//       });
//     }
//   } catch (e) {
//     _showMessage('Failed to check user status: ${e.toString()}');
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }

//   // Future<void> _checkRegistrationStatus() async {
//   //   setState(() => _isLoading = true);
    
//   //   try {
//   //     final contactInfos = _allContacts.map((contact) {
//   //       final phoneNumber = _cleanPhoneNumber(contact.phones.first.number);
//   //       return ContactInfo(
//   //         name: contact.displayName,
//   //         phoneNumber: phoneNumber,
//   //       );
//   //     }).toList();

//   //     final result = await NetworkService.checkContactsForRegisteredUsers(contactInfos);
      
//   //     if (result['success'] == true) {
//   //       final enrichedContacts = List<ContactInvitation>.from(
//   //         result['contacts'].map((c) => ContactInvitation.fromJson(c))
//   //       );

//   //       setState(() {
//   //         // Update registration status map
//   //         _registrationStatus.clear();
//   //         for (var contact in enrichedContacts) {
//   //           _registrationStatus[contact.phoneNumber] = contact.isRegistered;
//   //         }
//   //         _hasCheckedUsers = true;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     _showMessage('Failed to check user status: ${e.toString()}');
//   //   } finally {
//   //     setState(() => _isLoading = false);
//   //   }
//   // }

//   void _filterContacts() {
//     if (_searchQuery.isEmpty) {
//       setState(() => _filteredContacts = _allContacts);
//       return;
//     }

//     setState(() {
//       _filteredContacts = _allContacts.where((c) {
//         final nameMatch = c.displayName.toLowerCase().contains(_searchQuery);
//         final phoneMatch = c.phones.any(
//           (p) => p.number.toLowerCase().contains(_searchQuery),
//         );
//         return nameMatch || phoneMatch;
//       }).toList();
//     });
//   }

// void _toggleContactSelection(ContactInvitation contactInvitation) {
//   setState(() {
//     if (_selectedContacts.any((c) => c.phoneNumber == contactInvitation.phoneNumber)) {
//       _selectedContacts.removeWhere((c) => c.phoneNumber == contactInvitation.phoneNumber);
//     } else {
//       _selectedContacts.add(contactInvitation);
//     }
//   });
// }
//   Future<void> _sendInvitations() async {
//     if (_selectedContacts.isEmpty) {
//       _showMessage('Please select at least one contact');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final result = await NetworkService.inviteUsersToPrivateEvent(
//         eventToken: widget.eventToken,
//         contacts: _selectedContacts.toList(),
//       );

//       // Process results
//       final summary = result['summary'] as Map<String, dynamic>;
//       final results = result['results'] as List<dynamic>;
      
//       // Handle SMS for non-app users
//       final nonUsersToInvite = results
//           .where((r) => r['status'] == 'invited_non_user')
//           .toList();
      
//       if (nonUsersToInvite.isNotEmpty) {
//         await _sendSMSInvitations(nonUsersToInvite);
//       }

//       // Show success message
//       final appUsersInvited = summary['app_users_invited'] as int;
//       final nonUsersInvited = summary['non_users_to_invite'] as int;
      
//       String message = '';
//       if (appUsersInvited > 0 && nonUsersInvited > 0) {
//         message = 'Invited $appUsersInvited app users and sent SMS to $nonUsersInvited others';
//       } else if (appUsersInvited > 0) {
//         message = 'Successfully invited $appUsersInvited app users';
//       } else if (nonUsersInvited > 0) {
//         message = 'Sent SMS invitations to $nonUsersInvited contacts';
//       }

//       _showMessage(message);
//       setState(() => _selectedContacts.clear());

//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _sendSMSInvitations(List<dynamic> nonUserInvites) async {
//     for (final invite in nonUserInvites) {
//       try {
//         final phoneNumber = invite['phone_number'] as String;
//         final smsMessage = invite['sms_message'] as String;

//         final uri = Uri(
//           scheme: 'sms',
//           path: phoneNumber,
//           queryParameters: {'body': smsMessage},
//         );

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri);
//           await Future.delayed(const Duration(milliseconds: 500));
//         }
//       } catch (e) {
//         print('Failed to send SMS to ${invite['phone_number']}: $e');
//       }
//     }
//   }

//   Widget _buildContactItem(Contact contact) {
//     final phoneNumber = _cleanPhoneNumber(contact.phones.first.number);
//     final isRegistered = _registrationStatus[phoneNumber] ?? false;
//     final isSelected = _selectedContacts.any((c) => c.phoneNumber == phoneNumber);

//   final contactInvitation = ContactInvitation(
//     name: contact.displayName,
//     phoneNumber: phoneNumber,
//     isRegistered: isRegistered,
//   );

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.green.shade50 : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
//           width: isSelected ? 2 : 1,
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Stack(
//           children: [
//             CircleAvatar(
//               backgroundColor: isRegistered ? Colors.green.shade100 : Colors.blue.shade100,
//               radius: 24,
//               child: Text(
//                 contact.displayName.isNotEmpty
//                     ? contact.displayName[0].toUpperCase()
//                     : '?',
//                 style: TextStyle(
//                   color: isRegistered ? Colors.green.shade700 : Colors.blue.shade700,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (isRegistered)
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 12,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         title: Text(
//           contact.displayName,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatPhoneNumber(phoneNumber),
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//               decoration: BoxDecoration(
//                 color: isRegistered ? Colors.green.shade100 : Colors.orange.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 isRegistered ? 'Moments User' : 'Will get SMS',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w500,
//                   color: isRegistered ? Colors.green.shade700 : Colors.orange.shade700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: isSelected
//             ? Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               )
//             : Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400, width: 2),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//         onTap: () => _toggleContactSelection(contactInvitation),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final registeredCount = _registrationStatus.values.where((r) => r).length;
//     final unregisteredCount = _registrationStatus.values.where((r) => !r).length;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Invite to Event',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             if (_hasLoadedContacts)
//               Text(
//                 '${_allContacts.length} contacts',
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           if (_selectedContacts.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF25D366), Color(0xFF20BA5A)],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _sendInvitations,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.send_rounded, size: 18, color: Colors.white),
//                       const SizedBox(width: 4),
//                       Text(
//                         'SEND (${_selectedContacts.length})',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Event Info Card
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.purple.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.event_rounded,
//                     color: Colors.purple.shade600,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.eventName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'by ${widget.organizerName}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Search Bar
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search contacts...',
//                 prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 16,
//                 ),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, size: 20),
//                         onPressed: () => _searchController.clear(),
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           // Stats Banner
//           if (_hasCheckedUsers)
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       '$registeredCount Moments users • $unregisteredCount will get SMS',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.blue.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Contacts List
//           Expanded(
//             child: _isLoading && !_hasLoadedContacts
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text(
//                           'Loading contacts...',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   )
//                 : _filteredContacts.isEmpty
//                     ? const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.contacts_outlined,
//                               size: 64,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'No contacts found',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         itemCount: _filteredContacts.length,
//                         itemBuilder: (context, index) {
//                           return _buildContactItem(_filteredContacts[index]);
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _cleanPhoneNumber(String phone) {
//     String cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    
//     if (cleaned.startsWith('91') && cleaned.length == 12) {
//       return '+$cleaned';
//     } else if (cleaned.length == 10) {
//       return '+91$cleaned';
//     } else if (cleaned.startsWith('+')) {
//       return cleaned;
//     } else if (cleaned.length > 10) {
//       return '+$cleaned';
//     }
//     return cleaned;
//   }

//   String _formatPhoneNumber(String phone) {
//     if (phone.startsWith('+91') && phone.length == 13) {
//       return '+91 ${phone.substring(3, 8)} ${phone.substring(8)}';
//     }
//     return phone;
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }



































//yester day last working code

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
// import 'package:moments/models/contact_models.dart';
// import 'package:moments/network_service/network_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';

// class WhatsAppInvitationScreen extends StatefulWidget {
//   final String eventToken;
//   final String eventName;
//   final String organizerName;
//   final String shareLink;

//   const WhatsAppInvitationScreen({
//     super.key,
//     required this.eventToken,
//     required this.eventName,
//     required this.organizerName,
//     required this.shareLink,
//   });

//   @override
//   State<WhatsAppInvitationScreen> createState() => _WhatsAppInvitationScreenState();
// }

// class _WhatsAppInvitationScreenState extends State<WhatsAppInvitationScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   List<Contact> _allContacts = [];
//   List<ContactInvitation> _momentsUsers = [];
//   List<ContactInvitation> _nonMomentsUsers = [];
//   final Set<ContactInvitation> _selectedContacts = {};
//   final Map<String, bool> _registrationStatus = {};

//   bool _isLoading = false;
//   bool _hasLoadedContacts = false;
//   bool _hasCheckedUsers = false;
//   String _searchQuery = '';

//   late TabController _tabController;
//   int _currentTab = 0;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _currentTab = _tabController.index;
//       });
//     });
//     _loadContacts();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.toLowerCase();
//         _filterContacts();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadContacts() async {
//     setState(() => _isLoading = true);

//     try {
//       // Request permission
//       final permissionStatus = await Permission.contacts.request();
//       if (permissionStatus.isDenied) {
//         _showMessage('Contact permission is required to invite friends');
//         setState(() => _isLoading = false);
//         return;
//       }

//       if (await FlutterContacts.requestPermission()) {
//         final contacts = await FlutterContacts.getContacts(withProperties: true);
        
//         // Filter contacts with phone numbers
//         final validContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        
//         setState(() {
//           _allContacts = validContacts;
//           _hasLoadedContacts = true;
//         });

//         // Check registration status
//         await _checkRegistrationStatus();
//       }
//     } catch (e) {
//       _showMessage('Failed to load contacts: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _checkRegistrationStatus() async {
//     setState(() => _isLoading = true);
    
//     try {
//       final contactInfos = _allContacts.map((contact) {
//         final phoneNumber = _cleanPhoneNumber(contact.phones.first.number);
//         return ContactInfo(
//           name: contact.displayName,
//           phoneNumber: phoneNumber,
//         );
//       }).toList();

//       final result = await NetworkService.checkContactsForRegisteredUsers(contactInfos);
      
//       if (result['success'] == true) {
//         final enrichedContacts = List<Map<String, dynamic>>.from(result['contacts'] ?? []);
        
//         setState(() {
//           // Clear previous data
//           _registrationStatus.clear();
//           _momentsUsers.clear();
//           _nonMomentsUsers.clear();
          
//           // Process contacts and separate them
//           for (var contactData in enrichedContacts) {
//             final phoneNumber = contactData['phoneNumber'];
//             final isRegistered = contactData['isRegistered'];
//             final name = contactData['name'];
            
//             _registrationStatus[phoneNumber] = isRegistered;
            
//             final contactInvitation = ContactInvitation(
//               name: name,
//               phoneNumber: phoneNumber,
//               isRegistered: isRegistered,
//               userData: contactData['userData'],
//             );
            
//             if (isRegistered) {
//               _momentsUsers.add(contactInvitation);
//             } else {
//               _nonMomentsUsers.add(contactInvitation);
//             }
//           }
          
//           // Sort by name
//           _momentsUsers.sort((a, b) => a.name.compareTo(b.name));
//           _nonMomentsUsers.sort((a, b) => a.name.compareTo(b.name));
          
//           _hasCheckedUsers = true;
//         });
//       }
//     } catch (e) {
//       _showMessage('Failed to check user status: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _filterContacts() {
//     if (_searchQuery.isEmpty) {
//       _checkRegistrationStatus();
//       return;
//     }

//     setState(() {
//       _momentsUsers = _momentsUsers.where((contact) {
//         return contact.name.toLowerCase().contains(_searchQuery) ||
//                contact.phoneNumber.contains(_searchQuery);
//       }).toList();
      
//       _nonMomentsUsers = _nonMomentsUsers.where((contact) {
//         return contact.name.toLowerCase().contains(_searchQuery) ||
//                contact.phoneNumber.contains(_searchQuery);
//       }).toList();
//     });
//   }

//   void _toggleContactSelection(ContactInvitation contactInvitation) {
//     setState(() {
//       if (_selectedContacts.any((c) => c.phoneNumber == contactInvitation.phoneNumber)) {
//         _selectedContacts.removeWhere((c) => c.phoneNumber == contactInvitation.phoneNumber);
//       } else {
//         _selectedContacts.add(contactInvitation);
//       }
//     });
//   }

//   Future<void> _sendInvitations() async {
//     if (_selectedContacts.isEmpty) {
//       _showMessage('Please select at least one contact');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final result = await NetworkService.inviteUsersToPrivateEvent(
//         eventToken: widget.eventToken,
//         contacts: _selectedContacts.toList(),
//       );

//       // Process results
//       final summary = result['summary'] as Map<String, dynamic>;
//       final results = result['results'] as List<dynamic>;
      
//       // Check for already invited users
//       final alreadyInvited = results.where((r) => 
//         r['status'] == 'already_invited' || r['status'] == 'already_accepted'
//       ).toList();
      
//       if (alreadyInvited.isNotEmpty) {
//         _showAlreadyInvitedDialog(alreadyInvited);
//       }
      
//       // Handle SMS for non-app users
//       final nonUsersToInvite = results
//           .where((r) => r['status'] == 'invited_non_user')
//           .toList();
      
//       if (nonUsersToInvite.isNotEmpty) {
//         await _sendSMSInvitations(nonUsersToInvite);
//       }

//       // Show success message
//       final appUsersInvited = summary['app_users_invited'] as int;
//       final nonUsersInvited = summary['non_users_to_invite'] as int;
      
//       String message = '';
//       if (appUsersInvited > 0 && nonUsersInvited > 0) {
//         message = 'Invited $appUsersInvited app users and sent SMS to $nonUsersInvited others';
//       } else if (appUsersInvited > 0) {
//         message = 'Successfully invited $appUsersInvited app users';
//       } else if (nonUsersInvited > 0) {
//         message = 'Sent SMS invitations to $nonUsersInvited contacts';
//       }

//       if (message.isNotEmpty) {
//         _showMessage(message);
//       }
      
//       setState(() => _selectedContacts.clear());

//     } catch (e) {
//       _showMessage('Failed to send invitations: ${e.toString()}');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showAlreadyInvitedDialog(List<dynamic> alreadyInvited) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.orange.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(Icons.info_outline, color: Colors.orange.shade700),
//             ),
//             const SizedBox(width: 12),
//             const Text('Already Invited'),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${alreadyInvited.length} contacts have already been invited:',
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               constraints: const BoxConstraints(maxHeight: 200),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: alreadyInvited.map((invite) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: Colors.orange.shade300,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               invite['name'] ?? 'Unknown',
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

// Future<void> _sendSMSInvitations(List<dynamic> nonUserInvites) async {
//   for (final invite in nonUserInvites) {
//     try {
//       final phoneNumber = invite['phone_number'] as String;
      
//       // Check if it's the new format with sms_data
//       if (invite['sms_data'] != null) {
//         final smsData = invite['sms_data'] as Map<String, dynamic>;
//         final message = smsData['message'] as String;
        
//         final uri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message)}");

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//           await Future.delayed(const Duration(milliseconds: 800));
//         } else {
//           print('❌ Could not launch SMS for $phoneNumber');
//         }
//       } 
//       // Fallback for old format (if you still have it)
//       else if (invite['sms_message'] != null) {
//         final message = invite['sms_message'] as String;
        
//         final uri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message)}");

//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//           await Future.delayed(const Duration(milliseconds: 800));
//         }
//       }
//     } catch (e) {
//       print('Failed to send SMS to ${invite['phone_number']}: $e');
//     }
//   }
// }

// // Future<void> _sendSMSInvitations(List<dynamic> nonUserInvites) async {
// //   for (final invite in nonUserInvites) {
// //     try {
// //       final phoneNumber = invite['phone_number'] as String;
// //       final message = invite['sms_message'] as String; // ✅ use sms_message

// //       final uri = Uri(
// //         scheme: 'sms',
// //         path: phoneNumber,
// //         queryParameters: {'body': message},
// //       );

// //       if (await canLaunchUrl(uri)) {
// //         await launchUrl(uri);
// //         await Future.delayed(const Duration(milliseconds: 800));
// //       } else {
// //         print('❌ Could not launch SMS for $phoneNumber');
// //       }
// //     } catch (e) {
// //       print('Failed to send SMS to ${invite['phone_number']}: $e');
// //     }
// //   }
// // }


//   // Future<void> _sendSMSInvitations(List<dynamic> nonUserInvites) async {
//   //   for (final invite in nonUserInvites) {
//   //     try {
//   //       final phoneNumber = invite['phone_number'] as String;
//   //       final smsData = invite['sms_data'] as Map<String, dynamic>;
//   //       final message = smsData['message'] as String;

//   //       final uri = Uri(
//   //         scheme: 'sms',
//   //         path: phoneNumber,
//   //         queryParameters: {'body': message},
//   //       );

//   //       if (await canLaunchUrl(uri)) {
//   //         await launchUrl(uri);
//   //         await Future.delayed(const Duration(milliseconds: 800));
//   //       }
//   //     } catch (e) {
//   //       print('Failed to send SMS to ${invite['phone_number']}: $e');
//   //     }
//   //   }
//   // }

//   Widget _buildContactItem(ContactInvitation contact) {
//     final isSelected = _selectedContacts.any((c) => c.phoneNumber == contact.phoneNumber);

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.green.shade50 : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
//           width: isSelected ? 2 : 1,
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Stack(
//           children: [
//             CircleAvatar(
//               backgroundColor: contact.isRegistered ? Colors.green.shade100 : Colors.blue.shade100,
//               radius: 24,
//               child: Text(
//                 contact.name.isNotEmpty
//                     ? contact.name[0].toUpperCase()
//                     : '?',
//                 style: TextStyle(
//                   color: contact.isRegistered ? Colors.green.shade700 : Colors.blue.shade700,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (contact.isRegistered)
//               Positioned(
//                 right: 0,
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.all(2),
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 12,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         title: Text(
//           contact.name,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               _formatPhoneNumber(contact.phoneNumber),
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: contact.isRegistered ? Colors.green.shade100 : Colors.orange.shade100,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 contact.isRegistered ? 'Moments User' : 'Will get SMS',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: contact.isRegistered ? Colors.green.shade700 : Colors.orange.shade700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         trailing: isSelected
//             ? Container(
//                 padding: const EdgeInsets.all(4),
//                 decoration: const BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               )
//             : Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400, width: 2),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//         onTap: () => _toggleContactSelection(contact),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final momentsCount = _momentsUsers.length;
//     final nonMomentsCount = _nonMomentsUsers.length;
//     final selectedMomentsUsers = _selectedContacts.where((c) => c.isRegistered).length;
//     final selectedNonUsers = _selectedContacts.where((c) => !c.isRegistered).length;

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Invite to Event',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             if (_hasLoadedContacts)
//               Text(
//                 '$momentsCount Moments users • $nonMomentsCount others',
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//           ],
//         ),
//         actions: [
//           if (_selectedContacts.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF25D366), Color(0xFF20BA5A)],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _sendInvitations,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.send_rounded, size: 18, color: Colors.white),
//                       const SizedBox(width: 4),
//                       Text(
//                         'SEND (${_selectedContacts.length})',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//         bottom: _hasCheckedUsers ? TabBar(
//           controller: _tabController,
//           tabs: [
//             Tab(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.people,
//                       size: 16,
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text('Moments ($momentsCount)'),
//                 ],
//               ),
//             ),
//             Tab(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.orange.shade100,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       Icons.sms,
//                       size: 16,
//                       color: Colors.orange.shade700,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text('SMS ($nonMomentsCount)'),
//                 ],
//               ),
//             ),
//           ],
//         ) : null,
//       ),
//       body: Column(
//         children: [
//           // Event Info Card
//           Container(
//             margin: const EdgeInsets.all(16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.purple.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     Icons.lock_rounded,
//                     color: Colors.purple.shade600,
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.eventName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Private Event by ${widget.organizerName}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Search Bar
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 6,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search contacts...',
//                 prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 16,
//                 ),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? IconButton(
//                         icon: const Icon(Icons.clear, size: 20),
//                         onPressed: () => _searchController.clear(),
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           // Selection Summary
//           if (_selectedContacts.isNotEmpty)
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.shade50, Colors.green.shade50],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       '$selectedMomentsUsers Moments users • $selectedNonUsers SMS invites selected',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.blue.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           // Contacts List
//           Expanded(
//             child: _isLoading && !_hasLoadedContacts
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 16),
//                         Text(
//                           'Loading contacts...',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   )
//                 : _hasCheckedUsers 
//                     ? TabBarView(
//                         controller: _tabController,
//                         children: [
//                           // Moments Users Tab
//                           _momentsUsers.isEmpty
//                               ? const Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.people_outline,
//                                         size: 64,
//                                         color: Colors.grey,
//                                       ),
//                                       SizedBox(height: 16),
//                                       Text(
//                                         'No Moments users found',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   padding: const EdgeInsets.only(bottom: 16),
//                                   itemCount: _momentsUsers.length,
//                                   itemBuilder: (context, index) {
//                                     return _buildContactItem(_momentsUsers[index]);
//                                   },
//                                 ),
//                           // Non-Moments Users Tab
//                           _nonMomentsUsers.isEmpty
//                               ? const Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.sms_outlined,
//                                         size: 64,
//                                         color: Colors.grey,
//                                       ),
//                                       SizedBox(height: 16),
//                                       Text(
//                                         'No SMS contacts found',
//                                         style: TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : ListView.builder(
//                                   padding: const EdgeInsets.only(bottom: 16),
//                                   itemCount: _nonMomentsUsers.length,
//                                   itemBuilder: (context, index) {
//                                     return _buildContactItem(_nonMomentsUsers[index]);
//                                   },
//                                 ),
//                         ],
//                       )
//                     : const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.contacts_outlined,
//                               size: 64,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               'No contacts found',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _cleanPhoneNumber(String phone) {
//     String cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    
//     if (cleaned.startsWith('91') && cleaned.length == 12) {
//       return '+$cleaned';
//     } else if (cleaned.length == 10) {
//       return '+91$cleaned';
//     } else if (cleaned.startsWith('+')) {
//       return cleaned;
//     } else if (cleaned.length > 10) {
//       return '+$cleaned';
//     }
//     return cleaned;
//   }

//   String _formatPhoneNumber(String phone) {
//     if (phone.startsWith('+91') && phone.length == 13) {
//       return '+91 ${phone.substring(3, 8)} ${phone.substring(8)}';
//     }
//     return phone;
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }
// }










import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:moments/models/contact_models.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class WhatsAppInvitationScreen extends StatefulWidget {
  final String eventToken;
  final String eventName;
  final String organizerName;
  final String shareLink;

  const WhatsAppInvitationScreen({
    super.key,
    required this.eventToken,
    required this.eventName,
    required this.organizerName,
    required this.shareLink,
  });

  @override
  State<WhatsAppInvitationScreen> createState() => _WhatsAppInvitationScreenState();
}

class _WhatsAppInvitationScreenState extends State<WhatsAppInvitationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _allContacts = [];
  List<ContactInvitation> _momentsUsers = [];
  List<ContactInvitation> _nonMomentsUsers = [];
  final Set<ContactInvitation> _selectedContacts = {};
  final Map<String, bool> _registrationStatus = {};

  bool _isLoading = false;
  bool _hasLoadedContacts = false;
  bool _hasCheckedUsers = false;
  String _searchQuery = '';

  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
    _loadContacts();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _filterContacts();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);

    try {
      // Request permission
      final permissionStatus = await Permission.contacts.request();
      if (permissionStatus.isDenied) {
        _showMessage('Contact permission is required to invite friends');
        setState(() => _isLoading = false);
        return;
      }

      if (await FlutterContacts.requestPermission()) {
        final contacts = await FlutterContacts.getContacts(withProperties: true);
        
        // Filter contacts with phone numbers
        final validContacts = contacts.where((c) => c.phones.isNotEmpty).toList();
        
        setState(() {
          _allContacts = validContacts;
          _hasLoadedContacts = true;
        });

        // Check registration status
        await _checkRegistrationStatus();
      }
    } catch (e) {
      _showMessage('Failed to load contacts: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkRegistrationStatus() async {
    setState(() => _isLoading = true);
    
    try {
      final contactInfos = _allContacts.map((contact) {
        final phoneNumber = _cleanPhoneNumber(contact.phones.first.number);
        return ContactInfo(
          name: contact.displayName,
          phoneNumber: phoneNumber,
        );
      }).toList();

      final result = await NetworkService.checkContactsForRegisteredUsers(contactInfos);
      
      if (result['success'] == true) {
        final enrichedContacts = List<Map<String, dynamic>>.from(result['contacts'] ?? []);
        
        setState(() {
          // Clear previous data
          _registrationStatus.clear();
          _momentsUsers.clear();
          _nonMomentsUsers.clear();
          
          // Process contacts and separate them
          for (var contactData in enrichedContacts) {
            final phoneNumber = contactData['phoneNumber'];
            final isRegistered = contactData['isRegistered'];
            final name = contactData['name'];
            
            _registrationStatus[phoneNumber] = isRegistered;
            
            final contactInvitation = ContactInvitation(
              name: name,
              phoneNumber: phoneNumber,
              isRegistered: isRegistered,
              userData: contactData['userData'],
            );
            
            if (isRegistered) {
              _momentsUsers.add(contactInvitation);
            } else {
              _nonMomentsUsers.add(contactInvitation);
            }
          }
          
          // Sort by name
          _momentsUsers.sort((a, b) => a.name.compareTo(b.name));
          _nonMomentsUsers.sort((a, b) => a.name.compareTo(b.name));
          
          _hasCheckedUsers = true;
        });
      }
    } catch (e) {
      _showMessage('Failed to check user status: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterContacts() {
    if (_searchQuery.isEmpty) {
      _checkRegistrationStatus();
      return;
    }

    setState(() {
      _momentsUsers = _momentsUsers.where((contact) {
        return contact.name.toLowerCase().contains(_searchQuery) ||
               contact.phoneNumber.contains(_searchQuery);
      }).toList();
      
      _nonMomentsUsers = _nonMomentsUsers.where((contact) {
        return contact.name.toLowerCase().contains(_searchQuery) ||
               contact.phoneNumber.contains(_searchQuery);
      }).toList();
    });
  }

  void _toggleContactSelection(ContactInvitation contactInvitation) {
    setState(() {
      if (_selectedContacts.any((c) => c.phoneNumber == contactInvitation.phoneNumber)) {
        _selectedContacts.removeWhere((c) => c.phoneNumber == contactInvitation.phoneNumber);
      } else {
        _selectedContacts.add(contactInvitation);
      }
    });
  }

  Future<void> _sendInvitations() async {
    if (_selectedContacts.isEmpty) {
      _showMessage('Please select at least one contact');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await NetworkService.inviteUsersToPrivateEvent(
        eventToken: widget.eventToken,
        contacts: _selectedContacts.toList(),
      );

      // Process results
      final summary = result['summary'] as Map<String, dynamic>;
      final results = result['results'] as List<dynamic>;
      
      // Check for already invited users
      final alreadyInvited = results.where((r) => 
        r['status'] == 'already_invited' || r['status'] == 'already_accepted'
      ).toList();
      
      if (alreadyInvited.isNotEmpty) {
        _showAlreadyInvitedDialog(alreadyInvited);
      }
      
      // Handle SMS for non-app users
      final nonUsersToInvite = results
          .where((r) => r['status'] == 'invited_non_user')
          .toList();
      
      if (nonUsersToInvite.isNotEmpty) {
        await _sendSMSInvitations(nonUsersToInvite);
      }

      // Show success message
      final appUsersInvited = summary['app_users_invited'] as int;
      final nonUsersInvited = summary['non_users_to_invite'] as int;
      
      String message = '';
      if (appUsersInvited > 0 && nonUsersInvited > 0) {
        message = 'Invited $appUsersInvited app users and sent SMS to $nonUsersInvited others';
      } else if (appUsersInvited > 0) {
        message = 'Successfully invited $appUsersInvited app users';
      } else if (nonUsersInvited > 0) {
        message = 'Sent SMS invitations to $nonUsersInvited contacts';
      }

      if (message.isNotEmpty) {
        _showMessage(message);
      }
      
      setState(() => _selectedContacts.clear());

    } catch (e) {
      _showMessage('Failed to send invitations: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAlreadyInvitedDialog(List<dynamic> alreadyInvited) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.info_outline, color: Colors.orange.shade700),
            ),
            const SizedBox(width: 12),
            const Text('Already Invited'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${alreadyInvited.length} contacts have already been invited:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: alreadyInvited.map((invite) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              invite['name'] ?? 'Unknown',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSMSInvitations(List<dynamic> nonUserInvites) async {
    for (final invite in nonUserInvites) {
      try {
        final phoneNumber = invite['phone_number'] as String;
        String message = '';
        
        // Handle both possible response formats
        if (invite['sms_data'] != null) {
          final smsData = invite['sms_data'] as Map<String, dynamic>;
          message = smsData['message'] as String;
        } else if (invite['sms_message'] != null) {
          message = invite['sms_message'] as String;
        } else {
          // Fallback message if neither format is available
          message = 'Hi! You\'ve been invited to "${widget.eventName}" on Moments app. '
                   'Download the app: https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps';
        }
        
        // Create proper SMS URI
        final uri = Uri.parse("sms:$phoneNumber?body=${Uri.encodeComponent(message)}");
        
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          // Add a small delay to avoid overwhelming the system
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          print('Could not launch SMS for $phoneNumber');
        }
      } catch (e) {
        print('Failed to send SMS invitation: $e');
      }
    }
  }

  Widget _buildContactItem(ContactInvitation contact) {
    final isSelected = _selectedContacts.any((c) => c.phoneNumber == contact.phoneNumber);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green.shade300 : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: contact.isRegistered ? Colors.green.shade100 : Colors.blue.shade100,
              radius: 24,
              child: Text(
                contact.name.isNotEmpty
                    ? contact.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: contact.isRegistered ? Colors.green.shade700 : Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (contact.isRegistered)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          contact.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatPhoneNumber(contact.phoneNumber),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: contact.isRegistered ? Colors.green.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                contact.isRegistered ? 'Moments User' : 'Will get SMS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: contact.isRegistered ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              )
            : Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () => _toggleContactSelection(contact),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final momentsCount = _momentsUsers.length;
    final nonMomentsCount = _nonMomentsUsers.length;
    final selectedMomentsUsers = _selectedContacts.where((c) => c.isRegistered).length;
    final selectedNonUsers = _selectedContacts.where((c) => !c.isRegistered).length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_hasLoadedContacts)
              Text(
                '$momentsCount contacts',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          if (_selectedContacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF20BA5A)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendInvitations,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        'INVITE (${_selectedContacts.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        bottom: _hasCheckedUsers ? PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF25D366),
              labelColor: const Color(0xFF25D366),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.people,
                          size: 16,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Moments ($momentsCount)'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.sms,
                          size: 16,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('SMS ($nonMomentsCount)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ) : null,
      ),
      body: Column(
        children: [
          // Search Bar (like WhatsApp)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search name or number...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Selection Summary
          if (_selectedContacts.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 18, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedContacts.length} selected',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$selectedMomentsUsers Moments • $selectedNonUsers SMS',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

          // Contacts List
          Expanded(
            child: _isLoading && !_hasLoadedContacts
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading contacts...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _hasCheckedUsers 
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          // Moments Users Tab
                          _momentsUsers.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No Moments users found',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  itemCount: _momentsUsers.length,
                                  itemBuilder: (context, index) {
                                    return _buildContactItem(_momentsUsers[index]);
                                  },
                                ),
                          // Non-Moments Users Tab
                          _nonMomentsUsers.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.sms_outlined,
                                        size: 64,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No SMS contacts found',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  itemCount: _nonMomentsUsers.length,
                                  itemBuilder: (context, index) {
                                    return _buildContactItem(_nonMomentsUsers[index]);
                                  },
                                ),
                        ],
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.contacts_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No contacts found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
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

  String _cleanPhoneNumber(String phone) {
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

  String _formatPhoneNumber(String phone) {
    if (phone.startsWith('+91') && phone.length == 13) {
      return '+91 ${phone.substring(3, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}