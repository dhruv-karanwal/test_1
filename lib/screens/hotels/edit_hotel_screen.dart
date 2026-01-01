import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_list_screen.dart';
import '../widgets/custom_bottom_nav.dart';

import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';

class EditHotelScreen extends StatefulWidget {
  const EditHotelScreen({super.key});

  @override
  State<EditHotelScreen> createState() => _EditHotelScreenState();
}

class _EditHotelScreenState extends State<EditHotelScreen> {
  // Removed counters

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
          "Edit Hotel",
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
              child: Image.asset("assets/images/logo.png", fit: BoxFit.contain), 
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
                image: AssetImage('assets/images/background.png'),
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
                  color: const Color(0xFF786452), // Brownish container
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
                        borderRadius: BorderRadius.circular(0),
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
              
                    const SizedBox(height: 24), 

                    _inputField("DRIVER NUMBER"),
                    _inputField("OWNER NUMBER"),
              
                    const SizedBox(height: 40), 
              
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
        height: 50, 
        child: TextField(
          style: GoogleFonts.langar(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: label, 
            hintStyle: GoogleFonts.langar(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            filled: true,
            fillColor: const Color(0xFFD9D9D9), 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), 
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
