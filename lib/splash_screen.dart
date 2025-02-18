import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds before navigating to the next page
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 

    return Scaffold(
      backgroundColor: colorScheme.background, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.fitness_center, 
              size: 100.0,
              color: colorScheme.onBackground, 
            ),
            SizedBox(height: 20),
            Text(
              'Workout Tracker',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
