import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../menu/menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Colors extracted/approximated from design
  static const Color appGreen = Color(0xFF555E40);
  static const Color buttonGold = Color(0xFFD4AF37); // Gold color for buttons
  static const Color activeNavInner = Color(0xFFD4AF37);
  static const Color activeNavOuter = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 93,
        backgroundColor: appGreen,
        title: Row(
          children: [
             GestureDetector(
              onTap: () {
                // Navigate to back or exit? Home is usually top level.
                // But image shows back arrow. Leaving it non-functional or exit for now if it's root.
                // Or maybe user meant "Drawer Menu" button should be here?
                // The image shows back arrow in app bar, but Bottom Nav has Menu.
                // Standard pattern: Root screen doesn't have back.
                // I will keep the back arrow passing 'maybePop' just in case.
                 Navigator.maybePop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
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
              backgroundImage: const AssetImage('assets/logo.png'), 
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND
          Container(
             decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Offset for AppBar
                
                _buildDashboardButton("BOOK A SAFARI", Icons.directions_car_filled_outlined),
                const SizedBox(height: 24),
                
                _buildDashboardButton("WAITING LIST", Icons.directions_car_filled_outlined),
                const SizedBox(height: 24),
                
                _buildDashboardButton("COMPLETED SAFARIS", Icons.directions_car_filled_outlined),
              ],
            ),
          ),
        ],
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        height: 72,
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
            _buildUnselectedNavItem(context, 'assets/nav_menu.png', 0), // Menu (Left)

            // Center (Home) - Selected
            GestureDetector(
              onTap: () {}, // Already Home
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: activeNavOuter,
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
                    'assets/nav_home_new.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            _buildUnselectedNavItem(context, 'assets/transaction.png', 2), // Transactions
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(String text, IconData icon) {
    return Container(
      width: double.infinity,
      height: 120, // Tall, blocky buttons as per design
      decoration: BoxDecoration(
        color: buttonGold,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2), // White dashed look in image? Solid for now.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 56), // Placeholder to balance the icon on the right for perfect symmetry (Icon is radius 30*2 + paddings)
          // Actually, using Expanded -> Center is better.
          Expanded(
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.langar(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
             child: Icon(icon, color: Colors.black, size: 36), 
          ),
          const SizedBox(width: 24), // Right padding for icon
        ],
      ),
    );
  }

  Widget _buildUnselectedNavItem(BuildContext context, String assetPath, int index) {
     return GestureDetector(
      onTap: () {
        if (index == 0) {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
        } else if (index == 2) {
             ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Transactions - Coming Soon")),
             );
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
         padding: const EdgeInsets.all(12),
         child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
      ),
    );
  }
}
