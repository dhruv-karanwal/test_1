import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompletedSafariScreen extends StatelessWidget {
  const CompletedSafariScreen({super.key});

  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color cardBrown = Color(0xFF5E4B35);
  static const Color bannerGold = Color(0xFFD4AF37);
  static const Color activeNavInner = Color(0xFFD4AF37);
  static const Color cardContentBg = Color(0xFF8DA331); // Lighter green for cards

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
        title: Row(
          children: [
            Text(
              "BANDHAVGARH SAFARI",
              style: GoogleFonts.langar(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
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
