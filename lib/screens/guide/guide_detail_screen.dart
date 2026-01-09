import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../menu/menu_screen.dart';
import '../home/home_screen.dart';
import 'add_guide_screen.dart';
import 'edit_guide_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/fade_route.dart';
import '../../utils/app_colors.dart';


class GuideDetailApp extends StatelessWidget {
  const GuideDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Visual match for Olive Green
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appGreen),
        textTheme: GoogleFonts.langarTextTheme(),
      ),
      home: const GuideDetailScreen(),
    );
  }
}

class GuideDetailScreen extends StatefulWidget {
  const GuideDetailScreen({super.key});

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- COLORS ---
  // --- COLORS ---
  static const Color appGreen = AppColors.appGreen; // Updated Olive Green
  static const Color mustardYellow = AppColors.highlightOrange; // Search Bar
  static const Color darkBrown = AppColors.buttonBrown; // List Items / Text / Icons
  static const Color lightBeige = AppColors.inputBg; // FAB Background
  
  // Nav Bar Colors
  static const Color navSelectedOuter = Colors.white;
  static const Color navSelectedInner = AppColors.activeNavGold; // Gold/Yellow
  static const Color navUnselected = AppColors.navIconBg; // Grey

  int _selectedIndex = 1; // Default to Home (Center)

  void _onItemTapped(int index) {
    if (index == 0) {
      _scaffoldKey.currentState?.openDrawer();
    } else if (index == 1) {
       Navigator.pushAndRemoveUntil(
        context,
        FadeRoute(page: HomeScreen()),
        (route) => false, // Remove all back stack to make Home the root
      );
    } else if (index == 2) {
       _scaffoldKey.currentState?.openEndDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToAddGuide() {
    Navigator.push(
      context,
      FadeRoute(page: const AddGuideScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
             backgroundColor: Colors.transparent, 
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                   Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        title: Text(
          "GUIDE’s DETAIL", 
          style: GoogleFonts.langar( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, 
          ),
        ),
        centerTitle: false, 
        titleSpacing: 0, 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30, 
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/images/logo.png'),
            ),
          )
        ],
        elevation: 0,
       ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. BACKGROUND
          Container(
             decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/landing_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: AppColors.appGreen.withOpacity(0.6), // Greenish overlay
            ),
          ),

          // 2. CONTENT COLUMN
          Column(
            children: [
              const SizedBox(height: 16),
              
              // SEARCH BAR
              Container(
                width: 300,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white, // Changed to White
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white, width: 2), // Added border
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.langar( 
                          color: Colors.black, // Changed to Black
                          fontWeight: FontWeight.w600
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Guide No.",
                          hintStyle: GoogleFonts.langar( 
                            color: Colors.black, // Changed to Black
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.black), // Changed to Black
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // GUIDE LIST
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('guides')
                      .orderBy('createdAt', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: darkBrown));
                    }

                    final data = snapshot.requireData;
                    
                    if (data.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No guides found",
                          style: GoogleFonts.langar(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    // Client-side sort to ensure "1, 2, 10" order (Numeric) instead of "1, 10, 2" (String)
                    final sortedDocs = List.of(data.docs);
                    sortedDocs.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        
                        final String strA = dataA['guideNo']?.toString() ?? '0';
                        final String strB = dataB['guideNo']?.toString() ?? '0';

                        final int? numA = int.tryParse(strA);
                        final int? numB = int.tryParse(strB);

                        if (numA != null && numB != null) {
                          return numA.compareTo(numB);
                        } else {
                          return strA.compareTo(strB);
                        }
                    });

                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 10, bottom: 100),
                      itemCount: sortedDocs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = sortedDocs[index];
                        final guideData = doc.data() as Map<String, dynamic>;
                        final String displayGuideNo = guideData['guideNo'] ?? 'Unknown'; 
                        
                        final int guideNum = int.tryParse(displayGuideNo) ?? 0;

                        return Center(
                          child: Container(
                            width: 300,
                            height: 44,
                            decoration: BoxDecoration(
                              color: darkBrown,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Guide No. $displayGuideNo",
                                  style: GoogleFonts.langar(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      FadeRoute(
                                        page: EditGuideScreen(guideNumber: guideNum),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/edit_icon.png',
                                    width: 20, 
                                    height: 20,
                                    color: Colors.white, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          Positioned(
            right: 16,
            bottom: 16, 
            child: SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                onPressed: _navigateToAddGuide,
                backgroundColor: lightBeige,
                elevation: 4,
                shape: const CircleBorder(), 
                child: const Icon(
                  Icons.add, 
                  color: darkBrown, 
                  size: 28, 
                ),
              ),
            ),
          ),
        ],
      ),
      
      bottomNavigationBar: Container(
        height: 100, // Increased from 72
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

  Widget _buildNavItem(int index, String assetPath) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 70 : 60, // Increased from 50 to 60
        height: isSelected ? 70 : 60, // Increased from 50 to 60
        padding: isSelected ? const EdgeInsets.all(6) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? navSelectedOuter : navUnselected,
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
            color: isSelected ? navSelectedInner : Colors.transparent,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8), // Reduced padding from 12 to 8 for larger icon
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
           ),
        ),
      ),
    );
  }
}
