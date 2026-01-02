import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/fade_route.dart';
import 'waiting_list_driver_screen.dart';
import 'waiting_list_guide_screen.dart';

class WaitingListCustomerScreen extends StatelessWidget {
  const WaitingListCustomerScreen({super.key});

  // Colors based on common app theme
  static const Color appGreen = Color(0xFF555E40);
  static const Color cardBrown = Color(0xFF5E4B35); // Dark brown for the form card
  static const Color bannerGold = Color(0xFFD4AF37); // Gold for "WAITING LIST"
  static const Color inputFieldColor = Color(0xFFD9D9D9); // Light grey/white for inputs
  static const Color buttonGreen = Color(0xFF388E3C); // Dark green for buttons (from image roughly) but standardizing to previous used colors if needed. Actually image shows dark green/brown buttons.
  static const Color activeNavInner = Color(0xFFD4AF37);

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _timeSlotController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void _validateAndNavigate(BuildContext context, Widget targetScreen) {
    if (_nameController.text.isNotEmpty &&
        _contactController.text.isNotEmpty &&
        _hotelController.text.isNotEmpty &&
        _timeSlotController.text.isNotEmpty &&
        _zoneController.text.isNotEmpty &&
        _dateController.text.isNotEmpty) {
      Navigator.push(
        context,
        FadeRoute(page: targetScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all compulsory customer details."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: Row(
          children: [
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
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: appGreen.withOpacity(0.6),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // WAITING LIST Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: bannerGold,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          "WAITING LIST",
                          style: GoogleFonts.langar(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // FORM CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardBrown.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.transparent, width: 1),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "CUSTOMER DETAILS",
                            style: GoogleFonts.langar(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                             // decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          _buildTextField("NAME", _nameController),
                          _buildTextField("CONTACT NO.", _contactController),
                          _buildTextField("HOTEL", _hotelController),

                          // Row for Time Slot and Zone
                          Row(
                            children: [
                              Expanded(child: _buildTextField("TIME SLOT", _timeSlotController)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField("ZONE", _zoneController)),
                            ],
                          ),
                           _buildTextField("DATE", _dateController, widthFactor: 0.5, alignment: Alignment.centerLeft),


                          const SizedBox(height: 30),

                          _buildNavigationButton("DRIVER DETAILS", () {
                            _validateAndNavigate(context, const WaitingListDriverScreen());
                          }),
                          const SizedBox(height: 16),
                          _buildNavigationButton("GUIDE DETAILS", () {
                              _validateAndNavigate(context, const WaitingListGuideScreen());
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
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
            _buildNavItem('assets/images/nav_menu.png', size: 60), 
            
            // Home (Center)
            GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
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

            _buildNavItem('assets/images/transaction.png', size: 60), 
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {double widthFactor = 1.0, Alignment alignment = Alignment.center}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Align(
        alignment: alignment == Alignment.centerLeft ? Alignment.centerLeft : Alignment.center,
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(
            decoration: BoxDecoration(
              color: inputFieldColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: controller,
              style: GoogleFonts.langar(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                hintText: label,
                hintStyle: GoogleFonts.langar(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
       child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF434D35), // Dark green ish from image
          borderRadius: BorderRadius.circular(8),
             boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.langar(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
             color: Color(0xFFD9D9D9),
             shape: BoxShape.circle,
           ),
           padding: const EdgeInsets.all(8),
           child: Image.asset(assetPath, fit: BoxFit.contain),
         ),
      );
  }
}
