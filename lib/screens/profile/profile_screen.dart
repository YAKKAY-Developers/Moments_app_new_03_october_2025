// import 'package:flutter/material.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:moments/widgets/comment_section.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../network_service/network_service.dart';
// import 'package:share_plus/share_plus.dart';

// void _invitePeople() {
//   const appDownloadLink = 'https://yourdomain.page.link/invite'; // replace with your Firebase Dynamic Link
//   const inviteMessage =
//       "Hey! Check out the Moments app to discover and share events easily. Download now: $appDownloadLink";

//   // ignore: deprecated_member_use
//   Share.share(inviteMessage, subject: 'Join me on Moments!');
// }

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _fetchUserData();
//   // }

// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     _fetchUserData();
//   });
// }
// void _showProfilePhoto(String imageUrl) {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: EdgeInsets.zero,
//       child: ProfilePhotoViewer(imageUrl: imageUrl),
//     ),
//   );
// }

//   Future<void> _fetchUserData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.fetchUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           if (authProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final user = authProvider.user;

//           if (user == null) {
//             return const Center(child: Text("No user data found."));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 GestureDetector(
//   onTap: () {
//     if (user.photo != null && user.photo!.isNotEmpty) {
//       final imageUrl = NetworkService.getImageUrl(user.photo!, type: 'profile');
//       _showProfilePhoto(imageUrl);
//     }
//   },
//   child: CircleAvatar(
//     radius: 60,
//     // ignore: deprecated_member_use
//     backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//     backgroundImage: user.photo != null && user.photo!.isNotEmpty
//         ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//         : null,
//     child: user.photo == null || user.photo!.isEmpty
//         ? Icon(
//             Icons.person,
//             size: 60,
//             color: Theme.of(context).primaryColor,
//           )
//         : null,
//   ),
// ),

//                 // CircleAvatar(
//                 //   radius: 60,
//                 //   // ignore: deprecated_member_use
//                 //   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                 //   backgroundImage: user.photo != null && user.photo!.isNotEmpty
//                 //       ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//                 //       : null,
//                 //   child: user.photo == null || user.photo!.isEmpty
//                 //       ? Icon(
//                 //           Icons.person,
//                 //           size: 60,
//                 //           color: Theme.of(context).primaryColor,
//                 //         )
//                 //       : null,
//                 // ),
//                 const SizedBox(height: 24),
//                 Text(
//                   user.name ?? 'No Name',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   user.email ?? 'No Email',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 _buildProfileOption(
//                   context,
//                   icon: Icons.edit,
//                   title: 'Edit Profile',
//                   onTap: () {
//                     Navigator.pushNamed(context, '/edit-profile');
//                   },
//                 ),
//                   _buildProfileOption(
//                   context,
//                   icon: Icons.edit,
//                   title: 'Pinned Events',
//                   onTap: () {
//                     Navigator.pushNamed(context, '/pinned-events');
//                   },
//                 ),
//                 _buildProfileOption(
//                   context,
//                   icon: Icons.event,
//                   title: 'My Events',
//                   onTap: () {
//                     Navigator.pushNamed(context, '/my-events-screen');
//                   },
//                 ),
//                 _buildProfileOption(
//                   context,
//                   icon: Icons.history,
//                   title: 'Event History',
//                   onTap: () {
//                     Navigator.pushNamed(context, '/completed-events');
//                   },
//                 ),
                
//                 // _buildProfileOption(
//                 //   context,
//                 //   icon: Icons.push_pin,
//                 //   title: 'Pinned Events',
//                 //   onTap: () {
//                 //     Navigator.pushNamed(context, '/pinned-events');
//                 //   },
//                 // ),
//                 // _buildProfileOption(
//                 //   context,
//                 //   icon: Icons.notifications,
//                 //   title: 'Notifications',
//                 //   onTap: () {},
//                 // ),
//                 _buildProfileOption(
//                 context,
//                 icon: Icons.person_add,
//                 title: 'Invite People',
//                 onTap: _invitePeople,
//               ),

