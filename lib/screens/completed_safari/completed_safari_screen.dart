import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/app_colors.dart';
import 'safari_details_screen.dart';
import '../../utils/fade_route.dart';

class CompletedSafariScreen extends StatelessWidget {
  CompletedSafariScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors
  static const Color appGreen = AppColors.appGreen;
  static const Color containerBrown = AppColors.cardBrown; // Mapping cardBrown to container for consistency
  static const Color bannerOlive = Color(0xFF8DA331); // Correct Olive Green
  static const Color listCardBg = Colors.white; 
  static const Color detailsButtonBg = Color(0xFF8DA331); // Button green 

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
          ),
          // Gradient Overlay
          Container(
            color: appGreen.withOpacity(0.6),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Main Container
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: containerBrown.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                      children: [
                          const SizedBox(height: 30),
                          // COMPLETED TRIPS Banner
                          Container(
                            width: 250,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: bannerOlive,
                              border: Border.all(color: Colors.black12, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                "COMPLETED TRIPS",
                                style: GoogleFonts.langar(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // DATE filter
                          Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: bannerOlive,
                              border: Border.all(color: Colors.black12, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "DATE",
                                  style: GoogleFonts.langar(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // LIST
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                _buildTripItem(context, "Roster No. 48"),
                                _buildTripItem(context, "Roster No. 49"),
                                _buildTripItem(context, "Roster No. 50"),
                                _buildTripItem(context, "Roster No. 51"),
                                _buildTripItem(context, "Roster No. 52"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
       // BOTTOM NAV
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildTripItem(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: listCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, size: 40, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.langar(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      FadeRoute(page: const SafariDetailsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: detailsButtonBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "GET DETAILS",
                      style: GoogleFonts.langar(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
