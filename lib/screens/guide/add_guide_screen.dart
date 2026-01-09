import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';
import '../menu/menu_screen.dart';
import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/fade_route.dart';
import '../../widgets/shared_ui.dart';
import '../widgets/custom_bottom_nav.dart';

class AddGuideApp extends StatelessWidget {
  const AddGuideApp({super.key});

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
      home: const AddGuideScreen(),
    );
  }
}

class AddGuideScreen extends StatefulWidget {
  const AddGuideScreen({super.key});

  @override
  State<AddGuideScreen> createState() => _AddGuideScreenState();
}

class _AddGuideScreenState extends State<AddGuideScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Colors extracted/approximated from description
  static const Color appGreen = AppColors.appGreen; // Updated Olive Green
  static const Color cardBackground = AppColors.cardBrown; // Semi-transparent brown/olive
  static const Color headerGreen = AppColors.headerGreen; // Darker green strip
  static const Color inputBackground = AppColors.inputBg; // Off-white
  static const Color saveButtonGreen = AppColors.highlightOrange; // Bright green
  static const Color saveButtonText = Colors.black; // Dark green
  static const Color qrPlaceholder = Color(0xFFE0E0E0); // Light grey

  // Controllers
  final TextEditingController _guideNoController = TextEditingController();
  final TextEditingController _guideNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _guidePhoneController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();

  bool _isSaving = false;
  int _selectedIndex = 1; // Default to Home (Center)

  @override
  void dispose() {
    _guideNoController.dispose();
    _guideNameController.dispose();
    _ownerNameController.dispose();
    _guidePhoneController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }


  Future<void> _saveGuide() async {
    if (_guideNoController.text.isEmpty || _guideNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill Guide No and Guide Name at least')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final Map<String, dynamic> guideData = {
        'availability': true,
        'guideName': _guideNameController.text,
        'guidePhone': _guidePhoneController.text,
        'guideNo': _guideNoController.text,
        'ownerName': _ownerNameController.text,
        'ownerPhone': _ownerPhoneController.text,
        'qrCodeUrl': "",
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('guides')
          .doc(_guideNoController.text) // Use Guide No as Document ID
          .set(guideData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guide saved successfully!')),
        );
        Navigator.pop(context); // Go back to list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving guide: $e')),
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
      appBar: buildCommonAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND: Forest/Safari Texture
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/landing_bg.png',
                ), 
                fit: BoxFit.cover,
              ),
            ),
            // Slight dark overlay for contrast
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
                              color: const Color(0xFFD9A648), // Gold/Mustard
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
                          _buildInputField("GUIDE NO.", controller: _guideNoController),
                          const SizedBox(height: 12),
                          _buildInputField("GUIDE NAME", controller: _guideNameController),
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
                          _buildInputField("GUIDE NUMBER", isPhone: true, controller: _guidePhoneController),
                          const SizedBox(height: 12),
                          _buildInputField("OWNER NUMBER", isPhone: true, controller: _ownerPhoneController),
                          const SizedBox(height: 24),

                          // SAVE BUTTON
                          SizedBox(
                            width: 120,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveGuide,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9A648), // Gold/Mustard
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
      bottomNavigationBar: const CustomBottomNav(selectedIndex: 1),
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
      padding: const EdgeInsets.only(left: 12, right: 12), 
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
            fontSize: 12, 
          ),
          contentPadding: const EdgeInsets.only(bottom: 2), 
          isDense: true, 
        ),
      ),
    );
  }

}
