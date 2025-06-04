import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/homepage.dart';
import 'package:expensetracker/loginpage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashLogoScreen();
        } else if (snapshot.hasData) {
          return HomePage(); // user is logged in
        } else {
          return LogIn(); // user is not logged in
        }
      },
    );
  }
}

class SplashLogoScreen extends StatelessWidget {
  const SplashLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF321B15),
      body: Center(
        child: Image.asset(
          'assets/1.png',
          width: 150,
        ),
      ),
    );
  }
}
