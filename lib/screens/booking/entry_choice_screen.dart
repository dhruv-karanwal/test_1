import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'permit_id_screen.dart';
import 'booking_confirmation_screen.dart';
import '../home/home_screen.dart';

class EntryChoiceScreen extends StatefulWidget {
  const EntryChoiceScreen({super.key});

  @override
  State<EntryChoiceScreen> createState() => _EntryChoiceScreenState();
}

class _EntryChoiceScreenState extends State<EntryChoiceScreen> {
  bool _isDriverByChoice = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color headerOrange = Color(0xFFFF8C00); // Orange for toggle/header active
  static const Color cardBrown = Color(0xFF5E4B35); 
  static const Color inputBg = Color(0xFFF5F5F0);
  static const Color buttonBrown = Color(0xFF5E4B35);

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _hotelController.dispose();
    _timeController.dispose();
    _zoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onToggle(bool isDriverByChoice) {
     if (isDriverByChoice) {
       // Navigate to Permit ID Screen immediately as per User Request "once the toggle is changed to driver by choice the next permit id page"
       // Or simpler: Toggle state, and if true, push replacement? 
       // User said: "one is of normal entry, and once the toggle is changed to driver by choice the next permit id page"
       // This implies clicking the toggle button navigates.
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => const PermitIdScreen()),
       );
     }
  }

  void _confirmAndBook() {
     if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter Name")));
        return;
     }
     // Navigate to Confirmation
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const BookingConfirmationScreen()),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appGreen,
      appBar: AppBar(
        backgroundColor: appGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
             const Text(
              "BANDHAVGARH SAFARI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
             const SizedBox(width: 8),
            Image.asset('assets/logo.png', height: 30),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
           Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: appGreen.withOpacity(0.85)),
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
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _isDriverByChoice = false),
                            child: Container(
                               decoration: BoxDecoration(
                                color: !_isDriverByChoice ? headerOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
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
                          child: GestureDetector(
                             onTap: () => _onToggle(true), // Navigate on click
                             child: Container(
                               decoration: BoxDecoration(
                                color: _isDriverByChoice ? headerOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "DRIVER BY CHOICE",
                                  style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                   const SizedBox(height: 30),

                   // Customer Details Form
                   Container(
                     padding: const EdgeInsets.all(16),
                     decoration: BoxDecoration(
                       color: cardBrown.withOpacity(0.9),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          Center(
                            child: Text(
                              "CUSTOMER DETAILS",
                              style: GoogleFonts.langar(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildInput("NAME", _nameController),
                          const SizedBox(height: 12),
                          _buildInput("CONTACT NO.", _contactController, isPhone: true),
                          const SizedBox(height: 12),
                          _buildInput("HOTEL", _hotelController),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildInput("TIME SLOT", _timeController)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildInput("ZONE", _zoneController)),
                            ],
                          ),
                          const SizedBox(height: 12),
                           Container(
                              height: 40,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)), // Match input style
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ROOSTER ALLOTED :", style: GoogleFonts.langar(fontWeight: FontWeight.bold, color: Colors.black)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: headerOrange, borderRadius: BorderRadius.circular(4)),
                                    child: Text("12", style: GoogleFonts.langar(fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                           ),
                           const SizedBox(height: 12),
                           _buildInput("AMOUNT", _amountController, isNumber: true),

                           const SizedBox(height: 20),
                           // QR Placeholder
                           Center(
                             child: Container(
                               width: 150,
                               height: 100,
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: Center(
                                 child: Text("QR", style: GoogleFonts.langar(fontSize: 18, fontWeight: FontWeight.bold)),
                               ),
                             ),
                           ),
                       ],
                     ),
                   ),

                   const SizedBox(height: 20),

                   // Confirm Button
                   SizedBox(
                     width: 250,
                     child: ElevatedButton(
                        onPressed: _confirmAndBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBrown,
                          foregroundColor: Colors.white,
                           shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Colors.white),
                           ),
                        ),
                        child: Text("CONFIRM AND BOOK", style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 16)),
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
        height: 72,
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
            _buildNavItem('assets/nav_menu.png'),
            _buildNavItem('assets/nav_home_new.png', isHome: true, context: context), 
            _buildNavItem('assets/transaction.png'), 
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller, {bool isPhone = false, bool isNumber = false}) {
     return Container(
       height: 40,
       decoration: BoxDecoration(
         color: inputBg,
         borderRadius: BorderRadius.circular(4),
       ),
       padding: const EdgeInsets.symmetric(horizontal: 10),
       alignment: Alignment.centerLeft,
       child: TextField(
         controller: controller,
         keyboardType: isPhone ? TextInputType.phone : (isNumber ? TextInputType.number : TextInputType.text),
         style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 14),
         decoration: InputDecoration(
           border: InputBorder.none,
           hintText: hint,
           hintStyle: GoogleFonts.langar(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12),
           contentPadding: const EdgeInsets.only(bottom: 8),
         ),
       ),
     );
  }

   Widget _buildNavItem(String assetPath, {bool isHome = false, BuildContext? context}) {
     return GestureDetector(
       onTap: () {
         if (isHome && context != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
         }
       },
       child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isHome ? Colors.white : const Color(0xFFD9D9D9),
            shape: BoxShape.circle,
            border: isHome ? Border.all(color: const Color(0xFFD4AF37), width: 3) : null,
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
     );
  }
}
