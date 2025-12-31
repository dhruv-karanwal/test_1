import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_list_screen.dart';
import '../widgets/custom_bottom_nav.dart';

import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({super.key});

  @override
  State<AddHotelScreen> createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF555E40),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Hotel",
          style: GoogleFonts.langar(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Image.asset("assets/logo.png", fit: BoxFit.contain), // Fixed logo path
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),

      body: Stack(
        children: [
          // 1. BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color(0xFF555E40).withOpacity(0.6), // Overlay
            ),
          ),

          // 2. CONTENT
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 358,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF786452), // Brownish container color from screenshot 2
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 TOP HEADER
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3E4F39), // Dark Green
                        borderRadius: BorderRadius.circular(0), // Rectangularish inside? keeping rounded for now 
                        // Screenshot shows rounded corners for the header inside the card? No, maybe full width?
                        // Let's stick to previous pill shape but dark green.
                        // Actually screenshot 2 shows it inside the brown card.
                      ),
                      child: Center(
                        child: Text(
                          "DETAILS",
                          style: GoogleFonts.langar(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 16),
              
                    _inputField("RESORT ID"),
                    _inputField("RESORT NAME"),
                    _inputField("RESORT CHARGES"),
                    _inputField("OWNER NAME"),
              
                    const SizedBox(height: 24), // Increased gap after inputs
              
                    _inputField("DRIVER NUMBER"),
                    _inputField("OWNER NUMBER"),
              
                    const SizedBox(height: 40), // Gap before save button
              
                    // 🔹 SAVE BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelListScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8BBF4D), // Light Green
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.2),
                               blurRadius: 4,
                               offset: const Offset(0, 2),
                             )
                          ]
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.langar(
                            color: const Color(0xFF3E4F39), // Dark Green Text
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        height: 50, // Fixed height for uniformity
        child: TextField(
          style: GoogleFonts.langar(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: label, // Using hint so it's visible inside box
            hintStyle: GoogleFonts.langar(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            filled: true,
            fillColor: const Color(0xFFD9D9D9), // Light greyish white
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), // Slightly rounded corners
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
