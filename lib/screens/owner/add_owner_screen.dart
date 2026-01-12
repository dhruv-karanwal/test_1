import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOwnerScreen extends StatefulWidget {
  const AddOwnerScreen({super.key});

  @override
  State<AddOwnerScreen> createState() => _AddOwnerScreenState();
}

class _AddOwnerScreenState extends State<AddOwnerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _totalRoostersController = TextEditingController();
  final TextEditingController _rosterNosController = TextEditingController();
  
  bool _isSaving = false;

  Future<void> _saveOwnerToFirestore() async {
    if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter Owner Name", style: GoogleFonts.langar())),
        );
        return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('owner').doc(_nameController.text.trim()).set({
        'Name': _nameController.text.trim(),
        'Number': _numberController.text.trim(),
        'Total Roosters': _totalRoostersController.text.trim(),
        'Rooster nos': _rosterNosController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Details have been saved",
            style: GoogleFonts.langar(color: Colors.white),
          ),
          backgroundColor: AppColors.confirmButton,
          duration: const Duration(seconds: 2),
        ),
      );
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving: $e", style: GoogleFonts.langar())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _totalRoostersController.dispose();
    _rosterNosController.dispose();
    super.dispose();
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
        children: [
          // Background with overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.appGreen.withOpacity(0.6),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // OWNER DETAILS Banner
                _buildBanner("OWNER DETAILS"),
                
                const SizedBox(height: 20),
                
                // SEARCH Bar placeholder
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.searchBarBg, // Updated to Grey
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 8),
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                        Text(
                          "SEARCH OWNER",
                          style: GoogleFonts.langar(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Form Card
                _buildFormCard(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildCommonBottomNav(context, _scaffoldKey),
    );
  }

  Widget _buildBanner(String text) {
    return Container(
      width: 280,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.activeNavGold,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.langar(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBrown.withOpacity(0.9), // Unified Brown
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTitleBanner("DETAILS"),
          const SizedBox(height: 24),
          _buildInputField("OWNER NAME", _nameController),
          const SizedBox(height: 16),
          _buildInputField("OWNER NUMBER", _numberController),
          const SizedBox(height: 16),
          _buildInputField("TOTAL ROOSTERS", _totalRoostersController),
          const SizedBox(height: 16),
          _buildInputField("ROSTER NOS.", _rosterNosController),
          const SizedBox(height: 32),
          
          GestureDetector(
            onTap: _isSaving ? null : _saveOwnerToFirestore,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.confirmButton, // Unified Green
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                _isSaving ? "Saving..." : "Save",
                style: GoogleFonts.langar(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBanner(String text) {
    return Container(
      width: 180,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D4B8), // Beige
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.langar(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          style: GoogleFonts.langar(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.langar(color: Colors.black, fontWeight: FontWeight.bold),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(bottom: 12),
          ),
        ),
      ),
    );
  }
}
