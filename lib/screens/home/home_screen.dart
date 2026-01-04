import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../landing/landing_screen.dart';
import '../../utils/slide_route.dart';
import '../../utils/fade_route.dart';
import '../booking/entry_choice_screen.dart';
import '../waiting_list/waiting_list_customer_screen.dart';
import '../completed_safari/completed_safari_screen.dart';
import 'widgets/slot_control_dialog.dart';
import '../../services/slot_availability_service.dart';
import '../../widgets/shared_ui.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}); // Remove const to allow GlobalKey

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors extracted/approximated from design
  // Colors extracted/approximated from design
  static const Color appGreen = AppColors.appGreen;
  static const Color buttonGold = AppColors.activeNavGold; // Reverted to Gold
  static const Color activeNavInner = AppColors.activeNavGold;
  static const Color activeNavOuter = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign key
      drawer: const MenuScreen(), // Add the Drawer
      endDrawer: TransactionScreen(), // Right Drawer (Transaction)
      extendBodyBehindAppBar: true,
      appBar: buildCommonAppBar(context, onBack: () {
         Navigator.pushAndRemoveUntil(
          context,
          FadeRoute(page: const LandingScreen()),
          (route) => false,
        );
      }),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND
          Container(
             decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.appGreen.withOpacity(0.6), // Greenish overlay to match design
            ),
          ),

          // 2. CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Reduced padding for wider buttons
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100), // Offset for AppBar
                
                _buildDashboardButton("BOOK A SAFARI", Icons.directions_car_filled_outlined, onTap: () {
                   if (!SlotAvailabilityService.instance.isTodaysBookingOpen.value) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         content: Text("Today's bookings are closed"),
                         backgroundColor: Colors.red,
                       ),
                     );
                     return;
                   }
                   Navigator.push(
                    context,
                    FadeRoute(page: EntryChoiceScreen()),
                  );
                }),
                const SizedBox(height: 24),
                
                _buildDashboardButton("WAITING LIST", Icons.directions_car_filled_outlined, onTap: () {
                    Navigator.push(
                    context,
                    FadeRoute(page: WaitingListCustomerScreen()),
                  );
                }),
                const SizedBox(height: 24),
                
                _buildDashboardButton("COMPLETED SAFARIS", Icons.directions_car_filled_outlined, onTap: () {
                   Navigator.push(
                    context,
                    FadeRoute(page: CompletedSafariScreen()),
                  );
                }),
              ],
            ),
          ),

          // 3. FLOATING ACTION BUTTON (Top Right)
          Positioned(
            top: 160, 
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SlotControlDialog(),
                );
              },
              backgroundColor: AppColors.activeNavGold,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/filter_icon.png', color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // BOTTOM NAV
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildDashboardButton(String text, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      height: 100, // Reduced height
      decoration: BoxDecoration(
        color: buttonGold,
        borderRadius: BorderRadius.circular(24), // Slightly more rounded
        border: Border.all(color: Colors.white, width: 2), 
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
          const SizedBox(width: 24), // Left padding
          CircleAvatar(
            radius: 30, // Reduced Icon background size
            backgroundColor: Colors.white,
             child: Icon(icon, color: Colors.black, size: 32), // Reduced Icon size
          ),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.langar(
                  color: Colors.black,
                  fontSize: 20, // Reduced Font Size
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 84), // 60 + 24 = 84 approx balance
        ],
      ),
      ),
    );
  }


}
