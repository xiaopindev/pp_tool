import 'package:flutter/material.dart';

class Tab4MainPage extends StatefulWidget {
  const Tab4MainPage({super.key});

  @override
  State<Tab4MainPage> createState() => _Tab4MainPageState();
}

class _Tab4MainPageState extends State<Tab4MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab4 Title'),
      ),
      body: const SafeArea(
        child: Center(child: Text('Tab4 Page')),
      ),
    );
  }
}
