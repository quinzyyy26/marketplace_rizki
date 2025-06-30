import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketplace_rizki/providers/cart_provider.dart';
import 'package:marketplace_rizki/screens/auth/login_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'marketplace_rizki',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(), 
    );
  }
}