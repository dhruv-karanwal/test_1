import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hotel_detail_screen.dart';
import 'edit_hotel_screen.dart';
import 'add_hotel_screen.dart';
import '../widgets/custom_bottom_nav.dart';


import '../menu/menu_screen.dart';
import '../transaction/transaction_screen.dart';
import '../../utils/fade_route.dart';
import '../../utils/app_colors.dart';

class HotelListScreen extends StatelessWidget {
  HotelListScreen({super.key});

  final List<Map<String, String>> hotels = [
    {
      "name": "Aranyak Resort",
      "rating": "4.5",
      "contact": "+91 9876543210",
      "distance": "2.5 km",
    },
    {
      "name": "Tiger Trails Resort",
      "rating": "4.3",
      "contact": "+91 9823456712",
      "distance": "3.1 km",
    },
    {
      "name": "Bagh Sarai Jungle Lodge",
      "rating": "4.6",
      "contact": "+91 9765432189",
      "distance": "4.0 km",
    },
    {
      "name": "Nature Heritage Resort",
      "rating": "4.2",
      "contact": "+91 9890123456",
      "distance": "5.2 km",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(),
      endDrawer: TransactionScreen(),
      extendBodyBehindAppBar: false, // Changed to false so body starts below opaque AppBar
      appBar: AppBar(
        backgroundColor: AppColors.appGreen,
        elevation: 0,
        toolbarHeight: 93, // Match other screens
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "BANDHAVGARH SAFARI",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Langar',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
           Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 24, // Consistent size
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/images/logo.png'), 
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add_hotel_fab",
        backgroundColor: AppColors.highlightOrange, // High visibility
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            FadeRoute(
              page: const AddHotelScreen(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: const CustomBottomNav(),

      body: Stack(
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
              color: AppColors.appGreen.withOpacity(0.6), // Greenish overlay to match Home
            ),
          ),

          // 2. CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                width: double.infinity, // Take full width available
                // height: auto (Flexible via Column/Expanded)
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBrown.withOpacity(0.9), // Slightly transparent/darker
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9A648), // Gold/Mustard
                      borderRadius: BorderRadius.circular(30), // More rounded
                      border: Border.all(color: Colors.white, width: 1.5), // White border
                    ),
                    child: Center(
                      child: Text(
                        "HOTEL DETAILS MANAGEMENT",
                        style: GoogleFonts.langar(
                          color: Colors.black, // Black text
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 16), // Increased spacing
                  
                  TextField(
                    style: GoogleFonts.langar(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "SEARCH HOTEL", // Uppercase
                      hintStyle: GoogleFonts.langar(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search, color: Colors.black, size: 28), // Bold/Black icon
                      filled: true,
                      fillColor: Colors.white, // Changed to White
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent), // No border or maybe thin?
                      ),
                      enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30),
                         borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(30),
                         borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 12),
          
                  // 🔹 HOTEL SUB-CARDS LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotels[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(10),
                          height: 145,
                          decoration: BoxDecoration(
                            color: AppColors.activeNavGold, // Gold/Orange for items?
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black, width: 1),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/hotel_placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      hotel["name"]!.toUpperCase(),
                                      style: GoogleFonts.langar(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    _buildInfoText("RATING ${hotel["rating"]} *****"),
                                    _buildInfoText("CONTACT - ${hotel["contact"]}"),
                                    _buildInfoText("DISTANCE - ${hotel["distance"]}"),
                                    
                                    Row(
                                      children: [
                                         GestureDetector(
                                           onTap: () {
                                              Navigator.push(
                                                  context,
                                                  FadeRoute(
                                                  page: const HotelDetailScreen(hotelName: '',),
                                                  ),
                                                );
                                           },
                                           child: Container(
                                             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                             decoration: BoxDecoration(
                                                color: AppColors.buttonBrown,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.black),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  )
                                                ]
                                             ),
                                             child: Text(
                                               "MORE",
                                               style: GoogleFonts.langar(
                                                 color: Colors.white,
                                                 fontSize: 12,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                         ),
                                         const Spacer(),
                                         GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                FadeRoute(
                                                page: const EditHotelScreen(),
                                                ),
                                              );
                                            },
                                            child: const Icon(Icons.edit_square, color: Colors.black, size: 24),
                                         ),
                                         const SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.langar(
        color: Colors.white,
        fontSize: 11,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
