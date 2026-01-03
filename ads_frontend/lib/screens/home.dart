import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userName = "Swaraj";
  final String vehicleName = "MH14 AB 1234";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF3131),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi, $userName",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Vehicle: $vehicleName",
                style: const TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 24),

            // Weather Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.wb_sunny, size: 36, color: Colors.orange),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("26°C - Sunny",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Humidity: 55%", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Vehicle Stats (Live)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9F5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Live Vehicle Stats",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithText(icon: Icons.car_crash, label: "ABS: Active"),
                      IconWithText(icon: Icons.flash_on, label: "Lights: Auto"),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithText(icon: Icons.ac_unit, label: "AC: ON"),
                      IconWithText(icon: Icons.sync, label: "Mode: Eco"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2x2 Radial Meters
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              childAspectRatio: 1,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                RadialMeter(label: "Speed", value: 60, unit: "km/h", icon: Icons.speed),
                RadialMeter(label: "Fuel", value: 70, unit: "%", icon: Icons.local_gas_station),
                RadialMeter(label: "Distance", value: 120, unit: "km", icon: Icons.route),
                RadialMeter(label: "Range", value: 45, unit: "km", icon: Icons.battery_charging_full),
              ],
            ),

            const SizedBox(height: 18),

            // Vehicle Dynamics
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Vehicle Dynamics",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithText(icon: Icons.thermostat, label: "Engine: 90°C"),
                      IconWithText(icon: Icons.speed, label: "Tyre: 32 PSI"),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithText(icon: Icons.car_repair, label: "Brakes: OK"),
                      IconWithText(icon: Icons.battery_full, label: "Battery: Good"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadialMeter extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final IconData icon;

  const RadialMeter({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(value / 100),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: Colors.black54),
            const SizedBox(height: 8),
            Text("$value $unit",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double percentage;

  _RadialPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2 - 8;
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final fgPaint = Paint()
      ..color = const Color(0xFFFF3131)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percentage,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconWithText({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
