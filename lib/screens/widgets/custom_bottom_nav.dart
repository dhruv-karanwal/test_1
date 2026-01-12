import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/fade_route.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNav({super.key, this.selectedIndex = 1}); // Default to 1 (Home)

  @override
  Widget build(BuildContext context) {
    // Style constants
    const Color appGreen = AppColors.appGreen;
    
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
    bool isSelected = selectedIndex == index;
    // For Home (index 1), we might want it to look "Active" by default if we consider these pages as sub-pages of Home.
    
    const Color selectedOuterColor = Colors.white;
    const Color selectedInnerColor = AppColors.activeNavGold; 
    const Color unselectedColor = AppColors.searchBarBg; 

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Scaffold.of(context).openDrawer();
        } else if (index == 1) {
           // If we are already on some sub-page, going "Home" means clearing stack to HomeScreen
           Navigator.pushAndRemoveUntil(
            context,
            FadeRoute(page: HomeScreen()),
            (route) => false,
          );
        } else if (index == 2) {
          Scaffold.of(context).openEndDrawer();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 70 : 60,
        height: isSelected ? 70 : 60,
        padding: isSelected ? const EdgeInsets.all(6) : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? selectedOuterColor : unselectedColor,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? selectedInnerColor : Colors.transparent, 
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
