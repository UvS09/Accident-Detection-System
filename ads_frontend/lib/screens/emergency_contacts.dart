import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_preferences.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();
  List<Map<String, dynamic>> savedContacts = [];

  Future<void> loadContacts() async {
    final userId = await SharedPrefs.getUserId();
    final res = await http.get(Uri.parse('http://localhost:8080/api/contacts/$userId'));

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      setState(() {
        savedContacts = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  Future<void> addContact() async {
    final userId = await SharedPrefs.getUserId();
    final res = await http.post(
      Uri.parse('http://localhost:8080/api/contacts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": nameCtl.text,
        "phone": phoneCtl.text,
        "email": emailCtl.text,
        "userId": userId,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      nameCtl.clear();
      phoneCtl.clear();
      emailCtl.clear();
      loadContacts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to save contact")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
        backgroundColor: const Color(0xFFFF3131),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtl,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: emailCtl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addContact,
              child: const Text("Save Contact"),
            ),
            const SizedBox(height: 20),
            const Text("Saved Contacts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: savedContacts.length,
                itemBuilder: (context, index) {
                  final contact = savedContacts[index];
                  return ListTile(
                    leading: const Icon(Icons.contact_mail),
                    title: Text(contact['name'] ?? ''),
                    subtitle: Text('${contact['email']} | ${contact['phone']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
