// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _animationController.forward();

//     // Defer initialization to avoid setState/notifyListeners during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 2));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return FadeTransition(
//               opacity: _fadeAnimation,
//               child: ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             // ignore: deprecated_member_use
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.asset(
//                           'assets/images/moments.png',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     const Text(
//                       'Create & Share Your Special Events',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white70,
//                         letterSpacing: 1,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }






















// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> 
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;
//   late Animation<Offset> _textSlideAnimation;
//   late Animation<Color?> _gradientAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     );

//     // Multiple animations for modern effects
//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeInCubic),
//       ),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
//       ),
//     );

//     _rotateAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.4, 0.8, curve: Curves.easeInOutBack),
//       ),
//     );

//     _textSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: const Interval(0.5, 1.0, curve: Curves.easeOutQuart),
//       ),
//     );

//     _gradientAnimation = ColorTween(
//       begin: Colors.deepPurple[400],
//       end: Colors.indigo[700],
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     _animationController.forward();

//     // Defer initialization to avoid setState/notifyListeners during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       // Wait for animation to complete (3 seconds) plus a little extra
//       await Future.delayed(const Duration(milliseconds: 3200));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Scaffold(
//           backgroundColor: _gradientAnimation.value,
//           body: Stack(
//             children: [
//               // Animated background elements
//               Positioned(
//                 top: -50,
//                 right: -50,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -80,
//                 left: -80,
//                 child: Container(
//                   width: 250,
//                   height: 250,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white.withOpacity(0.1),
//                   ),
//                 ),
//               ),
              
//               Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Logo with multiple animations
//                     FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: ScaleTransition(
//                         scale: _scaleAnimation,
//                         child: RotationTransition(
//                           turns: _rotateAnimation,
//                           child: Container(
//                             width: 140,
//                             height: 140,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.white,
//                                   Colors.white70,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.3),
//                                   blurRadius: 25,
//                                   offset: const Offset(0, 15),
//                                   spreadRadius: 0,
//                                 ),
//                               ],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(25),
//                               child: Image.asset(
//                                 'assets/images/moments.png',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 40),
                    
//                     // Text with slide animation
//                     SlideTransition(
//                       position: _textSlideAnimation,
//                       child: Column(
//                         children: [
//                           Text(
//                             'Moments',
//                             style: TextStyle(
//                               fontSize: 36,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.white,
//                               letterSpacing: 1.5,
//                               shadows: [
//                                 Shadow(
//                                   blurRadius: 10.0,
//                                   color: Colors.black.withOpacity(0.2),
//                                   offset: const Offset(2.0, 2.0),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Create & Share Your Special Events',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white.withOpacity(0.9),
//                               letterSpacing: 1.1,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
                    
//                     const SizedBox(height: 50),
                    
//                     // Modern loading indicator
//                     SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.white.withOpacity(0.8),
//                         ),
//                         strokeWidth: 2.5,
//                         backgroundColor: Colors.white.withOpacity(0.2),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }




// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _logoController;
//   late AnimationController _backgroundController;
//   late AnimationController _textController;
//   late AnimationController _particleController;
  
//   late Animation<double> _logoScale;
//   late Animation<double> _logoOpacity;
//   late Animation<double> _logoRotation;
//   late Animation<Offset> _logoSlide;
  
//   late Animation<double> _backgroundGradient;
//   late Animation<double> _textOpacity;
//   late Animation<Offset> _textSlide;
  
//   late Animation<double> _particleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Logo animations
//     _logoController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     // Background animations
//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     // Text animations
//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     // Particle animations
//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     )..repeat();

//     _setupAnimations();
//     _startAnimationSequence();

//     // Defer initialization to avoid setState/notifyListeners during build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   void _setupAnimations() {
//     // Logo animations
//     _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: Curves.elasticOut,
//       ),
//     );

//     _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: Curves.easeOut,
//       ),
//     );

//     _logoSlide = Tween<Offset>(
//       begin: const Offset(0, -0.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: Curves.bounceOut,
//       ),
//     );

//     // Background gradient animation
//     _backgroundGradient = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _backgroundController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Text animations
//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: Curves.easeOut,
//       ),
//     );

//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: Curves.easeOut,
//       ),
//     );

//     // Particle animation
//     _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _particleController,
//         curve: Curves.linear,
//       ),
//     );
//   }

//   void _startAnimationSequence() async {
//     _backgroundController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 200));
//     _logoController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 800));
//     _textController.forward();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 3));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _backgroundController.dispose();
//     _textController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
    
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _logoController,
//           _backgroundController,
//           _textController,
//           _particleController,
//         ]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color.lerp(
//                     const Color(0xFF667eea),
//                     const Color(0xFF764ba2),
//                     _backgroundGradient.value,
//                   )!,
//                   Color.lerp(
//                     const Color(0xFF764ba2),
//                     const Color(0xFFf093fb),
//                     _backgroundGradient.value,
//                   )!,
//                 ],
//                 stops: const [0.0, 1.0],
//               ),
//             ),
//             child: Stack(
//               children: [
//                 // Animated particles
//                 ...List.generate(20, (index) => _buildParticle(index, size)),
                
//                 // Main content
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Animated logo
//                       SlideTransition(
//                         position: _logoSlide,
//                         child: FadeTransition(
//                           opacity: _logoOpacity,
//                           child: Transform.rotate(
//                             angle: _logoRotation.value,
//                             child: ScaleTransition(
//                               scale: _logoScale,
//                               child: Container(
//                                 width: 140,
//                                 height: 140,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                     colors: [
//                                       Colors.white,
//                                       Color(0xFFF8F9FA),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(35),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.3),
//                                       blurRadius: 30,
//                                       offset: const Offset(0, 15),
//                                       spreadRadius: -5,
//                                     ),
//                                     BoxShadow(
//                                       color: Colors.white.withOpacity(0.8),
//                                       blurRadius: 20,
//                                       offset: const Offset(0, -5),
//                                       spreadRadius: -10,
//                                     ),
//                                   ],
//                                 ),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(30),
//                                   child: Container(
//                                     padding: const EdgeInsets.all(20),
//                                     child: Image.asset(
//                                       'assets/images/moments.png',
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 50),
                      
