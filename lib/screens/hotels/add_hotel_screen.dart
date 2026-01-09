import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';
import 'hotel_list_screen.dart';
import '../widgets/custom_bottom_nav.dart';

import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/fade_route.dart';

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
      appBar: buildCommonAppBar(context),
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 1),

      body: Stack(
        children: [
          // 1. BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.appGreen.withOpacity(0.6), // Overlay
            ),
          ),

          // 2. CONTENT
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 358,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBrown, 
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
                        color: const Color(0xFFD9A648), // Gold/Mustard
                        borderRadius: BorderRadius.circular(20), // Standardized radius
                        border: Border.all(color: Colors.white, width: 1), // White border
                      ),
                      child: Center(
                        child: Text(
                          "DETAILS",
                          style: GoogleFonts.langar(
                            color: Colors.black, // Changed to Black
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
                          FadeRoute(
                            page: HotelListScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9A648), // Gold/Mustard
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
                            color: Colors.black,
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
            fillColor: AppColors.inputBg,
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
