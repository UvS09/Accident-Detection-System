import 'package:flutter/material.dart';
import 'package:ads_app/utils/shared_preferences.dart';
import 'package:ads_app/screens/accident_history.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '', userEmail = '';

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    userName = await SharedPrefs.getUserName() ?? '';
    userEmail = await SharedPrefs.getUserEmail() ?? '';
    setState(() {});
  }

  void logout() async {
    await SharedPrefs.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFFF3131),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black12,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            const SizedBox(height: 15),
            Text(userName, style: const TextStyle(fontSize: 20)),
            Text(userEmail, style: const TextStyle(color: Colors.grey)),
            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Accidents Reported'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccidentHistoryPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Help & Support'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