//                       // Animated text
//                       SlideTransition(
//                         position: _textSlide,
//                         child: FadeTransition(
//                           opacity: _textOpacity,
//                           child: Column(
//                             children: [
//                               ShaderMask(
//                                 shaderCallback: (bounds) => const LinearGradient(
//                                   colors: [Colors.white, Color(0xFFF0F0F0)],
//                                 ).createShader(bounds),
//                                 child: const Text(
//                                   'Moments',
//                                   style: TextStyle(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: 2,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 12),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                     color: Colors.white.withOpacity(0.3),
//                                     width: 1,
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Create & Share Your Special Events',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                     letterSpacing: 0.5,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
                      
//                       const SizedBox(height: 80),
                      
//                       // Loading indicator
//                       FadeTransition(
//                         opacity: _textOpacity,
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: const CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildParticle(int index, Size size) {
//     final random = (index * 0.1) % 1.0;
//     final startX = (size.width * random);
//     final startY = size.height + 50;
//     const endY = -50.0;
    
//     final animationValue = (_particleAnimation.value + random) % 1.0;
//     final currentY = startY + (endY - startY) * animationValue;
    
//     final opacity = animationValue < 0.1 
//         ? animationValue * 10 
//         : animationValue > 0.9 
//             ? (1.0 - animationValue) * 10 
//             : 1.0;

//     return Positioned(
//       left: startX,
//       top: currentY,
//       child: Opacity(
//         opacity: opacity * 0.6,
//         child: Container(
//           width: 4 + (random * 6),
//           height: 4 + (random * 6),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.8),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.5),
//                 blurRadius: 4,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




































// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   static const Color primaryColor = Color(0xFF6C63FF);
  
//   late AnimationController _zoomController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//   late AnimationController _glowController;
  
//   late Animation<double> _zoomAnimation;
//   late Animation<double> _textOpacity;
//   late Animation<double> _taglineOpacity;
//   late Animation<Offset> _textSlide;
//   late Animation<Offset> _taglineSlide;
//   late Animation<double> _backgroundScale;
//   late Animation<double> _glowAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Controllers
//     _zoomController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2500),
//     );

//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     _setupAnimations();
//     _startAnimations();

//     // Initialize app
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   void _setupAnimations() {
//     // Zoom in animation (starts large and zooms in)
//     _zoomAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _zoomController,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     // Background scale animation
//     _backgroundScale = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(
//         parent: _backgroundController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Text animations
//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
//       ),
//     );

//     // Tagline animations
//     _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     _taglineSlide = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     // Glow animation
//     _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _glowController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   void _startAnimations() async {
//     _backgroundController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 100));
//     _zoomController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 500));
//     _textController.forward();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 3));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _zoomController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _zoomController,
//           _textController,
//           _backgroundController,
//           _glowController,
//         ]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Stack(
//               children: [
//                 // Animated background
//                 Transform.scale(
//                   scale: _backgroundScale.value,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: RadialGradient(
//                         center: Alignment.center,
//                         radius: 1.0,
//                         colors: [
//                           primaryColor.withOpacity(0.8),
//                           primaryColor,
//                           primaryColor.withOpacity(0.9),
//                           Colors.black.withOpacity(0.1),
//                         ],
//                         stops: const [0.0, 0.4, 0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Animated circles for depth
//                 ...List.generate(3, (index) => _buildBackgroundCircle(index, size)),

//                 // Main content with zoom effect
//                 Transform.scale(
//                   scale: _zoomAnimation.value,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Main title "Moments"
//                         SlideTransition(
//                           position: _textSlide,
//                           child: FadeTransition(
//                             opacity: _textOpacity,
//                             child: Container(
//                               child: Stack(
//                                 children: [
//                                   // Glow effect
//                                   AnimatedBuilder(
//                                     animation: _glowAnimation,
//                                     builder: (context, child) {
//                                       return Text(
//                                         'Moments',
//                                         style: TextStyle(
//                                           fontSize: 48,
//                                           fontWeight: FontWeight.w900,
//                                           foreground: Paint()
//                                             ..style = PaintingStyle.stroke
//                                             ..strokeWidth = 8
//                                             ..color = Colors.white.withOpacity(_glowAnimation.value * 0.3)
//                                             ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
//                                           letterSpacing: 3,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   // Main text
//                                   ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.white,
//                                         Colors.white.withOpacity(0.9),
//                                         Colors.white.withOpacity(0.8),
//                                       ],
//                                     ).createShader(bounds),
//                                     child: const Text(
//                                       'Moments',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         letterSpacing: 3,
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(0, 4),
//                                             blurRadius: 8,
//                                             color: Colors.black26,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Tagline
//                         SlideTransition(
//                           position: _taglineSlide,
//                           child: FadeTransition(
//                             opacity: _taglineOpacity,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 16,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(30),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.2),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 20,
//                                     offset: const Offset(0, 8),
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Create & Share Your Special Events',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                   letterSpacing: 1,
//                                   height: 1.2,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 60),

//                         // Loading indicator
//                         FadeTransition(
//                           opacity: _taglineOpacity,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.15),
//                               borderRadius: BorderRadius.circular(25),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.3),
//                                 width: 2,
//                               ),
//                             ),
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 3,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBackgroundCircle(int index, Size size) {
//     final delays = [0.0, 0.3, 0.6];
//     final sizes = [300.0, 200.0, 100.0];
//     final opacities = [0.1, 0.05, 0.03];
    
//     return AnimatedBuilder(
//       animation: _backgroundController,
//       builder: (context, child) {
//         final animationValue = ((_backgroundController.value - delays[index]).clamp(0.0, 1.0));
//         final scale = 0.5 + (animationValue * 0.5);
        
//         return Positioned(
//           top: size.height * 0.5 - (sizes[index] * scale) / 2,
//           left: size.width * 0.5 - (sizes[index] * scale) / 2,
//           child: Transform.scale(
//             scale: scale,
//             child: Container(
//               width: sizes[index],
//               height: sizes[index],
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(opacities[index] * animationValue),
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.1 * animationValue),
//                   width: 2,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }









// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   static const Color primaryColor = Color(0xFF6C63FF);
  
//   late AnimationController _zoomController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//   late AnimationController _glowController;
  
//   late Animation<double> _zoomAnimation;
//   late Animation<double> _textOpacity;
//   late Animation<double> _taglineOpacity;
//   late Animation<Offset> _textSlide;
//   late Animation<Offset> _taglineSlide;
//   late Animation<double> _backgroundScale;
//   late Animation<double> _glowAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Controllers
//     _zoomController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2500),
//     );

//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     _setupAnimations();
//     _startAnimations();

//     // Initialize app
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   void _setupAnimations() {
//     // Zoom in animation (starts large and zooms in)
//     _zoomAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _zoomController,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     // Background scale animation
//     _backgroundScale = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(
//         parent: _backgroundController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Text animations
//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
//       ),
//     );

//     // Tagline animations
//     _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     _taglineSlide = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     // Glow animation
//     _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _glowController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   void _startAnimations() async {
//     _backgroundController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 100));
//     _zoomController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 500));
//     _textController.forward();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 3));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _zoomController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     _glowController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _zoomController,
//           _textController,
//           _backgroundController,
//           _glowController,
//         ]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Stack(
//               children: [
//                 // Animated background
//                 Transform.scale(
//                   scale: _backgroundScale.value,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           primaryColor.withOpacity(0.9),
//                           primaryColor,
//                           const Color(0xFF5A52D5),
//                           const Color(0xFF4A42B8),
//                         ],
//                         stops: const [0.0, 0.3, 0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Animated circles for depth
//                 ...List.generate(3, (index) => _buildBackgroundCircle(index, size)),

//                 // Main content with zoom effect
//                 Transform.scale(
//                   scale: _zoomAnimation.value,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Main title "Moments"
//                         SlideTransition(
//                           position: _textSlide,
//                           child: FadeTransition(
//                             opacity: _textOpacity,
//                             child: Container(
//                               child: Stack(
//                                 children: [
//                                   // Glow effect
//                                   AnimatedBuilder(
//                                     animation: _glowAnimation,
//                                     builder: (context, child) {
//                                       return Text(
//                                         'Moments',
//                                         style: TextStyle(
//                                           fontSize: 48,
//                                           fontWeight: FontWeight.w900,
//                                           foreground: Paint()
//                                             ..style = PaintingStyle.stroke
//                                             ..strokeWidth = 8
//                                             ..color = Colors.white.withOpacity(_glowAnimation.value * 0.3)
//                                             ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
//                                           letterSpacing: 3,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   // Main text
//                                   ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.white,
//                                         Colors.white.withOpacity(0.9),
//                                         Colors.white.withOpacity(0.8),
//                                       ],
//                                     ).createShader(bounds),
//                                     child: const Text(
//                                       'Moments',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         letterSpacing: 3,
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(0, 4),
//                                             blurRadius: 8,
//                                             color: Colors.black26,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Tagline with modern design
//                         SlideTransition(
//                           position: _taglineSlide,
//                           child: FadeTransition(
//                             opacity: _taglineOpacity,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 28,
//                                 vertical: 14,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF8B83FF).withOpacity(0.2),
//                                     const Color(0xFF6C63FF).withOpacity(0.15),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(25),
//                                 border: Border.all(
//                                   color: const Color(0xFF8B83FF).withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(0xFF4A42B8).withOpacity(0.3),
//                                     blurRadius: 15,
//                                     offset: const Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Create & Share Your Special Events',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFFF0F2FF),
//                                   letterSpacing: 0.8,
//                                   height: 1.3,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 60),

//                         // Modern loading indicator
//                         FadeTransition(
//                           opacity: _taglineOpacity,
//                           child: Container(
//                             width: 45,
//                             height: 45,
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   const Color(0xFF8B83FF).withOpacity(0.25),
//                                   const Color(0xFF6C63FF).withOpacity(0.2),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(22.5),
//                               border: Border.all(
//                                 color: const Color(0xFF9B95FF).withOpacity(0.4),
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFF4A42B8).withOpacity(0.2),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 2.5,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Color(0xFFE8E9FF),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBackgroundCircle(int index, Size size) {
//     final delays = [0.0, 0.3, 0.6];
//     final sizes = [280.0, 180.0, 90.0];
//     final colors = [
//       const Color(0xFF8B83FF).withOpacity(0.08),
//       const Color(0xFF9B95FF).withOpacity(0.05),
//       const Color(0xFFB5B1FF).withOpacity(0.03),
//     ];
    
//     return AnimatedBuilder(
//       animation: _backgroundController,
//       builder: (context, child) {
//         final animationValue = ((_backgroundController.value - delays[index]).clamp(0.0, 1.0));
//         final scale = 0.6 + (animationValue * 0.4);
        
//         return Positioned(
//           top: size.height * 0.5 - (sizes[index] * scale) / 2,
//           left: size.width * 0.5 - (sizes[index] * scale) / 2,
//           child: Transform.scale(
//             scale: scale,
//             child: Container(
//               width: sizes[index],
//               height: sizes[index],
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: colors[index],
//                 border: Border.all(
//                   color: const Color(0xFF8B83FF).withOpacity(0.1 * animationValue),
//                   width: 1.5,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }










// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   static const Color primaryColor = Color(0xFF6C63FF);
  
//   late AnimationController _zoomController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//   late AnimationController _glowController;
//   late AnimationController _rippleController;
  
//   late Animation<double> _zoomAnimation;
//   late Animation<double> _textOpacity;
//   late Animation<double> _taglineOpacity;
//   late Animation<Offset> _textSlide;
//   late Animation<Offset> _taglineSlide;
//   late Animation<double> _backgroundScale;
//   late Animation<double> _glowAnimation;
//   late Animation<double> _rippleAnimation;

//   // Ripple circles data
//   final List<Map<String, dynamic>> _ripples = [
//     {'size': 100.0, 'delay': 0.0, 'color': Color(0xFF8B83FF).withOpacity(0.15)},
//     {'size': 200.0, 'delay': 0.3, 'color': Color(0xFF9B95FF).withOpacity(0.1)},
//     {'size': 300.0, 'delay': 0.6, 'color': Color(0xFFB5B1FF).withOpacity(0.05)},
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Controllers
//     _zoomController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );

//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2500),
//     );

//     _glowController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     )..repeat(reverse: true);

//     _rippleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     )..repeat(reverse: true);

//     _setupAnimations();
//     _startAnimations();

//     // Initialize app
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   void _setupAnimations() {
//     // Zoom in animation (starts large and zooms in)
//     _zoomAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _zoomController,
//         curve: Curves.easeOutCubic,
//       ),
//     );

//     // Background scale animation
//     _backgroundScale = Tween<double>(begin: 0.8, end: 1.2).animate(
//       CurvedAnimation(
//         parent: _backgroundController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Text animations
//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//       ),
//     );

//     _textSlide = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
//       ),
//     );

//     // Tagline animations
//     _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     _taglineSlide = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
//       ),
//     );

//     // Glow animation
//     _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _glowController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Ripple animation
//     _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _rippleController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }

//   void _startAnimations() async {
//     _backgroundController.forward();
//     _rippleController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 100));
//     _zoomController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 500));
//     _textController.forward();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 3));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _zoomController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     _glowController.dispose();
//     _rippleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _zoomController,
//           _textController,
//           _backgroundController,
//           _glowController,
//           _rippleController,
//         ]),
//         builder: (context, child) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Stack(
//               children: [
//                 // Animated background
//                 Transform.scale(
//                   scale: _backgroundScale.value,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           primaryColor.withOpacity(0.9),
//                           primaryColor,
//                           const Color(0xFF5A52D5),
//                           const Color(0xFF4A42B8),
//                         ],
//                         stops: const [0.0, 0.3, 0.7, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Ripple effect circles
//                 ..._ripples.map((ripple) => _buildRippleCircle(
//                   ripple['size'], 
//                   ripple['delay'], 
//                   ripple['color'],
//                   size,
//                 )).toList(),

//                 // Main content with zoom effect
//                 Transform.scale(
//                   scale: _zoomAnimation.value,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Main title "Moments"
//                         SlideTransition(
//                           position: _textSlide,
//                           child: FadeTransition(
//                             opacity: _textOpacity,
//                             child: Container(
//                               child: Stack(
//                                 children: [
//                                   // Glow effect
//                                   AnimatedBuilder(
//                                     animation: _glowAnimation,
//                                     builder: (context, child) {
//                                       return Text(
//                                         'Moments',
//                                         style: TextStyle(
//                                           fontSize: 48,
//                                           fontWeight: FontWeight.w900,
//                                           foreground: Paint()
//                                             ..style = PaintingStyle.stroke
//                                             ..strokeWidth = 8
//                                             ..color = Colors.white.withOpacity(_glowAnimation.value * 0.3)
//                                             ..maskFilter = MaskFilter.blur(BlurStyle.outer, 10),
//                                           letterSpacing: 3,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   // Main text
//                                   ShaderMask(
//                                     shaderCallback: (bounds) => LinearGradient(
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                       colors: [
//                                         Colors.white,
//                                         Colors.white.withOpacity(0.9),
//                                         Colors.white.withOpacity(0.8),
//                                       ],
//                                     ).createShader(bounds),
//                                     child: const Text(
//                                       'Moments',
//                                       style: TextStyle(
//                                         fontSize: 48,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.white,
//                                         letterSpacing: 3,
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(0, 4),
//                                             blurRadius: 8,
//                                             color: Colors.black26,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Tagline with modern design
//                         SlideTransition(
//                           position: _taglineSlide,
//                           child: FadeTransition(
//                             opacity: _taglineOpacity,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 28,
//                                 vertical: 14,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF8B83FF).withOpacity(0.2),
//                                     const Color(0xFF6C63FF).withOpacity(0.15),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(25),
//                                 border: Border.all(
//                                   color: const Color(0xFF8B83FF).withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(0xFF4A42B8).withOpacity(0.3),
//                                     blurRadius: 15,
//                                     offset: const Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Create & Share Your Special Events',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFFF0F2FF),
//                                   letterSpacing: 0.8,
//                                   height: 1.3,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 60),

//                         // Modern loading indicator
//                         FadeTransition(
//                           opacity: _taglineOpacity,
//                           child: Container(
//                             width: 45,
//                             height: 45,
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   const Color(0xFF8B83FF).withOpacity(0.25),
//                                   const Color(0xFF6C63FF).withOpacity(0.2),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(22.5),
//                               border: Border.all(
//                                 color: const Color(0xFF9B95FF).withOpacity(0.4),
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: const Color(0xFF4A42B8).withOpacity(0.2),
//                                   blurRadius: 12,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: const CircularProgressIndicator(
//                               strokeWidth: 2.5,
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 Color(0xFFE8E9FF),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildRippleCircle(double size, double delay, Color color, Size screenSize) {
//     return Positioned(
//       top: screenSize.height * 0.5 - size / 2,
//       left: screenSize.width * 0.5 - size / 2,
//       child: AnimatedBuilder(
//         animation: _rippleController,
//         builder: (context, child) {
//           final animationValue = ((_rippleController.value - delay).clamp(0.0, 1.0));
//           final scale = 0.8 + (animationValue * 0.4);
//           final opacity = 1.0 - animationValue;
          
//           return Transform.scale(
//             scale: scale,
//             child: Opacity(
//               opacity: opacity,
//               child: Container(
//                 width: size,
//                 height: size,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: color.withOpacity(opacity * 0.5),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



































import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moments/network_service/network_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF6C63FF);
  
  late AnimationController _zoomController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _glowController;
  late AnimationController _rippleController;
  late AnimationController _fadeController;
  
  late Animation<double> _zoomAnimation;
  late Animation<double> _textOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _textSlide;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _backgroundScale;
  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;

  // // Ripple circles data
  // final List<Map<String, dynamic>> _ripples = [
  //   {'size': 100.0, 'delay': 0.0, 'color': const Color(0xFF8B83FF).withOpacity(0.15)},
  //   {'size': 200.0, 'delay': 0.3, 'color': const Color(0xFF9B95FF).withOpacity(0.1)},
  //   {'size': 300.0, 'delay': 0.6, 'color': const Color(0xFFB5B1FF).withOpacity(0.05)},
  // ];

  @override
  void initState() {
    super.initState();

    // Controllers
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _setupAnimations();
    _startAnimations();

    // Initialize app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  void _setupAnimations() {
    // Zoom in animation (starts large and zooms in)
    _zoomAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Background scale animation
    _backgroundScale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Tagline animations
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // Glow animation
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
    // Fade animation to prevent white screen
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimations() async {
    _fadeController.forward(); // Start fade animation first
    _backgroundController.forward();
    _rippleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 100));
    _zoomController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();

      await _getFcmToken();

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Future<void> _getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token");

      if (token != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcmToken', token);
        
        // Also listen for token refresh
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
          debugPrint("FCM Token refreshed: $newToken");
          await prefs.setString('fcmToken', newToken);
          
          // Update token on server if user is logged in
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          if (authProvider.isAuthenticated) {
            await NetworkService.updateFcmToken(authProvider.user!.userToken, newToken);
          }
        });
      }
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _glowController.dispose();
    _rippleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: primaryColor, // Set background color to prevent white flash
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _zoomController,
          _textController,
          _backgroundController,
          _glowController,
          _rippleController,
          _fadeController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: primaryColor, // Ensure background color is set
              child: Stack(
                children: [
                  // Animated background
                  Transform.scale(
                    scale: _backgroundScale.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.9),
                            primaryColor,
                            const Color(0xFF5A52D5),
                            const Color(0xFF4A42B8),
                          ],
                          stops: const [0.0, 0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Main content with zoom effect
                  Transform.scale(
                    scale: _zoomAnimation.value,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Main title "Moments"
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: Container(
                                child: Stack(
                                  children: [
                                    // Glow effect
                                    AnimatedBuilder(
                                      animation: _glowAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          'Moments',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.w900,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 8
                                              ..color = Colors.white.withOpacity(_glowAnimation.value * 0.3)
                                              ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
                                            letterSpacing: 3,
                                          ),
                                        );
                                      },
                                    ),
                                    // Main text
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0.9),
                                          Colors.white.withOpacity(0.8),
                                        ],
                                      ).createShader(bounds),
                                      child: const Text(
                                        'Moments',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 3,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 8,
                                              color: Colors.black26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Tagline with modern design
                          SlideTransition(
                            position: _taglineSlide,
                            child: FadeTransition(
                              opacity: _taglineOpacity,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF8B83FF).withOpacity(0.2),
                                      const Color(0xFF6C63FF).withOpacity(0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: const Color(0xFF8B83FF).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4A42B8).withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Create & Share Your Special Events',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF0F2FF),
                                    letterSpacing: 0.8,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Modern loading indicator
                          // FadeTransition(
                          //   opacity: _taglineOpacity,
                          //   child: Container(
                          //     width: 45,
                          //     height: 45,
                          //     padding: const EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //       gradient: LinearGradient(
                          //         colors: [
                          //           const Color(0xFF8B83FF).withOpacity(0.25),
                          //           const Color(0xFF6C63FF).withOpacity(0.2),
                          //         ],
                          //       ),
                          //       borderRadius: BorderRadius.circular(22.5),
                          //       border: Border.all(
                          //         color: const Color(0xFF9B95FF).withOpacity(0.4),
                          //         width: 1.5,
                          //       ),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: const Color(0xFF4A42B8).withOpacity(0.2),
                          //           blurRadius: 12,
                          //           offset: const Offset(0, 4),
                          //         ),
                          //       ],
                          //     ),
                          //     child: const CircularProgressIndicator(
                          //       strokeWidth: 2.5,
                          //       valueColor: AlwaysStoppedAnimation<Color>(
                          //         Color(0xFFE8E9FF),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}








// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../providers/auth_provider.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   static const Color primaryColor = Color(0xFF6C63FF);
  
//   late AnimationController _logoController;
//   late AnimationController _textController;
//   late AnimationController _backgroundController;
//   late AnimationController _particleController;
//   late AnimationController _waveController;
//   late AnimationController _fadeController;
  
//   late Animation<double> _logoScale;
//   late Animation<double> _logoOpacity;
//   late Animation<double> _textOpacity;
//   late Animation<double> _textSlide;
//   late Animation<double> _backgroundGradient;
//   late Animation<double> _particleAnimation;
//   late Animation<double> _waveAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Controllers with Jio Hotstar timing
//     _logoController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2000),
//     );

//     _textController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );

//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 3000),
//     );

//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 4000),
//     )..repeat();

//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 2500),
//     )..repeat(reverse: true);

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _setupAnimations();
//     _startAnimations();

//     // Initialize app
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeApp();
//     });
//   }

//   void _setupAnimations() {
//     // Logo animations (Jio Hotstar style - zoom and fade)
//     _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
//       ),
//     );

//     _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _logoController,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
//       ),
//     );

//     // Background gradient animation
//     _backgroundGradient = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _backgroundController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Text animations
//     _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
//       ),
//     );

//     _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _textController,
//         curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
//       ),
//     );

//     // Particle animation
//     _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _particleController,
//         curve: Curves.linear,
//       ),
//     );

//     // Wave animation
//     _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _waveController,
//         curve: Curves.easeInOut,
//       ),
//     );

//     // Fade animation
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _fadeController,
//         curve: Curves.easeIn,
//       ),
//     );
//   }

//   void _startAnimations() async {
//     _fadeController.forward();
//     _backgroundController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 200));
//     _logoController.forward();
    
//     await Future.delayed(const Duration(milliseconds: 600));
//     _textController.forward();
//   }

//   Future<void> _initializeApp() async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider.initialize();

//       await _getFcmToken();

//       await Future.delayed(const Duration(seconds: 3));

//       if (!mounted) return;

//       if (authProvider.isAuthenticated) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       debugPrint('Initialization error: $e');
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     }
//   }

//   Future<void> _getFcmToken() async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       debugPrint("FCM Token: $token");

//       if (token != null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcmToken', token);
//       }
//     } catch (e) {
//       debugPrint("Error getting FCM token: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _logoController.dispose();
//     _textController.dispose();
//     _backgroundController.dispose();
//     _particleController.dispose();
//     _waveController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A), // Deep black like Jio Hotstar
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _logoController,
//           _textController,
//           _backgroundController,
//           _particleController,
//           _waveController,
//           _fadeController,
//         ]),
//         builder: (context, child) {
//           return FadeTransition(
//             opacity: _fadeAnimation,
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   center: Alignment.center,
//                   radius: 1.5,
//                   colors: [
//                     primaryColor.withOpacity(0.15 * _backgroundGradient.value),
//                     const Color(0xFF1A1A2E).withOpacity(0.8),
//                     const Color(0xFF0A0A0A),
//                   ],
//                   stops: const [0.0, 0.6, 1.0],
//                 ),
//               ),
//               child: Stack(
//                 children: [
//                   // Animated background particles
//                   ...List.generate(6, (index) {
//                     return Positioned(
//                       left: (size.width * (0.1 + index * 0.15)) + 
//                             (50 * _particleAnimation.value * (index % 2 == 0 ? 1 : -1)),
//                       top: (size.height * (0.2 + index * 0.12)) + 
//                            (30 * _waveAnimation.value),
//                       child: Opacity(
//                         opacity: 0.1 + (0.1 * _backgroundGradient.value),
//                         child: Container(
//                           width: 4 + (index * 2),
//                           height: 4 + (index * 2),
//                           decoration: BoxDecoration(
//                             color: primaryColor.withOpacity(0.6),
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: primaryColor.withOpacity(0.3),
//                                 blurRadius: 10,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }),

//                   // Main content
//                   Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Logo section with Jio Hotstar style
//                         Transform.scale(
//                           scale: _logoScale.value,
//                           child: FadeTransition(
//                             opacity: _logoOpacity,
//                             child: Container(
//                               width: 120,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     primaryColor,
//                                     primaryColor.withOpacity(0.8),
//                                     const Color(0xFF5A52D5),
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: primaryColor.withOpacity(0.4),
//                                     blurRadius: 30,
//                                     spreadRadius: 5,
//                                   ),
//                                   BoxShadow(
//                                     color: primaryColor.withOpacity(0.2),
//                                     blurRadius: 60,
//                                     spreadRadius: 10,
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.play_arrow_rounded,
//                                 color: Colors.white,
//                                 size: 50,
//                               ),
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 40),

//                         // App name with Jio Hotstar typography
//                         Transform.translate(
//                           offset: Offset(0, _textSlide.value),
//                           child: FadeTransition(
//                             opacity: _textOpacity,
//                             child: Column(
//                               children: [
//                                 // Main title
//                                 ShaderMask(
//                                   shaderCallback: (bounds) => LinearGradient(
//                                     colors: [
//                                       Colors.white,
//                                       Colors.white.withOpacity(0.9),
//                                     ],
//                                   ).createShader(bounds),
//                                   child: const Text(
//                                     'MOMENTS',
//                                     style: TextStyle(
//                                       fontSize: 42,
//                                       fontWeight: FontWeight.w900,
//                                       color: Colors.white,
//                                       letterSpacing: 4,
//                                       height: 1.1,
//                                     ),
//                                   ),
//                                 ),
                                
//                                 const SizedBox(height: 8),
                                
//                                 // Subtitle
//                                 Text(
//                                   'Create & Share Your Special Events',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w400,
//                                     color: Colors.white.withOpacity(0.7),
//                                     letterSpacing: 1.2,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         const SizedBox(height: 80),

//                         // Loading indicator with Jio Hotstar style
//                         FadeTransition(
//                           opacity: _textOpacity,
//                           child: Column(
//                             children: [
//                               // Custom loading animation
//                               SizedBox(
//                                 width: 40,
//                                 height: 40,
//                                 child: Stack(
//                                   children: [
//                                     // Outer ring
//                                     SizedBox(
//                                       width: 40,
//                                       height: 40,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor: AlwaysStoppedAnimation<Color>(
//                                           primaryColor.withOpacity(0.3),
//                                         ),
//                                         value: 1.0,
//                                       ),
//                                     ),
//                                     // Animated ring
//                                     const SizedBox(
//                                       width: 40,
//                                       height: 40,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor: AlwaysStoppedAnimation<Color>(
//                                           primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
                              
//                               const SizedBox(height: 16),
                              
//                               // Loading text
//                               Text(
//                                 'Loading...',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white.withOpacity(0.6),
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Bottom gradient overlay
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 100,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             const Color(0xFF0A0A0A).withOpacity(0.8),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Top subtle accent
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       height: 2,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             primaryColor.withOpacity(0.5 * _backgroundGradient.value),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }