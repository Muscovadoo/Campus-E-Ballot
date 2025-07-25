import 'package:flutter/material.dart';
import 'package:campus_ballot_voting_system/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotification = false;
  bool _darkMode = false;
  double _fontSize = 2;

  void _showFeaturePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text(
          'This feature is currently not available. Next update will be...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Image.asset('assets/images/BatstateU-NEU-Logo.png', height: 32),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/SSC-JPLPCMalvar-Logo.png',
                  height: 32,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionTitle('Notification'),
            _settingCard(
              child: ListTile(
                title: const Text(
                  'Push notification',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Turn on notification'),
                trailing: Switch(
                  value: _pushNotification,
                  onChanged: (val) => setState(() => _pushNotification = val),
                ),
              ),
            ),
            _sectionTitle('Appearance'),
            _settingCard(
              child: ListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Turn the theme into dark'),
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
              ),
            ),
            _settingCard(
              child: ListTile(
                title: const Text(
                  'Font Size',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Resize font small to big'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: _fontSize,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      onChanged: (val) => setState(() => _fontSize = val),
                    ),
                  ],
                ),
              ),
            ),
            _sectionTitle('Regional'),
            _settingCard(
              child: ListTile(
                title: const Text(
                  'Language',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Change language'),
                trailing: DropdownButton<String>(
                  value: 'English',
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                  ],
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showFeaturePopup(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Apply Changes'),
            ),
            _sectionTitle('Password'),
            _settingCard(
              child: ListTile(
                title: const Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Change password'),
                trailing: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/reset-password'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Change Password'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  Widget _settingCard({required Widget child}) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: child,
    );
  }
}