//                 // _buildProfileOption(
//                 //   context,
//                 //   icon: Icons.settings,
//                 //   title: 'Settings',
//                 //   onTap: () {
//                 //     Navigator.pushNamed(context, '/settings');
//                 //   },
//                 // ),
//                 const SizedBox(height: 32),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _showSignOutDialog(context, authProvider);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('Sign Out'),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       _showDeleteAccountDialog(context, authProvider);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('Delete Account'),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfileOption(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).primaryColor),
//         title: Text(title),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

// // void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: const Text('Sign Out'),
// //         content: const Text('Are you sure you want to sign out?'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.of(context).pop(),
// //             child: const Text('Cancel'),
// //           ),
// //           TextButton(
// //             onPressed: () async {
// //               Navigator.of(context).pop(); // Close dialog
              
// //               // Show loading indicator
// //               showDialog(
// //                 context: context,
// //                 barrierDismissible: false,
// //                 builder: (context) => const Center(
// //                   child: CircularProgressIndicator(),
// //                 ),
// //               );

// //               try {
// //                 await authProvider.signOut();
                
// //                 if (context.mounted) {
// //                   // Remove loading indicator
// //                   Navigator.of(context).pop(); 
                  
// //                   // Navigate to login and clear all routes
// //                   Navigator.pushNamedAndRemoveUntil(
// //                     context,
// //                     '/login',
// //                     (route) => false,
// //                   );
// //                 }
// //               } catch (e) {
// //                 if (context.mounted) {
// //                   // Remove loading indicator
// //                   Navigator.of(context).pop();
                  
// //                   // Show error but still navigate to login
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text('Sign out completed locally: ${e.toString()}'),
// //                     ),
// //                   );
                  
// //                   Navigator.pushNamedAndRemoveUntil(
// //                     context,
// //                     '/login',
// //                     (route) => false,
// //                   );
// //                 }
// //               }
// //             },
// //             child: const Text('Sign Out'),
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }

// //   void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Delete Account'),
// //           content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //               child: const Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 Navigator.of(context).pop();
// //                 await authProvider.deleteAccount();
// //                 if (context.mounted) {
// //                   Navigator.pushNamedAndRemoveUntil(
// //                     context,
// //                     '/login',
// //                     (route) => false,
// //                   );
// //                 }
// //               },
// //               child: const Text('Delete', style: TextStyle(color: Colors.red)),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Sign Out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();

//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (_) => const Center(child: CircularProgressIndicator()),
//               );

//               await authProvider.signOut();

//               if (context.mounted) {
//                 Navigator.of(context).pop(); // remove loading
//                 Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//               }
//             },
//             child: const Text('Sign Out'),
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Delete Account'),
//         content: const Text('This action cannot be undone. Are you sure?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.of(context).pop();

//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (_) => const Center(child: CircularProgressIndicator()),
//               );

//               try {
//                 await authProvider.deleteAccount();

//                 if (context.mounted) {
//                   Navigator.of(context).pop(); // remove loading
//                   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//                 }
//               } catch (e) {
//                 if (context.mounted) {
//                   Navigator.of(context).pop(); // remove loading
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: ${e.toString()}')),
//                   );
//                 }
//               }
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       );
//     },
//   );
// }


// }

// PreferredSizeWidget _buildAppBar(BuildContext context) {
//   return AppBar(
//     automaticallyImplyLeading: false,
//     backgroundColor: AppTheme.primaryColor,
//     elevation: 0,
//     centerTitle: true,
//     title: const Text(
//       "Profile",
//         style: TextStyle(
//           fontFamily: 'Poppins', // ✅ Use Poppins family
//           fontWeight: FontWeight.w500, // ✅ Medium weight
//           fontSize: 24,
//           color: Colors.white,
//         ),
//     ),
//     // iconTheme: const IconThemeData(color: Colors.black),
//     // actions: [
//     //   IconButton(
//     //     icon: const Icon(Icons.settings), color: Colors.white,
//     //     onPressed: () {
//     //       Navigator.pushNamed(context, '/settings');
//     //     },
//     //   ),
//     // ],
//   );
// }
















// //worling code 14-8-25

