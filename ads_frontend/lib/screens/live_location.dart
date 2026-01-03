import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  GoogleMapController? _mapController;
  final LatLng _location = const LatLng(28.4435, 77.0557);
  double _currentZoom = 15;

  void _zoomIn() {
    setState(() => _currentZoom += 1);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_location, _currentZoom));
  }

  void _zoomOut() {
    setState(() => _currentZoom -= 1);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_location, _currentZoom));
  }

  void _sendSOS() async {
    String? userId = await SharedPrefs.getUserId();
    String? name = await SharedPrefs.getUserName();

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/sos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "location": "Live map pin",
        "userId": userId,
        "name": name,
        "vehicle": "MH14-AB-1234",
        "severity": "High",
        "description": "SOS Triggered via App",
        "latitude": "28.4435",
        "longitude": "77.0557",
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ SOS sent to your emergency contacts")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Emergency contacts not found or email failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Live Location"),
        backgroundColor: const Color(0xFFFF3131),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _location, zoom: _currentZoom),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _zoomIn,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: _zoomOut,
                  child: const Icon(Icons.remove, color: Colors.black),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              onPressed: _sendSOS,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF3131),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("🚨 Trigger SOS", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
