import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/fade_route.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors
  static const Color appGreen = AppColors.appGreen;
  static const Color headerBrown = AppColors.activeNavGold; // Changed to match theme
  static const Color cardGreen = AppColors.cardBrown; // Changed to match other card backgrounds
  static const Color buttonBrown = AppColors.cardBrown; 
  static const Color backgroundGreen = AppColors.appGreen; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              FadeRoute(page: HomeScreen()),
              (route) => false,
            );
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: Text(
          "BANDHAVGARH SAFARI",
          style: GoogleFonts.langar(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/images/logo.png'), 
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
           // Background Overlay
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/landing_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: appGreen.withOpacity(0.6)), // Standardized Opacity
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
                      color: AppColors.activeNavGold, // Gold/Yellow
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
                  Image.asset('assets/images/landing_logo.png', height: 100), 

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
        height: 100, // Standardized Height
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
            _buildNavItem('assets/images/nav_menu.png', size: 60),
            
            // Home (Center)
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute(page: HomeScreen()),
                  (route) => false,
                );
              },
              child: Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.activeNavGold, // activeNavInner
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/nav_home_new.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            _buildNavItem('assets/images/transaction.png', size: 60), 
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
              color: Colors.white, // Changed to white for better visibility on brown card
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.langar(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildNavItem(String assetPath, {double size = 50}) {
     return GestureDetector(
       onTap: () {
         // Placeholder for menu/trans
       },
       child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.searchBarBg,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
     );
  }
}
