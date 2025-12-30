import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../rooster/rosters_detail_screen.dart';
import '../guide/guide_detail_screen.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  // Colors extracted from design (Consistent with MenuScreen)
  static const Color appGreen = Color(0xFF555E40); 
  static const Color buttonBrown = Color(0xFF6D5446); 
  static const Color userCardBrown = Color(0xFF6D5446); 
  static const Color userIconBg = Color(0xFFD9D9D9); 
  static const Color activeNavInner = Color(0xFFD4AF37); // Gold/Yellow
  static const Color activeNavOuter = Colors.white;
  static const Color drawerBackground = Color(0xFFD4C19C); 

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
              color: Colors.black.withOpacity(0.5), 
            ),
          ),

          // 2. DRAWER CONTAINER (Right Aligned)
          Align(
            alignment: Alignment.centerRight, // Right Aligned
            child: Container(
              width: 304, 
              decoration: const BoxDecoration(
                color: drawerBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), // Rounded top-left corner
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 160), 

                  // USER PROFILE CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: userCardBrown,
                        borderRadius: BorderRadius.circular(50), 
                         boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0), 
                            child: CircleAvatar(
                              radius: 42,
                              backgroundColor: userIconBg,
                              child: const Icon(Icons.person, size: 60, color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 24), 
                          Expanded( 
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
                                const SizedBox(height: 4), 
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
                  _buildMenuButton(context, "TRANSACTION HISTORY", () {
                     // Navigate to Transaction History logic
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Transaction History - Coming Soon")),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildMenuButton(context, "OTHER", () {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Other - Coming Soon")),
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
            
            _buildUnselectedNavItem(context, 'assets/nav_menu.png', 0),
            _buildUnselectedNavItem(context, 'assets/nav_home_new.png', 1),

            // Selected Transaction Item (Index 2)
             GestureDetector(
              onTap: () {}, 
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 70,
                height: 70, 
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: activeNavOuter, // White outer
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
                    color: activeNavInner, // Yellow inner
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/transaction.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity, 
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: buttonBrown,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(4), 
             boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
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
                    fontSize: 18, 
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
        if (index == 0) {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
        } else if (index == 1) {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
        }
      },
      child: Container(
        width: 60, 
        height: 60, 
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
         padding: const EdgeInsets.all(8), 
         child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
      ),
    );
  }
}
