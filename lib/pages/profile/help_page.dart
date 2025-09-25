import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text('FAQs', style: TextStyle(color: Colors.white)),
            subtitle: Text('Find answers to common questions', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            title: Text('Contact Us', style: TextStyle(color: Colors.white)),
            subtitle: Text('Get in touch with support', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            title: Text('Feedback', style: TextStyle(color: Colors.white)),
            subtitle: Text('Help us improve the app', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

