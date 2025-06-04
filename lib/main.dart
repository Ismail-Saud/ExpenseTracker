import 'package:expensetracker/addinex.dart';
import 'package:expensetracker/authgate.dart';
import 'package:expensetracker/signuppage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expensetracker/loginpage.dart';
import 'package:expensetracker/homepage.dart';
import 'package:expensetracker/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      appId: firebaseConfig['appId']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      projectId: firebaseConfig['projectId']!,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthGate(), // or AuthGate if you use auth checking
        '/signup': (context) => SignUp(),
        '/login': (context) => LogIn(),
        '/homepage': (context) => HomePage(),
        '/addie': (context) => AddIncomeExpense(),
      },
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: Color(0xFFECE5D8), // Background color
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF321B15),
          foregroundColor: Color(0xFFECE5D8), // Text/icon color in AppBar
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF321B15)), // Main text color
          bodyMedium: TextStyle(color: Color(0xFF321B15)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF321B15), // Button background
            foregroundColor: Color(0xFFECE5D8), // Button text
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF321B15)), // Label color
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF321B15)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF321B15)),
          ),
        ),
      ),
    );
  }
}
