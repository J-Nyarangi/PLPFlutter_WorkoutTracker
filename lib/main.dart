import 'package:flutter/material.dart';
import 'splash_screen.dart';  
import 'home_page.dart'; 
import 'log_workout_page.dart';  
import 'progress_page.dart';  
import 'goals_page.dart';  

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),  // Splash screen as the first screen
    );
  }
}
