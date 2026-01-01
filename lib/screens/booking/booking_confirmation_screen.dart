import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color headerBrown = Color(0xFFC1A87D); 
  static const Color cardGreen = Color(0xFF8DA331); // Lighter green for summary card
  static const Color buttonBrown = Color(0xFF5E4B35); 
  static const Color backgroundGreen = Color(0xFF555E40); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: backgroundGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
             const Text(
              "BANDHAVGARH SAFARI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
             const SizedBox(width: 8),
            Image.asset('assets/logo.png', height: 30),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
           // Background Overlay (optional if using image)
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: appGreen.withOpacity(0.85)),
            ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Confirmation Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37), // Gold/Yellow
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        "CONFIRMATION",
                         style: GoogleFonts.langar(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tiger Logo/Graphic
                  Image.asset('assets/landing_logo.png', height: 100), // Reusing logo as placeholder

                  const SizedBox(height: 30),

                  // "BOOKING CONFIRMED !!!" Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: buttonBrown,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      children: [
                         Text(
                          "BOOKING",
                          style: GoogleFonts.langar(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "CONFIRMED !!!",
                          style: GoogleFonts.langar(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardGreen,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                        Center(
                          child: Text(
                            "SUMMARY",
                            style: GoogleFonts.langar(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow("Driver name", ": Vivek"),
                        _buildSummaryRow("Roster No.", ": 1"),
                        _buildSummaryRow("Name of passenger", ": Rahul"),
                        _buildSummaryRow("No. of person", ": 5"),
                        _buildSummaryRow("Slot", ": Evening"),
                        _buildSummaryRow("Date", ": 13/12/25"),
                      ],
                    ),
                  ),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
       bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: appGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('assets/nav_menu.png'),
            _buildNavItem('assets/nav_home_new.png', isHome: true, context: context), 
            _buildNavItem('assets/transaction.png'), 
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.langar(
              color: const Color(0xFF3E2723), // Dark Brown
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.langar(
                color: const Color(0xFF3E2723),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildNavItem(String assetPath, {bool isHome = false, BuildContext? context}) {
     return GestureDetector(
       onTap: () {
         if (isHome && context != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
         }
       },
       child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isHome ? Colors.white : const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
            border: isHome ? Border.all(color: const Color(0xFFD4AF37), width: 3) : null,
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
     );
  }
}
