import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _messages = true;
  bool _groups = true;
  bool _calls = true;
  bool _vibrate = true;
  bool _sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          _buildSectionHeader('Messages'),
          _buildSwitchTile(
            'Show Notifications',
            'Get notified for new messages',
            _messages,
            (val) => setState(() => _messages = val),
          ),

          _buildSectionHeader('Groups'),
          _buildSwitchTile(
            'Show Notifications',
            'Get notified for new group messages',
            _groups,
            (val) => setState(() => _groups = val),
          ),
          _buildSectionHeader('Calls'),
          _buildSwitchTile(
            'Show Notifications',
            'Get notified for incoming calls',
            _calls,
            (val) => setState(() => _calls = val),
          ),

          _buildSectionHeader('Other'),
          _buildSwitchTile(
            'Sound',
            'Play sound for incoming messages',
            _sound,
            (val) => setState(() => _sound = val),
          ),
          _buildSwitchTile(
            'Vibrate',
            'Vibrate for incoming messages',
            _vibrate,
            (val) => setState(() => _vibrate = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF6C63FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      ),
    );
  }
}
