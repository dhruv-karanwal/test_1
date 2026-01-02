import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fade_route.dart';
import 'waiting_list_guide_screen.dart';

class WaitingListDriverScreen extends StatelessWidget {
  const WaitingListDriverScreen({super.key});

  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color cardBrown = Color(0xFF5E4B35);
  static const Color bannerGold = Color(0xFFD4AF37);
  static const Color inputFieldColor = Color(0xFFD9D9D9);
  static const Color activeNavInner = Color(0xFFD4AF37);

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
                    // WAITING LIST Banner
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
                          "WAITING LIST",
                          style: GoogleFonts.langar(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // FORM CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBrown.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.transparent, width: 1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "DRIVER DETAILS",
                            style: GoogleFonts.langar(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          _buildTextField("NAME"),
                          _buildTextField("CONTACT NO."),
                          _buildTextField("DRIVER ID"),
                          _buildTextField("TIME SLOT"),
                          _buildTextField("ROOSTER NUMBER"),

                          const SizedBox(height: 30),

                          _buildNavigationButton("GUIDE DETAILS", () {
                             Navigator.push(
                              context,
                              FadeRoute(page: const WaitingListGuideScreen()),
                            );
                          }),
                          const SizedBox(height: 16),
                          _buildNavigationButton("PROCEED TO PAY", () {
                             ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(content: Text("Payment Integration Pending"))
                             );
                          }),
                        ],
                      ),
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

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: inputFieldColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          style: GoogleFonts.langar(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: InputBorder.none,
            hintText: label,
            hintStyle: GoogleFonts.langar(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
       child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF434D35), // Dark green ish
          borderRadius: BorderRadius.circular(8),
             boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.langar(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
