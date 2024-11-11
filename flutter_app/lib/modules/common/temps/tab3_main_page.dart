import 'package:flutter/material.dart';

class Tab3MainPage extends StatefulWidget {
  const Tab3MainPage({super.key});

  @override
  State<Tab3MainPage> createState() => _Tab3MainPageState();
}

class _Tab3MainPageState extends State<Tab3MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab3 Title'),
      ),
      body: const SafeArea(
        child: Center(child: Text('Tab3 Page')),
      ),
    );
  }
}
