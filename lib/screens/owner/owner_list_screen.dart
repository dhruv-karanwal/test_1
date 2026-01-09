import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/fade_route.dart';
import 'owner_details_screen.dart';
import 'add_owner_screen.dart';

class OwnerListScreen extends StatefulWidget {
  const OwnerListScreen({super.key});

  @override
  State<OwnerListScreen> createState() => _OwnerListScreenState();
}

class _OwnerListScreenState extends State<OwnerListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final List<String> owners = [
    "RAHUL SOLANKI",
    "DHRUV KARANWAL",
    "SHREERAM",
    "SHREERAM 2.0",
    "DEVASHISH 5.0",
    "KALYANI P",
    "JIYA JI",
    "JI JIYA JI",
  ];

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
                
                // Search Bar
                _buildSearchBar(),
                
                const SizedBox(height: 20),
                
                // Owner List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: owners.length,
                    itemBuilder: (context, index) {
                      return _buildOwnerItem(owners[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Floating Action Button (+)
          Positioned(
            bottom: 105,
            right: 18,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  FadeRoute(page: const AddOwnerScreen()),
                );
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9A648),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 36),
              ),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white, // Changed to White
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.langar(color: Colors.black),
          decoration: InputDecoration(
            hintText: "SEARCH OWNER",
            hintStyle: GoogleFonts.langar(color: Colors.black54),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7D5939), // Brownish background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.langar(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                FadeRoute(page: const OwnerDetailsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C9F4E), // Greenish
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: const Size(80, 30),
            ),
            child: Text(
              "GET DETAILS",
              style: GoogleFonts.langar(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
