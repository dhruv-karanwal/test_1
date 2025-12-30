import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../rooster/rosters_detail_screen.dart';
import '../guide/guide_detail_screen.dart';
import '../home/home_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Colors extracted from design
  static const Color appGreen = Color(0xFF555E40); // Standard App Green
  static const Color buttonBrown = Color(0xFF6D5446); // Brown buttons
  static const Color userCardBrown = Color(0xFF6D5446); // User Info Card
  static const Color userIconBg = Color(0xFFD9D9D9); // Grey circle
  static const Color activeNavInner = Color(0xFFD4AF37); // Gold/Yellow (Menu)
  static const Color activeNavOuter = Colors.white;
  static const Color drawerBackground = Color(0xFFD4C19C); // Beige Drawer Background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Custom implementation
        toolbarHeight: 93,
        backgroundColor: appGreen,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
        elevation: 0, 
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND (Full Screen)
          Container(
             decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5), // Dark overlay for menu focus
            ),
          ),

          // 2. DRAWER CONTAINER (Left Aligned, Specific Width)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 304, // Exact width as requested
              color: drawerBackground,
              child: Column(
                children: [
                  const SizedBox(height: 160), // Increased top spacing for clear gap from AppBar

                  // USER PROFILE CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Tighter padding for narrower width
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: userCardBrown.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(50), 
                        border: Border.all(color: Colors.black54, width: 1),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0), // Increased to ensure full visibility
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: userIconBg,
                              child: const Icon(Icons.person, size: 60, color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 24), // Increased gap
                          Expanded( // Added Expanded to avoid overlap/overflow
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "USER 101",
                                  style: GoogleFonts.langar(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4), // Added vertical gap
                                Text(
                                  "CLERK-12410",
                                  style: GoogleFonts.langar(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // MENU BUTTONS
                  _buildMenuButton(context, "ROOSTER AVAILABILTY", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RosterDetailScreen()),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildMenuButton(context, "ROOSTER MAINTENACE", () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RosterDetailScreen()),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildMenuButton(context, "HOTEL DETAILS MANAGEMENT", () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Coming Soon")),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildMenuButton(context, "GUIDE MAINTENACE", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GuideDetailScreen()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      // BOTTOM NAV
      bottomNavigationBar: Container(
        height: 100, // Increased from 72
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
            // Selected Menu Item
            GestureDetector(
              onTap: () {}, 
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
                    'assets/nav_menu.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            _buildUnselectedNavItem(context, 'assets/nav_home_new.png', 1),
            _buildUnselectedNavItem(context, 'assets/transaction.png', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding for drawer
      child: SizedBox(
        width: double.infinity, 
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: buttonBrown.withOpacity(0.9),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Center(
                child: Text(
                  text,
                  style: GoogleFonts.langar(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14, 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnselectedNavItem(BuildContext context, String assetPath, int index) {
     return GestureDetector(
      onTap: () {
        if (index == 1) {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
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
