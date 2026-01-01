import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_hotel_screen.dart';
import '../widgets/custom_bottom_nav.dart';

import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  final String hotelName;

  const HotelDetailScreen({
    super.key,
    required this.hotelName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF555E40),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "HOTEL DETAILS",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Langar',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 36,
              height: 36,
              child: Image.asset("assets/images/logo.png", fit: BoxFit.contain
              ),
              ),
            ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
    backgroundColor: const Color(0xFF555E40),
    child: const Icon(Icons.edit, color: Colors.white),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditHotelScreen(),
        ),
      );
    },
  ),
  // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  // bottomNavigationBar: const CustomBottomNav(),

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
              color: const Color(0xFF555E40).withOpacity(0.6), // Greenish overlay
            ),
          ),

          // 2. CONTENT
          Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4C19C),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2), // Matching the blue border in screenshot
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   // HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF775F4B),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        "HOTEL DETAILS MANAGEMENT",
                        style: GoogleFonts.langar(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // HOTEL NAME
                  Text(
                    hotelName.isEmpty ? "Aranyak Resort" : hotelName,
                    style: GoogleFonts.langar(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // IMAGE
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/hotel_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DETAILS
                  Column(
                    children: [
                      _detailRow("Resort Id", "1"),
                      _detailRow("Resort name", hotelName.isEmpty ? "Aranyak" : hotelName),
                      _detailRow("Resort Charge", "3200"),
                      _detailRow("Owner Name", "Rishi Bhatt"),
                      _detailRow("No. of safari booked", "5"), // New line split handled in row
                      _detailRow("No. of DOC booking", "2", isLast: true),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // BUTTONS
                  _buildActionButton("VIEW LOCATION"),
                  const SizedBox(height: 12),
                  _buildActionButton("CONTACT NOW"),

                  const SizedBox(height: 20),
                  
                  // EDIT FAB (Inside Card)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      mini: true,
                      heroTag: "edit_hotel_fab",
                      backgroundColor: const Color(0xFFD4C19C), // Match card bg? Or standard FAB color? Screenshot looks like transperant or light. 
                      // Actually screenshot shows a plus icon in a circle. User said edit button previously. 
                      // Wait, screenshot shows a (+) icon in bottom right.
                      // But effectively for "Edit hotel" usually it's edit icon.
                      // Let's stick to Edit Icon styled like the screenshot's button position.
                      // The screenshot shows a (+) button. 
                      // Previous screen had Edit FAB. 
                      // I will keep Edit functionality but style it nicely.
                      shape: const CircleBorder(side: BorderSide(color: Colors.black)),
                      elevation: 0,
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditHotelScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.add, color: Colors.black), // Using Add as per screenshot, but mapped to Edit Screen for now or maybe Add? 
                      // Context: This is "Hotel Details". Usually "Edit". 
                      // Screenshot has (+) icon. 
                      // I'll use (+) icon to match visual, but keep navigation to Edit for now or Add?
                      // The user said "more option which is in the left side of the ui".
                      // I will use Icon(Icons.add) to match the visual 100%. 
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _detailRow(String key, String value, {bool isLast = false}) {
     // Handling multi-line keys like "No. of safari\nbooked" if needed, 
     // but visual shows they are split.
     // "No. of safari"
     // "booked : 5"
     
     if (key.contains("safari")) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 children: [
                   SizedBox(width: 40), // Indent
                   Text(
                    "No. of safari",
                    style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   ),
                 ],
               ),
               Row(
                 children: [
                   SizedBox(width: 40),
                   Text(
                    "booked",
                     style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   ),
                   SizedBox(width: 40),
                   Text(
                     ": $value",
                     style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   )
                 ],
               )
            ],
          ),
        );
     }
      if (key.contains("DOC")) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 children: [
                   SizedBox(width: 40),
                   Text(
                    "No. of DOC",
                    style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   ),
                 ],
               ),
               Row(
                 children: [
                   SizedBox(width: 40),
                   Text(
                    "booking",
                     style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   ),
                   SizedBox(width: 32),
                   Text(
                     ": $value",
                     style: GoogleFonts.langar(fontWeight: FontWeight.bold, fontSize: 15),
                   )
                 ],
               )
            ],
          ),
        );
     }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 40), // Left Indentation
          SizedBox(
            width: 140, 
            child: Text(
              key,
              style: GoogleFonts.langar(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            ": $value",
            style: GoogleFonts.langar(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6A0), // Light Green
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent), // Soft look
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.1),
             blurRadius: 4,
             offset: const Offset(0, 2),
           )
        ]
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.langar(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: const Color(0xFF2E4F2F), // Dark Green text
          ),
        ),
      ),
    );
  }
}
