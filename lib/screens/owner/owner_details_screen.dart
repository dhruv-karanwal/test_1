import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';

class OwnerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ownerData;
  const OwnerDetailsScreen({super.key, required this.ownerData});

  @override
  State<OwnerDetailsScreen> createState() => _OwnerDetailsScreenState();
}

class _OwnerDetailsScreenState extends State<OwnerDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                
                // Static Search Bar showing name
                _buildSearchBar(widget.ownerData['Name'] ?? "Unknown"),
                
                const SizedBox(height: 40),
                
                // Details Card
                _buildDetailsCard(),
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

  Widget _buildSearchBar(String name) {
    return Padding(
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
              name,
              style: GoogleFonts.langar(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF8C9F4E), // Greenish background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("Owner name", ": ${widget.ownerData['Name'] ?? ''}"),
          const SizedBox(height: 12),
          _buildDetailRow("Roster No.", ": ${widget.ownerData['Rooster nos'] ?? ''}"),
          const SizedBox(height: 12),
          _buildDetailRow("Total Roosters", ": ${widget.ownerData['Total Roosters'] ?? ''}"),
          const SizedBox(height: 12),
          _buildDetailRow("Contact No.", ": ${widget.ownerData['Number'] ?? ''}"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.langar(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.langar(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
