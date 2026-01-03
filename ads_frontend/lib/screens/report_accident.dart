import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/shared_preferences.dart';
import 'accident_history.dart';

class ReportAccidentPage extends StatefulWidget {
  const ReportAccidentPage({super.key});

  @override
  State<ReportAccidentPage> createState() => _ReportAccidentPageState();
}

class _ReportAccidentPageState extends State<ReportAccidentPage> {
  final _formKey = GlobalKey<FormState>();
  String location = '', vehicle = '', severity = '', description = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userId = await SharedPrefs.getUserId();

      final res = await http.post(
        Uri.parse('http://localhost:8080/api/accidents'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "location": location,
          "vehicle": vehicle,
          "severity": severity,
          "description": description,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccidentHistoryPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to report accident")),
        );
      }
    }
  }

  Widget _buildField(String label, Function(String) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        onSaved: (val) => onSaved(val!),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Report Accident"),
        backgroundColor: const Color(0xFFFF3131),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField('Location', (val) => location = val),
              _buildField('Vehicle', (val) => vehicle = val),
              _buildField('Severity', (val) => severity = val),
              _buildField('Description', (val) => description = val, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit Report'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