// import 'package:flutter/material.dart';
// import 'package:moments/utils/theme.dart';
// import 'package:moments/widgets/comment_section.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../network_service/network_service.dart';
// import 'package:share_plus/share_plus.dart';

// void _invitePeople() {
//   const appDownloadLink = 'https://yourdomain.page.link/invite';
//   const inviteMessage =
//       "Hey! Check out the Moments app to discover and share events easily. Download now: $appDownloadLink";

//   Share.share(inviteMessage, subject: 'Join me on Moments!');
// }

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _fetchUserData();
//     });
//   }

//   void _showProfilePhoto(String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.zero,
//         child: ProfilePhotoViewer(imageUrl: imageUrl),
//       ),
//     );
//   }

//   Future<void> _fetchUserData() async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     await authProvider.fetchUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Consumer<AuthProvider>(
//         builder: (context, authProvider, child) {
//           if (authProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final user = authProvider.user;

//           if (user == null) {
//             return const Center(child: Text("No user data found."));
//           }

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (user.photo != null && user.photo!.isNotEmpty) {
//                       final imageUrl = NetworkService.getImageUrl(user.photo!, type: 'profile');
//                       _showProfilePhoto(imageUrl);
//                     }
//                   },
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//                     backgroundImage: user.photo != null && user.photo!.isNotEmpty
//                         ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
//                         : null,
//                     child: user.photo == null || user.photo!.isEmpty
//                         ? Icon(
//                             Icons.person,
//                             size: 60,
//                             color: Theme.of(context).primaryColor,
//                           )
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   user.name ?? 'No Name',
//                   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   user.email ?? 'No Email',
//                   style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 32),

//                 _buildProfileOption(context, icon: Icons.edit, title: 'Edit Profile', onTap: () {
//                   Navigator.pushNamed(context, '/edit-profile');
//                 }),
//                 _buildProfileOption(context, icon: Icons.push_pin, title: 'Pinned Events', onTap: () {
//                   Navigator.pushNamed(context, '/pinned-events');
//                 }),
//                 _buildProfileOption(context, icon: Icons.event, title: 'My Events', onTap: () {
//                   Navigator.pushNamed(context, '/my-events-screen');
//                 }),
//                 _buildProfileOption(context, icon: Icons.history, title: 'Completed Events', onTap: () {
//                   Navigator.pushNamed(context, '/completed-events');
//                 }),
//                 _buildProfileOption(context, icon: Icons.person_add, title: 'Invite People', onTap: _invitePeople),

//                 const SizedBox(height: 32),

//                 // Buttons row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _smallActionButton(
//                       label: 'Sign Out',
//                       color: AppTheme.primaryColor,
//                       onPressed: () => _showSignOutDialog(context, authProvider),
//                     ),
//                     const SizedBox(width: 12),
//                     _smallActionButton(
//                       label: 'Delete',
//                        color: AppTheme.primaryColor,
//                       onPressed: () => _showDeleteAccountDialog(context, authProvider),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _smallActionButton({
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       height: 40,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Text(label, style: const TextStyle(fontSize: 14)),
//       ),
//     );
//   }

//   Widget _buildProfileOption(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         leading: Icon(icon, color: Theme.of(context).primaryColor),
//         title: Text(title),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }

//   void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Sign Out'),
//           content: const Text('Are you sure you want to sign out?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (_) => const Center(child: CircularProgressIndicator()),
//                 );

//                 await authProvider.signOut();

//                 if (context.mounted) {
//                   Navigator.of(context).pop();
//                   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//                 }
//               },
//               child: const Text('Sign Out'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Account'),
//           content: const Text('This action cannot be undone. Are you sure?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (_) => const Center(child: CircularProgressIndicator()),
//                 );

//                 try {
//                   await authProvider.deleteAccount();
//                   if (context.mounted) {
//                     Navigator.of(context).pop();
//                     Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     Navigator.of(context).pop();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Error: ${e.toString()}')),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// PreferredSizeWidget _buildAppBar(BuildContext context) {
//   return AppBar(
//     automaticallyImplyLeading: false,
//     backgroundColor: AppTheme.primaryColor,
//     elevation: 0,
//     centerTitle: true,
//     title: const Text(
//       "Profile",
//       style: TextStyle(
//         fontFamily: 'Poppins',
//         fontWeight: FontWeight.w500,
//         fontSize: 24,
//         color: Colors.white,
//       ),
//     ),
//   );
// }




//claude ai


import 'package:flutter/material.dart';
import 'package:moments/utils/theme.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../network_service/network_service.dart';
import 'package:share_plus/share_plus.dart';

void _invitePeople() {
  // const appDownloadLink = 'https://yourdomain.page.link/invite';
    const appDownloadLink = 'https://drive.google.com/drive/folders/1QZYZ8FyYDyZB6UwWUS5pOR-5Pf5jaCps';
  const inviteMessage =
      "Hey! Check out the Moments app to discover and share events easily. Download now: $appDownloadLink";

  Share.share(inviteMessage, subject: 'Join me on Moments!');
}

class ProfilePhotoViewer extends StatelessWidget {
  final String imageUrl;

  const ProfilePhotoViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.white, size: 64),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  // late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    // _slideAnimation = Tween<Offset>(
    //   begin: const Offset(0, 0.3),
    //   end: Offset.zero,
    // ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showProfilePhoto(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: ProfilePhotoViewer(imageUrl: imageUrl),
      ),
    );
  }

  Future<void> _fetchUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
                  // 🔹 Redirect to login if logged out
        if (!authProvider.isAuthenticated) {
          Future.microtask(() {
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          });
          return const SizedBox.shrink(); // empty widget while redirecting
        }
          if (authProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const CircularProgressIndicator(color: AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    "Loading your profile...",
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

          final user = authProvider.user;

          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            // child: SlideTransition(
            //   position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildModernSliverAppBar(user),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileHeader(user),
                          const SizedBox(height: 32),
                          _buildProfileOptions(),
                          const SizedBox(height: 32),
                          _buildActionButtons(authProvider),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          // );
        },
      ),
    );
  }

  Widget _buildModernSliverAppBar(user) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      // expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor,
                AppTheme.primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.1),
            color: Colors.grey.withAlpha((0.5 * 255).round()),

            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (user.photo != null && user.photo!.isNotEmpty) {
                final imageUrl = NetworkService.getImageUrl(user.photo!, type: 'profile');
                _showProfilePhoto(imageUrl);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                backgroundImage: user.photo != null && user.photo!.isNotEmpty
                    ? NetworkImage(NetworkService.getImageUrl(user.photo!, type: 'profile'))
                    : null,
                child: user.photo == null || user.photo!.isEmpty
                    ? const Icon(
                        Icons.person_outline,
                        size: 50,
                        color: AppTheme.primaryColor,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user.name ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(20),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
      const SizedBox(width: 8),
      Flexible( // <-- prevents overflow
        child: Text(
          user.email ?? 'No Email',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  ),
)

        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    final options = [
//       ProfileOption(
//   icon: context.watch<ThemeProvider>().currentThemeIcon,
//   title: 'Theme',
//   subtitle: 'Current: ${context.watch<ThemeProvider>().currentThemeName}',
//   color: const Color(0xFF673AB7),
//   onTap: () {
//     _showThemeDialog(context);
//   },
// ),

      ProfileOption(
        icon: Icons.edit_outlined,
        title: 'Edit Profile',
        subtitle: 'Update your personal information',
        color: const Color(0xFF4CAF50),
        onTap: () => Navigator.pushNamed(context, '/edit-profile'),
      ),
      ProfileOption(
        icon: Icons.push_pin_outlined,
        title: 'Pinned Events',
        subtitle: 'View your saved events',
        color: const Color(0xFFFF9800),
        onTap: () => Navigator.pushNamed(context, '/pinned-events'),
      ),
      ProfileOption(
        icon: Icons.event_outlined,
        title: 'My Events',
        subtitle: 'Events you\'ve created',
        color: const Color(0xFF2196F3),
        onTap: () => Navigator.pushNamed(context, '/my-events-screen'),
      ),
      ProfileOption(
        icon: Icons.history_outlined,
        title: 'Completed Events',
        subtitle: 'Past events you attended',
        color: const Color(0xFF9C27B0),
        onTap: () => Navigator.pushNamed(context, '/completed-events'),
      ),
      ProfileOption(
        icon: Icons.person_add_outlined,
        title: 'Invite People',
        subtitle: 'Share the app with friends',
        color: const Color(0xFFE91E63),
        onTap: _invitePeople,
      ),
    ];

    return Column(
      children: options.map((option) => _buildModernOptionCard(option)).toList(),
    );
  }


//   void _showThemeDialog(BuildContext context) {
//   final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text("Choose Theme"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           RadioListTile<ThemeMode>(
//             title: const Text("Light"),
//             value: ThemeMode.light,
//             groupValue: themeProvider.themeMode,
//             onChanged: (mode) => themeProvider.setThemeMode(mode!),
//           ),
//           RadioListTile<ThemeMode>(
//             title: const Text("Dark"),
//             value: ThemeMode.dark,
//             groupValue: themeProvider.themeMode,
//             onChanged: (mode) => themeProvider.setThemeMode(mode!),
//           ),
//           RadioListTile<ThemeMode>(
//             title: const Text("System"),
//             value: ThemeMode.system,
//             groupValue: themeProvider.themeMode,
//             onChanged: (mode) => themeProvider.setThemeMode(mode!),
//           ),
//         ],
//       ),
//     ),
//   );
// }


  Widget _buildModernOptionCard(ProfileOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: option.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            option.icon,
            color: option.color,
            size: 24,
          ),
        ),
        title: Text(
          option.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          option.subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: option.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: option.color,
          ),
        ),
        onTap: option.onTap,
      ),
    );
  }

