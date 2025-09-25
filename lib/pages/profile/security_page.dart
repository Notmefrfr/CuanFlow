import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        title: const Text('Security Settings', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSwitchTile('Enable 2FA'),
            _buildSwitchTile('Use fingerprint'),
            _buildSwitchTile('App Lock')
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title) {
    return SwitchListTile(
      value: true,
      onChanged: (val) {},
      activeColor: const Color(0xFFFF7A00),
      title: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
