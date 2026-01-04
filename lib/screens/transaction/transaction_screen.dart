import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../../utils/app_colors.dart';
import 'transaction_history_screen.dart';
import '../../utils/fade_route.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Usually passed or not needed if just a drawer

  // Colors
  // Colors
  static const Color appGreen = AppColors.appGreen; 
  static const Color buttonBrown = AppColors.buttonBrown; 
  static const Color userCardBrown = AppColors.cardBrown; 
  static const Color userIconBg = AppColors.navIconBg; 
  static const Color activeNavInner = AppColors.activeNavGold; // Gold/Yellow
  static const Color activeNavOuter = Colors.white;
  static const Color drawerBackground = Color(0xFFD4C19C); // Keep specific drawer color or standardize? Keeping for now. 

  @override
  Widget build(BuildContext context) {
    return Drawer( // Extends Drawer
      backgroundColor: Colors.transparent, // Transparent to show dims
      elevation: 0,
      width: 304, // Fixed width as per design
      child: Container(
        decoration: const BoxDecoration(
          color: drawerBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), // Rounded top-left corner for Right Drawer
            bottomLeft: Radius.circular(40), // Typically symmetry looks good, or just top. Design had top-left.
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60), // Top spacing

             // Close Button (Optional but good UX for right drawer)
             // Align(
             //   alignment: Alignment.centerLeft,
             //   child: IconButton(
             //     icon: const Icon(Icons.close, color: Colors.black),
             //     onPressed: () => Navigator.pop(context),
             //   ),
             // ),

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
               Navigator.push(
                 context,
                 FadeRoute(page: const TransactionHistoryScreen()),
               );
            }),
            const SizedBox(height: 16),
            _buildMenuButton(context, "OTHER", () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Other - Coming Soon")),
              );
            }),
            
            Expanded(child: Container()), // Spacer
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
  
  Widget _buildNavItem(BuildContext context, String assetPath, int index, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, 
        height: 60, 
        decoration: const BoxDecoration(
          color: AppColors.navIconBg,
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
