import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedSafariScreen extends StatelessWidget {
  CompletedSafariScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors from design image
  static const Color appGreen = Color(0xFF555E40);
  static const Color containerBrown = Color(0xFF6D5446); // Main brown area
  static const Color bannerOlive = Color(0xFF8DA331); // Banner green
  static const Color activeNavInner = Color(0xFFD4AF37);
  static const Color listCardBg = Color(0xFFD9D9D9); // Greyish-white for cards
  static const Color detailsButtonBg = Color(0xFF8DA331); // Button green

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                                  fontWeight: FontWeight.extrabold,
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
                                _buildTripItem(context, "Roaster No. 48"),
                                _buildTripItem(context, "Roaster No. 49"),
                                _buildTripItem(context, "Roaster No. 50"),
                                _buildTripItem(context, "Roaster No. 51"),
                                _buildTripItem(context, "Roaster No. 52"),
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
      bottomNavigationBar: Container(
        height: 100,
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
                Navigator.popUntil(context, (route) => route.isFirst);
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
                    color: activeNavInner,
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
                    fontWeight: FontWeight.extrabold,
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

  Widget _buildNavItem(String assetPath, {double size = 50}) {
      return GestureDetector(
        onTap: () {
          // Placeholder for menu/trans
        },
        child: Container(
           width: size,
           height: size,
           decoration: const BoxDecoration(
             color: Color(0xFFD9D9D9),
             shape: BoxShape.circle,
           ),
           padding: const EdgeInsets.all(8),
           child: Image.asset(assetPath, fit: BoxFit.contain),
         ),
      );
  }
}
