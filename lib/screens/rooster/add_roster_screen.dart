import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../menu/menu_screen.dart';
import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';



class AddRosterApp extends StatelessWidget {
  const AddRosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Visually matched olive green primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF555E40),
        ),
        textTheme: GoogleFonts.langarTextTheme(),
      ),
      home: const AddRosterScreen(),
    );
  }
}

class AddRosterScreen extends StatefulWidget {
  const AddRosterScreen({super.key});

  @override
  State<AddRosterScreen> createState() => _AddRosterScreenState();
}

class _AddRosterScreenState extends State<AddRosterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors extracted/approximated from description
  static const Color appGreen = Color(0xFF555E40); // Updated Olive Green
  static const Color cardBackground = Color(0xCC5E4B35); // Semi-transparent brown/olive
  static const Color headerGreen = Color(0xFF3A4F1F); // Darker green strip
  static const Color inputBackground = Color(0xFFF5F5F0); // Off-white
  static const Color saveButtonGreen = Color(0xFF7CFC00); // Bright green
  static const Color saveButtonText = Color(0xFF006400); // Dark green
  static const Color qrPlaceholder = Color(0xFFE0E0E0); // Light grey

  // Controllers
  final TextEditingController _rosterNoController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _resortChargesController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();

  bool _isSaving = false;
  int _selectedIndex = 1; // Default to Home (Center)

  @override
  void dispose() {
    _rosterNoController.dispose();
    _driverNameController.dispose();
    _resortChargesController.dispose();
    _ownerNameController.dispose();
    _driverPhoneController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _scaffoldKey.currentState?.openDrawer();
    } else if (index == 1) {
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Import might be needed if not present
        (route) => false,
      );
    } else if (index == 2) {
      _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _saveRoster() async {
    if (_rosterNoController.text.isEmpty || _driverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill Roster No and Driver Name at least')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Mapping to match Firestore Schema provided
      final Map<String, dynamic> rosterData = {
        'availability': true,
        'docDrivers': 1, // Default from schema screenshot
        'driverName': _driverNameController.text,
        'driverPhone': _driverPhoneController.text,
        'licensePlate': _rosterNoController.text, // Assuming Roster No maps here? Or separate? 
        // Screenshot shows "roosterNo" and "licensePlate". Using RosterNo for both for now or just roosterNo.
        // Actually screenshot has "roosterNo": "RJ14-AB-1234". Let's use that.
        'roosterNo': _rosterNoController.text,
        'ownerName': _ownerNameController.text,
        'ownerPhone': _ownerPhoneController.text,
        'qrCodeUrl': "",
        'resortCharges': _resortChargesController.text, // Not in schema but in UI. Adding it.
        'totalDrivers': 1,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('roosters')
          .doc(_rosterNoController.text) // Use Roster No as Document ID
          .set(rosterData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Roster saved successfully!')),
        );
        Navigator.pop(context); // Go back to list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving roster: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(), // Import MenuScreen if needed
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        title: const Text(
          "Add Roster",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22, // Visually matched
          ),
        ),
        centerTitle: false, // Slightly left-center
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30, // Increased size
              backgroundImage: const AssetImage(
                 'assets/logo.png', 
              ), // Local asset logo
              backgroundColor: Colors.white,
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0), 
            bottomRight: Radius.circular(0),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND: Forest/Safari Texture
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/background.png',
                ), // Forest texture placeholder
                fit: BoxFit.cover,
              ),
            ),
            // Slight dark overlay for contrast
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // MAIN CONTENT
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 160.0, bottom: 20.0), // Adjust for AppBar height + spacing
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // FORM CONTAINER
                    Container(
                      width: 310,
                      // height: 560, // Allow auto height or fix it if strict
                      constraints: const BoxConstraints(minHeight: 560),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Correction based on prompt: "Color: black" for DETAILS text
                           Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: headerGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "DETAILS",
                              style: TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          // INPUT FIELDS
                          _buildInputField("ROSTER NO.", controller: _rosterNoController),
                          const SizedBox(height: 12),
                          _buildInputField("DRIVER NAME", controller: _driverNameController),
                          const SizedBox(height: 12),
                          _buildInputField("RESORT CHARGES", isNumeric: true, controller: _resortChargesController),
                          const SizedBox(height: 12),
                          _buildInputField("OWNER NAME", controller: _ownerNameController),
                          const SizedBox(height: 16),

                          // QR CODE SECTION
                          Text(
                            "QR CODE",
                            style: GoogleFonts.langar(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: qrPlaceholder,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                                child: Icon(Icons.qr_code_2, size: 40, color: Colors.black54)
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // PHONE NUMBER FIELDS
                          _buildInputField("DRIVER NUMBER", isPhone: true, controller: _driverPhoneController),
                          const SizedBox(height: 12),
                          _buildInputField("OWNER NUMBER", isPhone: true, controller: _ownerPhoneController),
                          const SizedBox(height: 24),

                          // SAVE BUTTON
                          SizedBox(
                            width: 120,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveRoster,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: saveButtonGreen,
                                foregroundColor: saveButtonText,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: _isSaving 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: saveButtonText, strokeWidth: 2))
                                : Text(
                                "Save",
                                style: GoogleFonts.langar(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
            _buildNavItem(0, 'assets/nav_menu.png'),
            _buildNavItem(1, 'assets/nav_home_new.png'), 
            _buildNavItem(2, 'assets/transaction.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, {bool isNumeric = false, bool isPhone = false, required TextEditingController controller}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 12, right: 12), // Added right padding
      child: TextField(
        controller: controller,
        keyboardType: isNumeric
            ? TextInputType.number
            : (isPhone ? TextInputType.phone : TextInputType.text),
        style: GoogleFonts.langar(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.langar(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 12, // Hint usually smaller
          ),
          contentPadding: const EdgeInsets.only(bottom: 2), // Align text vertically
          isDense: true, 
        ),
      ),
    );
  }

   Widget _buildNavItem(int index, String assetPath) {
    bool isSelected = _selectedIndex == index;
    
    // Style constants
    const Color selectedOuterColor = Colors.white;
    const Color selectedInnerColor = Color(0xFFD4AF37); // Gold/Yellow
    const Color unselectedColor = Color(0xFFD9D9D9); // Light Grey
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 70 : 50,
        height: isSelected ? 70 : 50,
        padding: isSelected ? const EdgeInsets.all(6) : EdgeInsets.zero,
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
            color: isSelected ? selectedInnerColor : Colors.transparent, // Inner yellow only when selected, else transparent (icon on grey)
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            // color: Colors.black, // Removed to show original asset colors
          ),
        ),
      ),
    );
  }
}
