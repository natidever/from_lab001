import 'package:flutter/material.dart';
import 'package:flutter_engineering_test_from_lab/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Task(),
      debugShowCheckedModeBanner: false,
    );
  }
}
