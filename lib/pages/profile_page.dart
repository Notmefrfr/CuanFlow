import 'package:flutter/material.dart';
import 'profile/edit_profile.dart';
import 'profile/security_page.dart';
import 'profile/settings_page.dart';
import 'profile/help_page.dart';
import 'profile/logout_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user.jpg'), // Replace with your image asset
              radius: 16,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/user.jpg'), // Replace with your image asset
            ),
            const SizedBox(height: 10),
            const Text(
              'John Smith',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'ID: 25030024',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Menu Items
            _menuItem(context, 'Edit Profile', Icons.person, EditProfilePage()),
            _menuItem(context, 'Security', Icons.shield, SecurityPage()),
            _menuItem(context, 'Setting', Icons.settings, SettingsPage()),
            _menuItem(context, 'Help', Icons.help, HelpPage()),
            _menuItem(context, 'Logout', Icons.logout, LogoutPage()),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: const Color(0xFF373737),
        leading: Icon(icon, color: Color(0xFFFF7A00)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}

