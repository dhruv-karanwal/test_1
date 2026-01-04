import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import 'permit_id_screen.dart';
import 'booking_confirmation_screen.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../widgets/shared_ui.dart';
import '../../services/slot_availability_service.dart';
import '../../utils/fade_route.dart';

class EntryChoiceScreen extends StatefulWidget {
  const EntryChoiceScreen({super.key});

  @override
  State<EntryChoiceScreen> createState() => _EntryChoiceScreenState();
}

class _EntryChoiceScreenState extends State<EntryChoiceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDriverByChoice = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedTimeSlot;

  // Colors
  static const Color appGreen = AppColors.appGreen;
  static const Color headerOrange = AppColors.highlightOrange; // Orange for toggle/header active
  static const Color headerGreen = AppColors.headerGreen; // Darker green strip from AddRoster
  static const Color cardBrown = AppColors.cardBrown; // Matches AddRoster cardBackground
  static const Color inputBg = AppColors.inputBg;
  static const Color buttonBrown = AppColors.buttonBrown;

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
       Navigator.pushReplacement(
         context,
         FadeRoute(page: const PermitIdScreen()),
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
       FadeRoute(page: const BookingConfirmationScreen()),
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      backgroundColor: appGreen,
      appBar: buildCommonAppBar(context),
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
                            onTap: () => setState(() => _isDriverByChoice = false),
                            child: Container(
                               decoration: BoxDecoration(
                                color: !_isDriverByChoice ? headerOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Center(
                                child: Text(
                                  "NORMAL ENTRY",
                                  style: GoogleFonts.langar(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14, 
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                             onTap: () => _onToggle(true),
                             child: Container(
                               decoration: BoxDecoration(
                                color: _isDriverByChoice ? headerOrange : Colors.transparent,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Center(
                                child: Text(
                                  "DRIVER BY CHOICE",
                                  style: GoogleFonts.langar(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 14, 
                                    color: Colors.black
                                  ),
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
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: cardBrown, 
                       borderRadius: BorderRadius.circular(22),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                              decoration: BoxDecoration(
                                color: headerGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "CUSTOMER DETAILS",
                                style: GoogleFonts.langar(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          _buildInput("NAME", _nameController),
                          const SizedBox(height: 12),
                          _buildInput("CONTACT NO.", _contactController, isPhone: true),
                          const SizedBox(height: 12),
                          _buildInput("HOTEL", _hotelController),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(flex: 4, child: _buildTimeDropdown("TIME SLOT")), 
                              const SizedBox(width: 12),
                              Expanded(flex: 3, child: _buildInput("ZONE", _zoneController)),
                            ],
                          ),
                          const SizedBox(height: 12),
                           Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F0), 
                                borderRadius: BorderRadius.circular(4)
                              ), 
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ROOSTER ALLOTED :", style: GoogleFonts.langar(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: headerOrange, 
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    child: Text("12", style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 16)),
                                  )
                                ],
                              ),
                           ),
                           const SizedBox(height: 12),
                           _buildInput("AMOUNT", _amountController, isNumber: true),

                           const SizedBox(height: 24),
                           // QR Placeholder
                           Center(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Image.asset('assets/images/qr_code.png', fit: BoxFit.contain),
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
       bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller, {bool isPhone = false, bool isNumber = false}) {
     return Container(
       height: 45,
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
           hintStyle: GoogleFonts.langar(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 13), 
           contentPadding: const EdgeInsets.only(bottom: 6), 
         ),
       ),
     );
  }

  Widget _buildTimeDropdown(String hint) {
     final service = SlotAvailabilityService.instance;
     List<DropdownMenuItem<String>> items = [];

     if (service.isMorningSlotsOpen.value) {
       items.add(const DropdownMenuItem(value: "Morning", child: Text("Morning")));
     }
     if (service.isEveningSlotsOpen.value) {
       items.add(const DropdownMenuItem(value: "Evening", child: Text("Evening")));
     }

     if (_selectedTimeSlot != null) {
         bool isValid = items.any((item) => item.value == _selectedTimeSlot);
         if (!isValid) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
               if (mounted) setState(() => _selectedTimeSlot = null);
            });
         }
     }

     return Container(
       height: 45,
       decoration: BoxDecoration(
         color: inputBg,
         borderRadius: BorderRadius.circular(4),
       ),
       padding: const EdgeInsets.symmetric(horizontal: 10),
       alignment: Alignment.centerLeft,
       child: DropdownButtonHideUnderline(
         child: DropdownButton<String>(
           value: _selectedTimeSlot,
           hint: Text(
             hint,
             style: GoogleFonts.langar(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 13),
           ),
           isExpanded: true,
           icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
           items: items,
           onChanged: (val) {
             setState(() {
               _selectedTimeSlot = val;
             });
           },
           style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
           dropdownColor: inputBg,
         ),
       ),
     );
  }
}
