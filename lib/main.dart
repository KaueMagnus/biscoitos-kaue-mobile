import 'package:flutter/material.dart';

void main() {
  runApp(const BiscoitosKaueApp());
}

class BiscoitosKaueApp extends StatelessWidget {
  const BiscoitosKaueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biscoitos Kauê',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Biscoitos Kauê Mobile'),
        ),
      ),
    );
  }
}