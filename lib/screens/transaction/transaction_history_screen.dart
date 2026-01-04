import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../home/home_screen.dart';
import '../menu/menu_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/fade_route.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sorting
  bool _sortByDateDesc = true;
  String _sortOption = "DATE"; // DATE or VALUE

  // Colors
  // Colors
  static const Color appGreen = AppColors.appGreen; // Standard App Green
  static const Color headerBrown = AppColors.highlightOrange; // Gold/Beige Header
  static const Color cardGreen = AppColors.headerGreen; // Deep Green for cards
  static const Color amountGreen = Color(0xFF7CFC00); // Bright Green for amounts/success, leaving as specific detail
  static const Color backgroundGreen = Color(0xFFE3D5C0); // Beige/Tan background, possibly can stay or match appGreen? keeping for now.
  
  // Nav Colors
  static const Color activeNavInner = AppColors.activeNavGold; // Gold/Yellow
  static const Color activeNavOuter = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundGreen,
      drawer: const MenuScreen(),
      appBar: AppBar(
        automaticallyImplyLeading: false, // We use custom leading
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              FadeRoute(page: HomeScreen()),
              (route) => false,
            );
          },
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        title: Row(
          children: [
             Text(
              "BANDHAVGARH SAFARI",
              style: GoogleFonts.langar(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/images/logo.png'), 
            ),
          ),
        ],
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

          // 2. CONTENT - Wrapped in Column
          Column(
            children: [
              // Header "TRANSACTION HISTORY"
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: headerBrown,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                      )
                    ]
                  ),
                  child: Center(
                    child: Text(
                      "TRANSACTION HISTORY",
                      style: GoogleFonts.langar(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // Date & Filter Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('dd MMMM yyyy :').format(DateTime.now()).toUpperCase(),
                      style: GoogleFonts.langar(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    PopupMenuButton<String>(
                      child: const Icon(Icons.filter_alt, color: Colors.black, size: 28),
                      onSelected: (value) {
                        setState(() {
                          if (value == 'DATE') {
                            _sortOption = 'DATE';
                            _sortByDateDesc = !_sortByDateDesc;
                          } else if (value == 'VALUE') {
                            _sortOption = 'VALUE';
                          }
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'DATE', child: Text("Sort by Date")),
                        const PopupMenuItem(value: 'VALUE', child: Text("Sort by Value")),
                      ],
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                       return const Center(child: Text("No transactions yet.", style: TextStyle(color: Colors.black)));
                    }

                    List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                    // Sorting Logic
                    docs.sort((a, b) {
                      Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
                      Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;

                      if (_sortOption == 'DATE') {
                        Timestamp tA = dataA['timestamp'] ?? Timestamp.now();
                        Timestamp tB = dataB['timestamp'] ?? Timestamp.now();
                        return _sortByDateDesc ? tB.compareTo(tA) : tA.compareTo(tB);
                      } else {
                         double amountA = double.tryParse(dataA['amount'].toString()) ?? 0;
                         double amountB = double.tryParse(dataB['amount'].toString()) ?? 0;
                         return amountB.compareTo(amountA);
                      }
                    });

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                         var data = docs[index].data() as Map<String, dynamic>;
                         return TransactionCard(data: data);
                      },
                    );
                  },
                ),
              ),
              
              // Bottom Navigation
               Container(
                height: 100, // Matches HomeScreen
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
                    _buildUnselectedNavItem(context, 'assets/images/nav_menu.png', 0),
                    
                    _buildUnselectedNavItem(context, 'assets/images/nav_home_new.png', 1),

                    // Transaction (Selected)
                    GestureDetector(
                      onTap: () {}, // Already here
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: activeNavOuter,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: activeNavInner,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/transaction.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnselectedNavItem(BuildContext context, String assetPath, int index) {
     return GestureDetector(
      onTap: () {
        if (index == 0) {
             // Open Drawer
             _scaffoldKey.currentState?.openDrawer();
             // Note: If using endDrawer for transaction in standard flow, menu is standard drawer.
        } else if (index == 1) {
             // Go Home
             Navigator.pushAndRemoveUntil(
                context,
                FadeRoute(page: HomeScreen()),
                (route) => false,
             );
        }
      },
      child: Container(
        width: 60, 
        height: 60, 
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
         padding: const EdgeInsets.all(8), 
         child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
      ),
    );
  }
}

class TransactionCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const TransactionCard({super.key, required this.data});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    // Colors
    const Color cardBg = Color(0xFF0F4C3A); // Deep Green
    const Color amountColor = Color(0xFF7CFC00); // Bright Green
    const Color textColor = Colors.white;
    const Color buttonColor = Color(0xFFD4C19C); // Beige/Gold

    String name = widget.data['payerName'] ?? "UNKNOWN";
    String description = widget.data['description'] ?? "No Details";
    String amount = widget.data['amount']?.toString() ?? "0";
    String transactionId = widget.data['transactionId'] ?? "ABCDEFGHI"; 
    Timestamp? ts = widget.data['timestamp'];
    String timeStr = ts != null ? DateFormat('hh:mm a').format(ts.toDate()) : "04:08 PM";
    String mode = widget.data['mode'] ?? "UPI";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.headerGreen,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.5),
         boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Name + Amount Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: GoogleFonts.langar(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description.toUpperCase(),
                       style: GoogleFonts.langar(
                        color: textColor.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                     decoration: BoxDecoration(
                       color: const Color(0xFF8FBC8F).withOpacity(0.5), // Semi-transparent green
                       borderRadius: BorderRadius.circular(20),
                     ),
                    child: Text(
                      "+$amount/-",
                      style: GoogleFonts.langar(
                        color: amountColor, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                   if (!_expanded)
                   Padding(
                     padding: const EdgeInsets.only(top: 4.0),
                     child: Text(
                      "SUCCESS",
                      style: GoogleFonts.langar(
                        color: amountColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                     ),
                   ),
                ],
              ),
            ],
          ),

          // Expansion content
          if (_expanded) ...[
             const SizedBox(height: 16),
            _buildDetailRow("TRANSACTION ID:", transactionId, textColor),
            _buildDetailRow("TIME:", timeStr, textColor),
            _buildDetailRow("MODE:", mode, textColor),
            
             const SizedBox(height: 16),
             Center(
              child: SizedBox(
                height: 30, // Small button
                child: ElevatedButton(
                  onPressed: () {
                      setState(() {
                        _expanded = false;
                      });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("CLOSE DETAILS", style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
             ),
          ] else ...[
             const SizedBox(height: 12),
             Center(
               child: GestureDetector(
                 onTap: () {
                   setState(() {
                     _expanded = true;
                   });
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                   decoration: BoxDecoration(
                     color: buttonColor,
                     borderRadius: BorderRadius.circular(20),
                   boxShadow: const [
                       BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0,2))
                     ]
                   ),
                   child: Text(
                     "GET MORE DETAILS",
                     style: GoogleFonts.langar(
                       color: Colors.black,
                       fontSize: 12,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ),
             ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            "$label ",
            style: GoogleFonts.langar(
              color: color, 
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
             style: GoogleFonts.langar(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
