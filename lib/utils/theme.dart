// import 'package:flutter/material.dart';

// class AppTheme {
//     static const Color primaryColor = Color(0xFF6C63FF);
//   static const Color secondaryColor = Color(0xFF03DAC6);
//   static const Color backgroundColor = Color(0xFFF8F9FA);
//   static const Color surfaceColor = Colors.white;
//   static const Color errorColor = Color(0xFFE53935);
//   static const Color textDark = Color(0xFF2D3748);
//   static const Color textLight = Color(0xFFA0AEC0);

//   static ThemeData lightTheme = ThemeData(
//     primarySwatch: Colors.deepPurple,
//     primaryColor: primaryColor,
//     scaffoldBackgroundColor: backgroundColor,
//     fontFamily: 'Poppins',
//     appBarTheme: const AppBarTheme(
//       backgroundColor: primaryColor,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryColor,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         textStyle: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//     ),
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
//       headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
//       bodyMedium: TextStyle(fontSize: 16, color: textDark),
//       bodySmall: TextStyle(fontSize: 14, color: textLight),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: textLight),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: primaryColor),
//       ),
//       filled: true,
//       fillColor: surfaceColor,
//     ),
//     cardTheme: CardThemeData(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: surfaceColor,
//     ),
//   );
// }










import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935);
  static const Color textDark = Color(0xFF2D3748);
  static const Color textLight = Color(0xFFA0AEC0);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkCardColor = Color(0xFF2D2D2D);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Poppins',
    
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
      onBackground: textDark,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 2,
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
      bodyLarge: TextStyle(fontSize: 16, color: textDark),
      bodyMedium: TextStyle(fontSize: 14, color: textDark),
      bodySmall: TextStyle(fontSize: 12, color: textLight),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: textLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: surfaceColor,
      shadowColor: Colors.black.withOpacity(0.1),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    fontFamily: 'Poppins',
    
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: darkTextPrimary,
      onBackground: darkTextPrimary,
      onError: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkTextPrimary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        elevation: 4,
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextPrimary),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextPrimary),
      bodyLarge: TextStyle(fontSize: 16, color: darkTextPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: darkTextPrimary),
      bodySmall: TextStyle(fontSize: 12, color: darkTextSecondary),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkTextSecondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: darkCardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: darkCardColor,
      shadowColor: Colors.black.withOpacity(0.3),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    listTileTheme: const ListTileThemeData(
      tileColor: darkCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );

  // Helper methods for dynamic colors based on theme
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCardColor
        : surfaceColor;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : textDark;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : textLight;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundColor
        : backgroundColor;
  }
}