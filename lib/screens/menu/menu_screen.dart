import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../rooster/rosters_detail_screen.dart';
import '../guide/guide_detail_screen.dart';
import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';
import '../hotels/hotel_list_screen.dart';
import '../completed_safari/completed_safari_screen.dart';
import '../../utils/slide_route.dart';
import '../../utils/fade_route.dart';
import '../../utils/app_colors.dart';
import '../compensation/compensation_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // Colors extracted from design
  // Colors extracted from design
  static const Color appGreen = AppColors.appGreen; // Standard App Green
  static const Color buttonBrown = AppColors.buttonBrown; // Brown buttons
  static const Color userCardBrown = AppColors.buttonBrown; // User Info Card
  static const Color userIconBg = AppColors.navIconBg; // Grey circle
  static const Color drawerBackground = Color(0xFFD4C19C); // Beige Drawer Background

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 304, // Exact width as requested
      backgroundColor: drawerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(0), // Normally drawers are square at bottom, but design might vary
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 80), // Top spacing

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
                  const SizedBox(width: 16),
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

          const SizedBox(height: 16),
          _buildMenuButton(context, "ROOSTER AVAILABILTY", () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              FadeRoute(page: const RosterDetailScreen()),
            );
          }),
          const SizedBox(height: 16),
          _buildMenuButton(context, "ROOSTER MAINTENACE", () {
             Navigator.pop(context); // Close drawer
             Navigator.push(
              context,
              FadeRoute(page: const RosterDetailScreen()),
            );
          }),
          const SizedBox(height: 16),
          _buildMenuButton(context, "HOTEL DETAILS MANAGEMENT", () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              FadeRoute(page: HotelListScreen()),
            );
          }),
          const SizedBox(height: 16),
          _buildMenuButton(context, "GUIDE MAINTENACE", () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              FadeRoute(page: const GuideDetailScreen()),
            );
          }),
          const SizedBox(height: 16),
          _buildMenuButton(context, "COMPENSATION", () {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              FadeRoute(page: const CompensationScreen()),
            );
          }),
        ],
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
             // Already on Menu (Left)
        } else if (index == 1) {
             Navigator.pushReplacement(
                context,
                FadeRoute(page: HomeScreen()),
              );
        } else if (index == 2) {
             Navigator.pushReplacement(
                context,
                FadeRoute(page: HomeScreen()),
              );
        }
      },
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
