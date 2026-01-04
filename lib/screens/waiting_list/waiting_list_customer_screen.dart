import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/fade_route.dart';
import '../../widgets/shared_ui.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import 'waiting_list_driver_screen.dart';
import 'waiting_list_guide_screen.dart';

class WaitingListCustomerScreen extends StatefulWidget {
  const WaitingListCustomerScreen({super.key});

  @override
  State<WaitingListCustomerScreen> createState() => _WaitingListCustomerScreenState();
}

class _WaitingListCustomerScreenState extends State<WaitingListCustomerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Colors based on common app theme
  static const Color appGreen = AppColors.appGreen;
  static const Color cardBrown = AppColors.cardBrown; // Dark brown for the form card
  static const Color bannerGold = AppColors.highlightOrange; // Gold for "WAITING LIST"
  static const Color inputFieldColor = AppColors.inputBg; // Light grey/white for inputs
  static const Color buttonGreen = AppColors.headerGreen; 
  static const Color activeNavInner = AppColors.activeNavGold;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _permitIdController = TextEditingController(); // Added
  
  // Dropdown selection
  String? _selectedTimeSlot;
  final List<String> _timeSlots = ["Morning", "Evening"];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _hotelController.dispose();
    _zoneController.dispose();
    _dateController.dispose();
    _permitIdController.dispose(); // Added
    super.dispose();
  }

  void _validateAndNavigate(BuildContext context, Widget targetScreen) {
    if (_nameController.text.isNotEmpty &&
        _contactController.text.isNotEmpty &&
        _hotelController.text.isNotEmpty &&
        _selectedTimeSlot != null &&
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: appGreen, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appGreen, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: true,
      appBar: buildCommonAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
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
                              Expanded(
                                child: _buildDropdownField("TIME SLOT"),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField("ZONE", _zoneController)),
                            ],
                          ),
                          
                          // Row for Date and Permit ID
                           Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  "DATE", 
                                  _dateController, 
                                  alignment: Alignment.centerLeft,
                                  readOnly: true,
                                  onTap: () => _selectDate(context),
                                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54, size: 20),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField("PERMIT ID", _permitIdController),
                              ),
                            ],
                          ),


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
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildDropdownField(String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: inputFieldColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedTimeSlot,
            hint: Text(
              hintText,
              style: GoogleFonts.langar(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            isExpanded: true,
            dropdownColor: inputFieldColor,
            items: _timeSlots.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.langar(color: Colors.black, fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedTimeSlot = newValue;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    double widthFactor = 1.0, 
    Alignment alignment = Alignment.center,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
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
              readOnly: readOnly,
              onTap: onTap,
              style: GoogleFonts.langar(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: InputBorder.none,
                hintText: label,
                hintStyle: GoogleFonts.langar(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
                suffixIcon: suffixIcon,
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
          color: AppColors.headerGreen, // Dark green ish from image
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
              color: Colors.white, // Text color should be white on dark green
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


}
