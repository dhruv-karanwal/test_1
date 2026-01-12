import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';
import '../menu/menu_screen.dart';
import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/fade_route.dart';


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
          seedColor: AppColors.appGreen,
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
  static const Color appGreen = AppColors.appGreen; // Updated Olive Green
  static const Color cardBackground = AppColors.cardBrown; // Semi-transparent brown/olive
  static const Color headerGreen = AppColors.appGreen; // Darker green strip
  static const Color inputBackground = AppColors.searchBarBg; // Off-white
  static const Color saveButtonGreen = AppColors.confirmButton; // Bright green
  static const Color saveButtonText = Colors.black; // Dark green
  static const Color qrPlaceholder = Color(0xFFE0E0E0); // Light grey

  // Controllers
  final TextEditingController _rosterNoController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();

  // State Variables
  bool _isSaving = false;
  int _selectedIndex = 1; // Default to Home (Center)
  
  // New Fields
  int _capacity = 6;
  final List<int> _capacityOptions = [6, 8];

  String _rosterStatus = "Available";
  final List<String> _statusOptions = ["Available", "Unavailable"];


  @override
  void dispose() {
    _rosterNoController.dispose();
    _driverNameController.dispose();
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
        FadeRoute(page: HomeScreen()), 
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
      final Map<String, dynamic> rosterData = {
        'availability': _rosterStatus == "Available", // Boolean based on string
        'status': _rosterStatus, // String value too? logic from prompt
        'capacity': _capacity,
        'docDrivers': 1, 
        'driverName': _driverNameController.text,
        'driverPhone': _driverPhoneController.text,
        'licensePlate': _rosterNoController.text, 
        'roosterNo': _rosterNoController.text,
        'ownerName': _ownerNameController.text,
        'ownerPhone': _ownerPhoneController.text,
        'qrCodeUrl': "",
        'totalDrivers': 1,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _performSave(rosterData);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error preparing roster: $e')),
        );
         setState(() {
          _isSaving = false;
        });
      }
    } 
  }

  Future<void> _performSave(Map<String, dynamic> rosterData) async {
     try {
       await FirebaseFirestore.instance
          .collection('roosters')
          .doc(_rosterNoController.text) 
          .set(rosterData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Roster saved successfully!')),
        );
        Navigator.pop(context); 
      }
     } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Error saving roster details: $e')),
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
      drawer: const MenuScreen(), 
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
            fontSize: 22, 
          ),
        ),
        centerTitle: false, 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30, 
              backgroundImage: const AssetImage(
                 'assets/images/logo.png', 
              ), 
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
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landing_bg.png',
                ), 
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.appGreen.withOpacity(0.6),
            ),
          ),

          // MAIN CONTENT
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 160.0, bottom: 20.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // FORM CONTAINER
                    Container(
                      width: 310,
                      constraints: const BoxConstraints(minHeight: 560),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                           Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.activeNavGold, // Gold/Mustard
                              borderRadius: BorderRadius.circular(20), // Standardized radius
                              border: Border.all(color: Colors.white, width: 1), // White border
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "DETAILS",
                              style: TextStyle(
                                color: Colors.black, // Black text
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
                          // REPLACED Charges with Capacity & Status
                          
                          Row(
                            children: [
                               Expanded(
                                child: _buildDropdown(
                                  label: "CAPACITY",
                                  value: _capacity,
                                  items: _capacityOptions,
                                  onChanged: (val) {
                                    if(val != null) setState(() => _capacity = val);
                                  }
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDropdown(
                                  label: "STATUS",
                                  value: _rosterStatus,
                                  items: _statusOptions,
                                  onChanged: (val) {
                                    if(val != null) setState(() => _rosterStatus = val);
                                  }
                                ),
                              ),
                            ],
                          ),
                          
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/images/qr_code.png', fit: BoxFit.contain),
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
                                backgroundColor: AppColors.confirmButton, // Unified Green
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: _isSaving 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
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
            _buildNavItem(0, 'assets/images/nav_menu.png'),
            _buildNavItem(1, 'assets/images/nav_home_new.png'), 
            _buildNavItem(2, 'assets/images/transaction.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required T value, required List<T> items, required ValueChanged<T?> onChanged}) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: inputBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
             icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((T item) {
                return Align(
                   alignment: Alignment.centerLeft,
                    child: Text(
                    "$item", // Primitive toString
                    style: GoogleFonts.langar(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList();
            },
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  "$item",
                  style: GoogleFonts.langar(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text(
              label,
               style: GoogleFonts.langar(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
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
    const Color selectedInnerColor = AppColors.activeNavGold; // Gold/Yellow
    const Color unselectedColor = AppColors.navIconBg; // Light Grey
    
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
