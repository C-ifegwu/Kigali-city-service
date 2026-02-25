import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  static const _prefKey = 'notifications_enabled';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_prefKey) ?? false;
    });
  }

  Future<void> _toggleNotifications(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, val);
    setState(() => _notificationsEnabled = val);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final profile = auth.userProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kNavyCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (profile?.displayName ?? auth.firebaseUser?.email ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: kGold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile?.displayName ?? auth.firebaseUser?.displayName ?? 'User',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  profile?.email ?? auth.firebaseUser?.email ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        auth.firebaseUser?.emailVerified == true
                            ? Icons.verified
                            : Icons.warning_amber_outlined,
                        size: 14,
                        color: auth.firebaseUser?.emailVerified == true
                            ? kGold
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        auth.firebaseUser?.emailVerified == true
                            ? 'Verified'
                            : 'Email not verified',
                        style: TextStyle(
                          fontSize: 12,
                          color: auth.firebaseUser?.emailVerified == true
                              ? kGold
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Preferences Section
          Text('Preferences',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: kNavyCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.notifications_outlined, color: kGold),
              title: const Text('Location-Based Notifications'),
              subtitle: Text(
                _notificationsEnabled
                    ? 'You will receive nearby service alerts'
                    : 'Enable to get alerts near you',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: _toggleNotifications,
                activeThumbColor: kGold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // About Section
          Text('About', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: kNavyCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: kWhite70),
                  title: const Text('App Version'),
                  trailing: Text('1.0.0',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                const Divider(color: kNavyMid, height: 1, indent: 16),
                ListTile(
                  leading: const Icon(Icons.location_city, color: kWhite70),
                  title: const Text('Kigali City Services'),
                  subtitle: Text(
                    'Helping residents find essential services',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sign Out
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                foregroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: kNavyCard,
                    title: const Text('Sign Out'),
                    content:
                        const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel',
                            style: TextStyle(color: kWhite70)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  context.read<AppAuthProvider>().signOut();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}
