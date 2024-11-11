import 'package:flutter/material.dart';

class Tab1MainPage extends StatefulWidget {
  const Tab1MainPage({super.key});

  @override
  State<Tab1MainPage> createState() => _Tab1MainPageState();
}

class _Tab1MainPageState extends State<Tab1MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab1 Title'),
      ),
      body: const SafeArea(
        child: Center(child: Text('Tab1 Page')),
      ),
    );
  }
}
