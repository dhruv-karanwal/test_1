import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fade_route.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';

class SafariDetailsScreen extends StatelessWidget {
  SafariDetailsScreen({super.key});

  final Color appGreen = AppColors.appGreen;
  final Color containerBrown = AppColors.cardBrown;
  final Color bannerGold = AppColors.activeNavGold;
  final Color activeNavInner = AppColors.activeNavGold;
  final Color detailsCardBg = AppColors.cardBrown; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          // COMPLETED SAFARIS Banner
                          Container(
                            width: 250,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: bannerGold,
                              border: Border.all(color: Colors.black12, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                "COMPLETED SAFARIS",
                                style: GoogleFonts.langar(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Details Card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: detailsCardBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Roster No. 48",
                                    style: GoogleFonts.langar(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.detailHeading,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _buildDetailRow("Driver name", "Vivek"),
                                  _buildDetailRow("Name of passenger", "Rahul"),
                                  _buildDetailRow("No. of person", "5"),
                                  _buildDetailRow("Date", "13/12/25"),
                                  _buildDetailRow("Slot", "Morning"),
                                  _buildDetailRow("Time", "9 AM"),
                                ],
                              ),
                            ),
                          ),
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
      bottomNavigationBar: Container(
        height: 100,
        decoration: const BoxDecoration(
          color: AppColors.appGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
             _buildNavItem(context, 'assets/images/nav_menu.png', index: 0),
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
                    color: AppColors.activeNavGold,
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
            _buildNavItem(context, 'assets/images/transaction.png', index: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: GoogleFonts.langar(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ":",
              style: GoogleFonts.langar(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.langar(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String assetPath, {required int index}) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Scaffold.of(context).openDrawer();
        } else if (index == 2) {
          Scaffold.of(context).openEndDrawer();
        }
      },
      child: Container(
        width: 60,
        height: 60,
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
