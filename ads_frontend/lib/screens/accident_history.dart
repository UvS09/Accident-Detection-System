import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/shared_preferences.dart';

class AccidentHistoryPage extends StatefulWidget {
  const AccidentHistoryPage({super.key});

  @override
  State<AccidentHistoryPage> createState() => _AccidentHistoryPageState();
}

class _AccidentHistoryPageState extends State<AccidentHistoryPage> {
  List<Map<String, dynamic>> accidentList = [];

  Future<void> fetchAccidents() async {
    final userId = await SharedPrefs.getUserId();
    final res = await http.get(Uri.parse('http://localhost:8080/api/accidents/$userId'));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      setState(() {
        accidentList = List<Map<String, dynamic>>.from(data);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load accident history")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAccidents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reported Accidents"),
        backgroundColor: const Color(0xFFFF3131),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: accidentList.isEmpty
          ? const Center(child: Text("No accidents reported yet."))
          : ListView.builder(
              itemCount: accidentList.length,
              itemBuilder: (context, index) {
                final acc = accidentList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(acc['location']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vehicle: ${acc['vehicle']}"),
                        Text("Severity: ${acc['severity']}"),
                        Text("Desc: ${acc['description']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
