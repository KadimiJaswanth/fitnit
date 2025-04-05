import 'package:flutter/material.dart';
import 'screens/first_screen.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Define primary color for the app
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      home: FirstScreen(),
    );
  }
}