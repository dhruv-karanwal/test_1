import 'package:flutter/material.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/app_colors.dart';

class PermitIdScreen extends StatefulWidget {
  const PermitIdScreen({super.key});

  @override
  State<PermitIdScreen> createState() => _PermitIdScreenState();
}

class _PermitIdScreenState extends State<PermitIdScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color appGreen = AppColors.appGreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      backgroundColor: appGreen,
      appBar: buildCommonAppBar(context),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landing_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(color: appGreen.withOpacity(0.6)),
      ),
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }
}
  
  // Colors
  // Colors
  static const Color appGreen = AppColors.appGreen;
  static const Color headerOrange = AppColors.highlightOrange; // Orange for toggle/header
  static const Color cardGreen = AppColors.headerGreen;
  static const Color buttonBrown = AppColors.buttonBrown;
  
  @override
  void dispose() {
    _permitController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_permitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Permit ID")),
      );
      return;
    }
    // Navigate to Confirmation
    Navigator.push(
      context,
      FadeRoute(page: const BookingConfirmationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appGreen,
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: Text(
          "BANDHAVGARH SAFARI",
          style: GoogleFonts.langar(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
           Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/landing_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: appGreen.withOpacity(0.6)),
            ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Toggle Header
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                               Navigator.pushReplacement(
                                 context,
                                 FadeRoute(page: const EntryChoiceScreen()),
                               );
                            },
                            child: Container(
                               decoration: BoxDecoration(
                                color: Colors.transparent, 
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Center(
                                child: Text(
                                  "NORMAL ENTRY",
                                  style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                             decoration: BoxDecoration(
                              color: headerOrange,
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Center(
                              child: Text(
                                "DRIVER BY CHOICE",
                                style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                   const SizedBox(height: 30),

                  // Enter Permit ID Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: buttonBrown, // Brown card
                      borderRadius: BorderRadius.circular(20),
                       border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ENTER PERMIT ID",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.langar(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 45,
                          color: Colors.white,
                          child: TextField(
                            controller: _permitController,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.langar(fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 2), // Remove default pad
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  
                  // Summary Placeholder
                   Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardGreen,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
     Center(
                           child: Text(
                             "SUMMARY",
                             style: GoogleFonts.langar(
                               color: Colors.white,
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                               decoration: TextDecoration.none, // Removed underline
                             ),
                           ),
                         ),
                         const SizedBox(height: 16),
                         // Placeholder data
                         _buildSummaryRow("Driver name", ": Vivek"),
                         _buildSummaryRow("Roster No.", ": 1"),
                         _buildSummaryRow("Name of passenger", ": Rahul"),
                          _buildSummaryRow("No. of person", ": 5"),
                         _buildSummaryRow("Slot", ": Evening"),
                          _buildSummaryRow("Date", ": 13/12/25"),
                      ],
                    ),
                  ),

                   const SizedBox(height: 30),

                   // Confirm Button
                   SizedBox(
                     width: 180,
                     child: ElevatedButton(
                        onPressed: _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBrown,
                          foregroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                           ),
                        ),
                        child: Text("CONFIRM", style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 18)),
                     ),
                   ),
                   const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
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
            _buildNavItem('assets/images/nav_menu.png', size: 60),
            
            // Home (Center)
            GestureDetector(
              onTap: () {
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
                  color: Colors.white,
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
                    color: AppColors.activeNavGold, // activeNavInner
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
            
            _buildNavItem('assets/images/transaction.png', size: 60), 
          ],
        ),
      ),
    );
  }
   Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.langar(
              color: const Color(0xFF3E2723), 
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.langar(
                color: const Color(0xFF3E2723),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildNavItem(String assetPath, {double size = 50}) {
     return GestureDetector(
       onTap: () {
         // Placeholder for menu/trans
       },
       child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: AppColors.navIconBg,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
     );
  }
}
