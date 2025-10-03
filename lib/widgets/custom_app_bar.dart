// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:moments/utils/theme.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppBar({super.key,});

//   // Define AppBar size
//   @override
//   Size get preferredSize => const Size.fromHeight(56);

//   // Build Custom AppBar
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       title: const Text(
//         'Moments',
//         style: TextStyle(
//           fontFamily: 'Poppins', // ✅ Use Poppins family
//           fontWeight: FontWeight.w500, // ✅ Medium weight
//           fontSize: 30,
//           color: Colors.white,
//         ),
//       ),
//       backgroundColor: AppTheme.primaryColor,
//       elevation: 0,
//       centerTitle: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: AppTheme.primaryColor,
//       ),
//       child: _buildAppBar(context),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moments/utils/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        'MOMENTS',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 30,
          color: Colors.white,
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.push_pin, color: Colors.white),
          tooltip: 'View Pinned Events',
          onPressed: () {
            Navigator.pushNamed(context, '/pinned-events');
          },
        ),
      ],
// actions: [
//   Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
    // child: Container(
    //   decoration: const BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: Colors.white, // white background
    //   ),
    //   padding: const EdgeInsets.all(4), // spacing inside the circle
    //   child: Image.asset(
    //     'assets/images/moments1.png',
    //     height: 28,
    //     width: 28,
    //     fit: BoxFit.contain,
    //   ),
    // ),
//   ),
// ],

    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppTheme.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
      child: _buildAppBar(context),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const CustomAppBar({super.key});

//   @override
//   Size get preferredSize => const Size.fromHeight(56);

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent, // Transparent to blend with gradient
//         statusBarIconBrightness: Brightness.light,
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFEF4444), Color(0xFFF59E0B)], // Red to Yellow
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ),
//         ),
//         child: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           title: const Text(
//             'Moments',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.w500,
//               fontSize: 30,
//               color: Colors.white,
//             ),
//           ),
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//         ),
//       ),
//     );
//   }
// }
