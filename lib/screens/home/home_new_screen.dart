// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:moments/widgets/navigation_bar.dart';

class HomeNewPage extends StatelessWidget {
  const HomeNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyNavigationBar(), // Using MyNavigationBar as the main page
    );
  }
}
