import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_confirmation_screen.dart';
import '../home/home_screen.dart';

class PermitIdScreen extends StatefulWidget {
  const PermitIdScreen({super.key});

  @override
  State<PermitIdScreen> createState() => _PermitIdScreenState();
}

class _PermitIdScreenState extends State<PermitIdScreen> {
  final TextEditingController _permitController = TextEditingController();
  
  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color headerOrange = Color(0xFFFF8C00); // Orange for toggle/header
  static const Color cardGreen = Color(0xFF8DA331);
  static const Color buttonBrown = Color(0xFF5E4B35);
  
  @override
  void dispose() {
    _permitController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_permitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Permit ID")),
      );
      return;
    }
    // Navigate to Confirmation
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookingConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appGreen,
      appBar: AppBar(
        backgroundColor: appGreen,
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
                  
                  // Toggle Header (Visual Only here since we are in Permit Mode)
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "NORMAL ENTRY",
                              style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                             decoration: BoxDecoration(
                              color: headerOrange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "DRIVER BY CHOICE",
                                style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                   const SizedBox(height: 30),
                  Image.asset('assets/landing_logo.png', height: 80),

                  const SizedBox(height: 30),

                  // Enter Permit ID Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: buttonBrown, // Brown card
                      borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ENTER PERMIT ID",
                          style: GoogleFonts.langar(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 45,
                          color: Colors.white,
                          child: TextField(
                            controller: _permitController,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.langar(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 2), // Remove default pad
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  // Summary Placeholder
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
                        // Placeholder data as per design image
                        _buildSummaryRow("Driver name", ": Vivek"),
                        _buildSummaryRow("Roster No.", ": 1"),
                        _buildSummaryRow("Name of passenger", ": Rahul"),
                         _buildSummaryRow("No. of person", ": 5"),
                        _buildSummaryRow("Slot", ": Evening"),
                         _buildSummaryRow("Date", ": 13/12/25"),
                      ],
                    ),
                  ),

                   const SizedBox(height: 30),

                   // Confirm Button
                   SizedBox(
                     width: 180,
                     child: ElevatedButton(
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBrown,
                          foregroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                           ),
                        ),
                        child: Text("CONFIRM", style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 18)),
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
              color: const Color(0xFF3E2723), 
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
              MaterialPageRoute(builder: (context) => HomeScreen()), // Import might cycle if not careful, but usually ok
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
