import 'package:flutter/material.dart';

class Tab2MainPage extends StatefulWidget {
  const Tab2MainPage({super.key});

  @override
  State<Tab2MainPage> createState() => _Tab2MainPageState();
}

class _Tab2MainPageState extends State<Tab2MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab2 Title'),
      ),
      body: const SafeArea(
        child: Center(child: Text('Tab2 Page')),
      ),
    );
  }
}
