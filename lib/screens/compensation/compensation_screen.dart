import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/shared_ui.dart';

class CompensationScreen extends StatefulWidget {
  const CompensationScreen({super.key});

  @override
  State<CompensationScreen> createState() => _CompensationScreenState();
}

class _CompensationScreenState extends State<CompensationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data to match the screenshot
  final List<Map<String, dynamic>> roosters = [
    {'name': 'ROOSTER 12', 'selected': false},
    {'name': 'ROOSTER 14', 'selected': false},
    {'name': 'ROOSTER 22', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: buildCommonAppBar(context),
      drawer: const SizedBox.shrink(), // Add drawer if needed or reuse MenuScreen
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
                // COMPENSATION Banner
                _buildBanner("COMPENSATION"),
                
                const SizedBox(height: 20),
                
                // Stats Card
                _buildStatsCard(),
                
                const SizedBox(height: 20),
                
                // Compensations Section
                Text(
                  "COMPENSATIONS - 03",
                  style: GoogleFonts.langar(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Roster List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: roosters.length,
                    itemBuilder: (context, index) {
                      return _buildRosterItem(index);
                    },
                  ),
                ),
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
      width: 300,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFD9A648),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.langar(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
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
          Text(
            "TOTAL SESSION BOOKINGS:",
            style: GoogleFonts.langar(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow("MORNING : 67"),
          const SizedBox(height: 12),
          _buildStatRow("EVENING : 00"),
          const SizedBox(height: 16),
          Text(
            "TOPPER NO. FOR NEXT SESSION",
            style: GoogleFonts.langar(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildTopperBox("68"),
        ],
      ),
    );
  }

  Widget _buildStatRow(String text) {
    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.langar(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTopperBox(String text) {
    return Container(
      width: 80,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.langar(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRosterItem(int index) {
    bool selected = roosters[index]['selected'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF8C9F4E), // Greenish background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roosters[index]['name'],
                style: GoogleFonts.langar(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    roosters[index]['selected'] = !selected;
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF2E4028) : const Color(0xFFD9D9D9),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: selected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              ),
            ],
          ),
          if (selected) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement save logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved for ${roosters[index]['name']}")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E4028),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.black, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text(
                "CONFIRM AND SAVE",
                style: GoogleFonts.langar(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
