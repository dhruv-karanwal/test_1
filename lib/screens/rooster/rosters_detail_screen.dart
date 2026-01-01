import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_roster_screen.dart'; // Import to enable navigation to AddRosterScreen
import 'edit_roster_screen.dart'; // Import for EditRosterScreen
import '../menu/menu_screen.dart';
import '../home/home_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/slide_route.dart';
import '../../utils/fade_route.dart';



class RosterDetailApp extends StatelessWidget {
  const RosterDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Visual match for Olive Green
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF555E40)),
        textTheme: GoogleFonts.langarTextTheme(), // Updated to Langar as requested
      ),
      home: const RosterDetailScreen(),
    );
  }
}

class RosterDetailScreen extends StatefulWidget {
  const RosterDetailScreen({super.key});

  @override
  State<RosterDetailScreen> createState() => _RosterDetailScreenState();
}

class _RosterDetailScreenState extends State<RosterDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // --- COLORS ---
  static const Color appGreen = Color(0xFF555E40); // Updated Olive Green
  static const Color mustardYellow = Color(0xFFE4C939); // Search Bar
  static const Color darkBrown = Color(0xFF4E342E); // List Items / Text / Icons
  static const Color lightBeige = Color(0xFFF5F5DC); // FAB Background
  
  // Nav Bar Colors
  static const Color navSelectedOuter = Colors.white;
  static const Color navSelectedInner = Color(0xFFD4AF37); // Gold/Yellow
  static const Color navUnselected = Color(0xFFD9D9D9); // Grey

  int _selectedIndex = 1; // Default to Home (Center)

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

  void _navigateToAddRoster() {
    Navigator.push(
      context,
      FadeRoute(page: const AddRosterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 360x800 logical pixels reference
    // Using simple responsive techniques (standard widgets) 
    // to fit within the screen.

    return Scaffold(
      key: _scaffoldKey,
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: false, // App bar is solid/opaque in design usually, but description says "Background color: Olive green". 
      // Background image is "Full screen". If we want full screen background behind appbar, we need extendBodyBehindAppBar: true.
      // However, App bar has a specific color "Olive green". If it's opaque, the background image won't show behind it.
      // Re-reading: "Background: Full screen forest / safari texture... Use DecorationImage BoxFit.cover". 
      // "App Bar... Background color: Olive green".
      // This implies the App Bar is opaque Olive Green, and the BODY has the forest texture.
      // OR the whole screen has the texture and App Bar is transparent? 
      // Usually "Background color: Olive green" means opaque. 
      // I will make App Bar opaque Olive Green and the Body have the background.
      
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
             // No background specified for button itself, just "Circular back button". 
             // Usually implies a wrapper or just the icon. 
             // But "Circular back button" + "Icon: Icons.arrow_back" likely means standard IconButton or contained.
             // Looking at AddRosterScreen: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2)...)
             // I'll stick to a clean look.
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
          "ROSTER’s DETAIL", // Lowercase 's', others caps
          style: GoogleFonts.langar( 
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, 
          ),
        ),
        centerTitle: false, // "slightly left-center"
        titleSpacing: 0, // Reduces default padding to move it slightly left
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30, // Increased size
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
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color(0xFF555E40).withOpacity(0.6), // Greenish overlay matches Home
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
                  color: mustardYellow,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white, width: 2), // Added border
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.langar( // Explicit Langar
                          color: darkBrown, 
                          fontWeight: FontWeight.w600
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Roster No.",
                          hintStyle: GoogleFonts.langar( // Explicit Langar
                            color: darkBrown,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: darkBrown),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // ROSTER LIST
              // Flexible/Expanded to take remaining space
              // ROSTER LIST - DYNAMIC FROM FIRESTORE
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('roosters')
                      // Sort by createdAt so newest appear last (or first, prompt implies "No. 1...8", let's order by something stable or rosterNo)
                      // User might want numerical order? "roosterNo" is string in schema. 
                      // Simple sort for now:
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
                          "No rosters found",
                          style: GoogleFonts.langar(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    // Client-side sort to ensure "1, 2, 10" order (Numeric) instead of "1, 10, 2" (String)
                    // We create a modifiable copy of the list
                    final sortedDocs = List.of(data.docs);
                    sortedDocs.sort((a, b) {
                        final dataA = a.data() as Map<String, dynamic>;
                        final dataB = b.data() as Map<String, dynamic>;
                        
                        final String strA = dataA['roosterNo']?.toString() ?? '0';
                        final String strB = dataB['roosterNo']?.toString() ?? '0';

                        // Try parsing as int for numeric sort, fallback to string sort
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
                        final roosterData = doc.data() as Map<String, dynamic>;
                        // Use saved "roosterNo" or fallback
                        final String displayRosterNo = roosterData['roosterNo'] ?? 'Unknown'; 
                        
                        // Parse roster number for Edit Screen navigation (assuming it's int parsable, else fallback)
                        final int rosterNum = int.tryParse(displayRosterNo) ?? 0;

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
                                  "Roster No. $displayRosterNo",
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
                                        page: EditRosterScreen(rosterNumber: rosterNum),
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

          // 3. FAB (Positioned manually or via Scaffold - prompt says "Positioned bottom right, above bottom nav")
          // Since Nav Bar is in 'bottomNavigationBar', standard FAB location works relative to it.
          // But "Use Stack -> background + content" implies we manage it. 
          // However, standard Scaffold FAB + BottomNav is easiest and most robust.
          // "No hardcoded absolute positioning except FAB offset" -> implies manual positioning might be requested?
          // "Positioned bottom right, above bottom nav" -> Scaffold does this automatically with defined locations.
          // But let's follow the Stack instruction strictly if needed.
          // "Layout Structure: Stack -> background + content ... ListView -> roster items ... No hardcoded absolute positioning except FAB offset".
          // This suggests `Positioned` widget for FAB inside the Stack.
          
          Positioned(
            /* 
              Positioned bottom right, above bottom nav. 
              Since Nav Bar is in 'bottomNavigationBar' property of Scaffold, the body ends above it.
              So 'bottom: 16' here is relative to the bottom of the body, which is just above the nav bar.
            */
            right: 16,
            bottom: 16, 
            child: SizedBox(
              width: 48,
              height: 48,
              child: FloatingActionButton(
                onPressed: _navigateToAddRoster,
                backgroundColor: lightBeige,
                elevation: 4,
                shape: const CircleBorder(), // Circular
                child: const Icon(
                  Icons.add, 
                  color: darkBrown, 
                  size: 28, 
                  // "Thick stroke" -> Material icons add is standard. 
                  // Could use Cupertino or FontAwesome, but Icons.add is requested.
                  // We can increase size/weight if needed, but Icons.add is standard.
                ),
              ),
            ),
          ),
        ],
      ),
      
      // BOTTOM NAVIGATION BAR
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

  // Helper for Nav Items (Same as AddRosterScreen)
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