Widget _buildActionButtons(AuthProvider authProvider) {
  return Row(
    children: [
      Expanded(
        child: _buildModernActionButton(
          label: 'Sign Out',
          icon: Icons.logout_outlined,
          color: const Color(0xFFFF5722),
          onPressed: () => _showSignOutDialog(context, authProvider),
        ),
      ),
      const SizedBox(width: 8), // Reduced spacing
      Expanded(
        child: _buildModernActionButton(
          label: 'Delete',
          icon: Icons.delete_outlined,
          color: const Color(0xFFB71C1C),
          onPressed: () => _showDeleteAccountDialog(context, authProvider),
        ),
      ),
    ],
  );
}

  Widget _buildModernActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sign Out',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.of(context).pop(); // close confirm dialog
              await authProvider.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      );
    },
  );
}


  // void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         title: Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: Colors.orange.withOpacity(0.15),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.logout, color: Colors.orange, size: 20),
  //             ),
  //             const SizedBox(width: 12),
  //             const Text(
  //               'Sign Out',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //         content: const Text(
  //           'Are you sure you want to sign out of your account?',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             style: TextButton.styleFrom(
  //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             ),
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
  //             ),
  //           ),
  //           Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [Colors.orange, Colors.orange.withOpacity(0.8)],
  //               ),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: TextButton(
  //               onPressed: () async {
  //                 Navigator.of(context).pop();

  //                 showDialog(
  //                   context: context,
  //                   barrierDismissible: false,
  //                   builder: (_) => AlertDialog(
  //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //                     content:const Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         CircularProgressIndicator(color: AppTheme.primaryColor),
  //                         SizedBox(height: 16),
  //                         Text('Signing out...'),
  //                       ],
  //                     ),
  //                   ),
  //                 );

  //                 await authProvider.signOut();

  //                 if (context.mounted) {
  //                   Navigator.of(context).pop();
  //                   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  //                 }
  //               },
  //               style: TextButton.styleFrom(
  //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //               ),
  //               child: const Text(
  //                 'Sign Out',
  //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Are you sure you want to delete your account?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.red.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.red),
                          SizedBox(height: 16),
                          Text('Deleting account...'),
                        ],
                      ),
                    ),
                  );

                  try {
                    await authProvider.deleteAccount();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text('Error: ${e.toString()}')),
                            ],
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileOption {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}