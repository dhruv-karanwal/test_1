import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../screens/home/home_screen.dart';
import '../utils/fade_route.dart';
import '../screens/landing/landing_screen.dart';

// extracted from HomeScreen
const Color appGreen = Color(0xFF555E40);
const Color activeNavInner = AppColors.activeNavGold;
const Color activeNavOuter = Colors.white;

PreferredSizeWidget buildCommonAppBar(BuildContext context, {VoidCallback? onBack}) {
  return AppBar(
    automaticallyImplyLeading: false,
    toolbarHeight: 93,
    backgroundColor: appGreen,
    title: Row(
      children: [
        GestureDetector(
          onTap: onBack ?? () {
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
          backgroundImage: const AssetImage('assets/images/logo.png'), 
        ),
      ),
    ],
  );
}

Widget buildCommonBottomNav(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return Container(
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
        _buildNavItem(context, 'assets/images/nav_menu.png', 0, scaffoldKey),
        
        // Home (Center) - Always highlighted as "Home" for now based on request context?
        // Or if we iterate, we might want to know which one is active.
        // For now, mirroring HomeScreen layout where Home is big.
        GestureDetector(
          onTap: () {
            // If we are not on HomeScreen, navigate there
             // Checking via route name is hard without named routes.
             // We'll simplisticly assume if we just push Home it's fine, 
             // or maybe we should disable it if we ARE on home?
             // Simplest: "RemoveUntil" to Home.
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
                'assets/images/nav_home_new.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        _buildNavItem(context, 'assets/images/transaction.png', 2, scaffoldKey),
      ],
    ),
  );
}

Widget _buildNavItem(BuildContext context, String assetPath, int index, GlobalKey<ScaffoldState> scaffoldKey) {
  return GestureDetector(
    onTap: () {
      if (index == 0) {
        scaffoldKey.currentState?.openDrawer();
      } else if (index == 2) {
        scaffoldKey.currentState?.openEndDrawer();
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
      child: Image.asset(assetPath, fit: BoxFit.contain),
    ),
  );
}
