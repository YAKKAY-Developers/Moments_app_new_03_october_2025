import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            title: 'Account',
            children: [
              _buildSettingsTile(
                icon: Icons.person,
                title: 'Edit Profile',
                subtitle: 'Update your profile information',
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),
              _buildSettingsTile(
                icon: Icons.security,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () {
                  // TODO: Navigate to change password
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Notifications',
            children: [
              _buildSettingsTile(
                icon: Icons.notifications,
                title: 'Push Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _buildSettingsTile(
                icon: Icons.email,
                title: 'Email Notifications',
                subtitle: 'Configure email alerts',
                onTap: () {
                  // TODO: Navigate to email settings
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Privacy',
            children: [
              _buildSettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
              _buildSettingsTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: () {
                  // TODO: Show terms of service
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            title: 'Support',
            children: [
              _buildSettingsTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help with the app',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              _buildSettingsTile(
                icon: Icons.feedback,
                title: 'Send Feedback',
                subtitle: 'Share your thoughts with us',
                onTap: () {
                  // TODO: Open feedback form
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return ElevatedButton(
                onPressed: () {
                  _showSignOutDialog(context, authProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign Out'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}