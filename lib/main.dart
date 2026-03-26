import 'dashboard.dart';
import 'screens/farming_guide_page.dart';
import 'screens/chat_page.dart';
import 'screens/register_page.dart';
import 'screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <-- added
import 'firebase_options.dart'; // <-- added

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- required for async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <-- from firebase_options.dart
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAINET',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green.shade800,
            minimumSize: const Size(150, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white),
            minimumSize: const Size(150, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/farming-guide': (context) => const FarmingGuidePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'CHAINET',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Smarter Tea Farming',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Access real-time weather forecasts, market prices, and other farm insights to protect your harvest.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bullet points
                    _buildBulletPoint(
                      title: 'Farm Overview',
                      description: 'All your tea farm insights in one place',
                    ),
                    const SizedBox(height: 20),

                    // AI Chatbot Assistant – tappable
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChatPage()),
                        );
                      },
                      child: _buildBulletPoint(
                        title: 'AI Chatbot Assistant',
                        description: 'Ask questions and get instant tea farming advice',
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildBulletPoint(
                      title: 'Smart Weather',
                      description: 'Accurate local forecasts',
                    ),
                    const SizedBox(height: 20),
                    _buildBulletPoint(
                      title: 'Market Prices',
                      description: 'Live tea market rates',
                    ),
                    const SizedBox(height: 40),

                    // Buttons – now pointing to real authentication pages
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text('Register Account'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint({required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 12),
          child: Text(
            '•',
            style: TextStyle(
              fontSize: 24,
              color: Colors.green.shade300,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}