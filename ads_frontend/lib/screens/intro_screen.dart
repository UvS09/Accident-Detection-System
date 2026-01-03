import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == 2;
              });
            },
            children: const [
              IntroPage(
                title: "Welcome",
                subtitle: "Accident Detection Made Easy",
                color: Colors.redAccent,
              ),
              IntroPage(
                title: "Emergency Alerts",
                subtitle: "SOS & Contacts at your fingertips",
                color: Colors.deepOrange,
              ),
              IntroPage(
                title: "Get Started",
                subtitle: "Let's begin the journey",
                color: Colors.red,
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _controller.hasClients && _controller.page?.round() == index
                        ? Colors.white
                        : Colors.white70,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: TextButton(
              onPressed: () {
                if (onLastPage) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(
                onLastPage ? "Get Started" : "Next",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const IntroPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}