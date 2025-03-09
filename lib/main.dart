import 'package:flutter/material.dart';
import 'package:seven_solutions_mobile_assignment/fibonacci_screen.dart';

void main() {
  runApp(const FibonacciApp());
}

class FibonacciApp extends StatelessWidget {
  const FibonacciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FibonacciListScreen(),
    );
  }
}
