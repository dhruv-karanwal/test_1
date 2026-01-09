import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';

class AddOwnerScreen extends StatefulWidget {
  const AddOwnerScreen({super.key});

  @override
  State<AddOwnerScreen> createState() => _AddOwnerScreenState();
}

class _AddOwnerScreenState extends State<AddOwnerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                      color: Colors.white, // Changed to White
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 8),
                          child: Icon(Icons.search, color: Colors.black),
                        ),
                        Text(
                          "SEARCH OWNER",
                          style: GoogleFonts.langar(color: Colors.black54),
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
        color: const Color(0xFFD9A648),
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
        color: const Color(0xFF7D5939), // Brownish background
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
          _buildInputField("GUIDE NAME"),
          const SizedBox(height: 16),
          _buildInputField("OWNER NUMBER"),
          const SizedBox(height: 16),
          _buildInputField("TOTAL ROOSTERS"),
          const SizedBox(height: 16),
          _buildInputField("ROSTER NOS."),
          const SizedBox(height: 32),
          
          GestureDetector(
            onTap: () {
              // Show Snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Details have been saved",
                    style: GoogleFonts.langar(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF8C9F4E),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Redirect
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD9A648), // Gold/Mustard
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Text(
                "Save",
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

  Widget _buildInputField(String hint) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
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
