// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:moments/screens/events/create_event_screen.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/home/home_screen.dart';
// import 'package:moments/screens/profile/profile_screen.dart';
// import 'package:moments/utils/theme.dart';

// class MyNavigationBar extends StatefulWidget {
//   const MyNavigationBar({super.key});

//   @override
//   State<MyNavigationBar> createState() => _MyNavigationBarState();
// }

// class _MyNavigationBarState extends State<MyNavigationBar> {
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   int currentIndex = 0;
//   final List<Widget> buildPages = [
//     const HomeScreen(),
//     const CreateEventScreen(),
//     const EventCalendarScreen(),
//     // const PinnedEventsScreen(),
//     const ProfileScreen(),
//   ];

//   void updateIndex(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: buildPages[currentIndex],
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: currentIndex,
//         height: 60,
//         backgroundColor: AppTheme.backgroundColor,
//         color: AppTheme.primaryColor,
//         buttonBackgroundColor: AppTheme.primaryColor,
//         letIndexChange: (index) => true,
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 600),
//         items: [
//           _customIcons("assets/images/homes.png", 0),
//           _customIcons("assets/images/add.png", 1),
//           _customIcons("assets/images/appointment.png", 2),
//           _customIcons("assets/images/profile.png", 3),
//         ],
//         onTap: (int index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   Widget _customIcons(String imagePath, int index) {
//     Color iconColor = currentIndex == index ? Colors.white : Colors.black;

//     return Image.asset(
//       imagePath,
//       width: 24.0,
//       height: 24.0,
//       color: iconColor,
//       colorBlendMode: BlendMode.srcIn,
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:moments/screens/events/create_event_screen.dart';
// import 'package:moments/screens/events/event_calendar_screen.dart';
// import 'package:moments/screens/home/home_screen.dart';
// import 'package:moments/screens/profile/profile_screen.dart';
// import 'package:moments/utils/theme.dart';

// class MyNavigationBar extends StatefulWidget {
//   const MyNavigationBar({super.key});

//   @override
//   State<MyNavigationBar> createState() => _MyNavigationBarState();
// }

// class _MyNavigationBarState extends State<MyNavigationBar> {
//   int currentIndex = 0;

//   final List<Widget> pages = [
//     const HomeScreen(),
//     const CreateEventScreen(),
//     const EventCalendarScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 300),
//         child: pages[currentIndex],
//       ),
//       bottomNavigationBar: NavigationBar(
//         height: 70,
//         selectedIndex: currentIndex,
//         onDestinationSelected: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         backgroundColor: colorScheme.surface,
//         indicatorColor: AppTheme.primaryColor.withOpacity(0.1),
//         labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined, color: Colors.grey),
//             selectedIcon: Icon(Icons.home, color: AppTheme.primaryColor),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.add_circle_outline, color: Colors.grey),
//             selectedIcon: Icon(Icons.add_circle, color: AppTheme.primaryColor),
//             label: 'Event',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
//             selectedIcon: Icon(Icons.calendar_today, color: AppTheme.primaryColor),
//             label: 'Calendar',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outline, color: Colors.grey),
//             selectedIcon: Icon(Icons.person, color: AppTheme.primaryColor),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'package:moments/screens/events/create_event_screen.dart';
import 'package:moments/screens/events/event_calendar_screen.dart';
import 'package:moments/screens/home/home_screen.dart';
import 'package:moments/screens/profile/profile_screen.dart';
import 'package:moments/utils/theme.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> with TickerProviderStateMixin {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const CreateEventScreen(),
    const EventCalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: colorScheme.surface,
        // ignore: deprecated_member_use
        indicatorColor: AppTheme.primaryColor.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: _navIcon("assets/images/homes.png", 0),
            selectedIcon: _navIcon("assets/images/homes.png", 0, isSelected: true),
            label: 'Home',
          ),
          NavigationDestination(
            icon: _navIcon("assets/images/add.png", 1),
            selectedIcon: _navIcon("assets/images/add.png", 1, isSelected: true),
            label: 'Create',
          ),
          NavigationDestination(
            icon: _navIcon("assets/images/appointment.png", 2),
            selectedIcon: _navIcon("assets/images/appointment.png", 2, isSelected: true),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: _navIcon("assets/images/profile.png", 3),
            selectedIcon: _navIcon("assets/images/profile.png", 3, isSelected: true),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _navIcon(String asset, int index, {bool isSelected = false}) {
    return Image.asset(
      asset,
      width: 26,
      height: 26,
      color: isSelected || currentIndex == index ? AppTheme.primaryColor : Colors.grey[600],
      colorBlendMode: BlendMode.srcIn,
    );
  }
}
