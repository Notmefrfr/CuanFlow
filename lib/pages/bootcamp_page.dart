import 'package:flutter/material.dart';

class BootcampPage extends StatelessWidget {
  const BootcampPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bootcamp')),
      body: Center(
        child: Text(
          'Welcome to CuanFlow Bootcamp!\nThis page is under construction.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
