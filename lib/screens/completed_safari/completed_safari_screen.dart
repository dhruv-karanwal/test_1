import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/app_colors.dart';

class CompletedSafariScreen extends StatelessWidget {
  CompletedSafariScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors
  // Colors
  static const Color appGreen = AppColors.appGreen;
  static const Color cardBrown = AppColors.cardBrown;
  static const Color bannerGold = AppColors.highlightOrange; // Should match "Waiting List" banner
  static const Color activeNavInner = AppColors.activeNavGold;
  static const Color cardContentBg = AppColors.headerGreen; // Using header green for consistency

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: true,
      appBar: buildCommonAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: appGreen.withOpacity(0.6),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // COMPLETED SAFARIS Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: bannerGold,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "COMPLETED SAFARIS",
                          style: GoogleFonts.langar(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // LIST OF SAFARIS
                    _buildSafariCard(
                      date: "12/12/2025",
                      zone: "Tala",
                      slot: "Morning",
                      vehicle: "MP20ZA1234",
                    ),
                    const SizedBox(height: 16),
                    _buildSafariCard(
                      date: "10/11/2025",
                      zone: "Magdhi",
                      slot: "Evening",
                      vehicle: "MP20ZA5678",
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
       // BOTTOM NAV
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildSafariCard({required String date, required String zone, required String slot, required String vehicle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardContentBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date: $date",
                style: GoogleFonts.langar(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
               Text(
                "Zone: $zone",
                style: GoogleFonts.langar(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slot: $slot",
                style: GoogleFonts.langar(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
               Text(
                "Vehicle: $vehicle",
                style: GoogleFonts.langar(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: bannerGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "COMPLETED",
                style: GoogleFonts.langar(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }


}
