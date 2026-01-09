import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../screens/home/home_screen.dart';
import '../utils/fade_route.dart';
import '../screens/landing/landing_screen.dart';
import '../screens/widgets/custom_bottom_nav.dart';

// extracted from HomeScreen
const Color appGreen = Color(0xFF555E40);
const Color activeNavInner = AppColors.activeNavGold;
const Color activeNavOuter = Colors.white;

PreferredSizeWidget buildCommonAppBar(BuildContext context, {VoidCallback? onBack, String title = "BANDHAVGARH SAFARI"}) {
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
          title, 
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
  // Using the shared CustomBottomNav widget. 
  // We ignore scaffoldKey here because CustomBottomNav uses Scaffold.of(context) internally.
  return const CustomBottomNav(selectedIndex: 1);
}
