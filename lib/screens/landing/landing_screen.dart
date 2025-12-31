import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND IMAGE
          Image.asset(
            'assets/landing_bg.png',
            fit: BoxFit.cover,
          ),
          
          // 2. LOGO (Centered at top)
          Positioned(
            top: 100, // Adjust position as needed based on image safe area
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/landing_logo.png',
                width: 250, // Adjust size as needed
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 3. GET STARTED BUTTON (Bottom)
          Positioned(
            bottom: 120, // Adjust to sit nicely above bottom edge
            left: 24,
            right: 24,
            child: SizedBox(
               height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF996B30), // Gold/Brownish color from button image
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                   elevation: 5,
                ),
                child: Text(
                  "GET STARTED",
                  style: GoogleFonts.langar(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
