import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';
import '../../utils/fade_route.dart';
import 'owner_details_screen.dart';
import 'add_owner_screen.dart';
import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';

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
  void initState() {
    super.initState();
    _migrateExistingOwners();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _migrateExistingOwners() async {
    final collection = FirebaseFirestore.instance.collection('owner');
    
    for (String name in owners) {
      // Check if document with this name already exists
      final docRef = collection.doc(name);
      final docSnapshot = await docRef.get();
      
      if (!docSnapshot.exists) {
        // Add default/dummy data for existing hardcoded owners
        await docRef.set({
          'Name': name,
          'Number': 'N/A',
          'Total Roosters': 'N/A',
          'Rooster nos': 'N/A',
          'createdAt': FieldValue.serverTimestamp(),
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
                
                // Owner List - StreamBuilder
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('owner')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final docs = snapshot.data?.docs ?? [];
                      
                      // Filter by search query
                      final filteredDocs = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final name = (data['Name'] ?? '').toString().toLowerCase();
                        final search = _searchController.text.toLowerCase();
                        return name.contains(search);
                      }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final data = filteredDocs[index].data() as Map<String, dynamic>;
                          return _buildOwnerItem(data);
                        },
                      );
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
          color: AppColors.searchBarBg, // Changed to Grey
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.langar(color: Colors.black),
          decoration: InputDecoration(
            hintText: "SEARCH OWNER",
            hintStyle: GoogleFonts.langar(color: Colors.white),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerItem(Map<String, dynamic> data) {
    final name = data['Name'] ?? 'Unknown';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBrown, // Brownish background
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
                FadeRoute(page: OwnerDetailsScreen(ownerData: data)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.confirmButton, // Greenish
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
