import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // Sorting
  bool _sortByDateDesc = true;
  String _sortOption = "DATE"; // DATE or VALUE

  // Colors
  static const Color appGreen = Color(0xFF555E40);
  static const Color headerBrown = Color(0xFFC1A87D); // Approximate from screenshot
  static const Color cardGreen = Color(0xFF0F4C3A); // Dark green for card bg
  static const Color amountGreen = Color(0xFF7CFC00); // Bright green text
  static const Color successGreen = Color(0xFF7CFC00); // "SUCCESS" text
  static const Color backgroundGreen = Color(0xFFD4C19C); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: backgroundGreen,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
             const Text(
              "BANDHAVGARH SAFARI",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
             const SizedBox(width: 8),
            Image.asset('assets/logo.png', height: 30),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header
         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: headerBrown,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Center(
                child: Text(
                  "TRANSACTION HISTORY",
                  style: GoogleFonts.langar(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Date & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  icon: const Icon(Icons.filter_alt, color: Colors.black),
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
                    const PopupMenuItem(value: 'DATE', child: Text("SORT BY DATE")),
                    const PopupMenuItem(value: 'VALUE', child: Text("SORT BY VALUE")),
                  ],
                  // Customizing popup based on screenshot roughly
                  color: headerBrown, 
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
                  return const Center(child: Text("No transactions yet.", style: TextStyle(color: Colors.white)));
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
                     // Sort by Value (amount)
                     double amountA = double.tryParse(dataA['amount'].toString()) ?? 0;
                     double amountB = double.tryParse(dataB['amount'].toString()) ?? 0;
                     return amountB.compareTo(amountA); // Descending by default for value
                  }
                });


                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                     var data = docs[index].data() as Map<String, dynamic>;
                     return TransactionCard(data: data);
                  },
                );
              },
            ),
          ),
          
          // Bottom Navigation (Placeholder matching other screens)
          // Optional: Reuse bottom nav if needed or just leave as is since it's a sub-screen. 
          // Design screenshots shows it.
           Container(
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
                _buildNavItem('assets/nav_menu.png'),
                _buildNavItem('assets/nav_home_new.png'), // Active logic ignored for now
                _buildNavItem('assets/transaction.png'), 
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath) {
    // Simplified Nav Item
     return Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12),
        child: Image.asset(assetPath, fit: BoxFit.contain),
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

    String name = widget.data['payerName'] ?? "Unknown";
    String description = widget.data['description'] ?? "No Details";
    String amount = widget.data['amount']?.toString() ?? "0";
    String transactionId = widget.data['transactionId'] ?? "N/A";
    Timestamp? ts = widget.data['timestamp'];
    String timeStr = ts != null ? DateFormat('hh:mm a').format(ts.toDate()) : "--:--";
    String mode = widget.data['mode'] ?? "UPI";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1),
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
          // Top Row: Name + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.toUpperCase(),
                style: GoogleFonts.langar(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                 decoration: BoxDecoration(
                   color: buttonColor.withOpacity(0.3), // Faint bg behind amount
                   borderRadius: BorderRadius.circular(4),
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
            ],
          ),
          const SizedBox(height: 4),

          // Second Row: Description + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                description,
                 style: GoogleFonts.langar(
                  color: textColor.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
               Text(
                "SUCCESS",
                style: GoogleFonts.langar(
                  color: amountColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Expansion
          if (_expanded) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white24),
            Text("TRANSACTION ID: $transactionId", style: GoogleFonts.langar(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("TIME: $timeStr", style: GoogleFonts.langar(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("MODE: $mode", style: GoogleFonts.langar(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 12),
             Center(
               child: ElevatedButton(
                onPressed: () {
                    setState(() {
                      _expanded = false;
                    });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text("CLOSE DETAILS", style: GoogleFonts.langar(fontWeight: FontWeight.bold)),
              ),
             ),
          ] else ...[
             const SizedBox(height: 8),
             Center(
               child: GestureDetector(
                 onTap: () {
                   setState(() {
                     _expanded = true;
                   });
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                   decoration: BoxDecoration(
                     color: buttonColor,
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Text(
                     "GET MORE DETAILS",
                     style: GoogleFonts.langar(
                       color: Colors.black,
                       fontSize: 10,
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
}
