import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../utils/fade_route.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const Color appGreen = Color(0xFF555E40);
    const Color navUnselected = Color(0xFFD9D9D9); // Grey
    const Color navSelectedOuter = Colors.white;
    const Color navSelectedInner = Color(0xFFD4AF37); // Gold/Yellow

    // We can assume we are not selected on "Detail" screens, or maybe Home is default?
    // In HotelList, we probably aren't "Home".
    // We'll mimic the "unselected" look for all, or standard behavior.
    // Actually, usually bottom nav indicates where we are.
    // If we are in HotelList, maybe none are selected?
    // Or maybe we treat it as a sub-page of Home?
    // Let's implement generic taps.

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
          _buildNavItem(context, 'assets/images/nav_menu.png', 0),
          _buildNavItem(context, 'assets/images/nav_home_new.png', 1),
          _buildNavItem(context, 'assets/images/transaction.png', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String assetPath, int index) {
    // Logic:
    // 0 -> Menu (Drawer)
    // 1 -> Home
    // 2 -> Transaction (EndDrawer)

    // Visuals: All unselected for now since this is a sub-screen?
    // Or if index 1 is Home, we are not Home.
    
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Scaffold.of(context).openDrawer();
        } else if (index == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            FadeRoute(page: HomeScreen()),
            (route) => false,
          );
        } else if (index == 2) {
          Scaffold.of(context).openEndDrawer();
        }
      },
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9), // Unselected gray
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
