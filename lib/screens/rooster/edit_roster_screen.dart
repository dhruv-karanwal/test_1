import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRosterScreen extends StatefulWidget {
  final int rosterNumber; // Receive roster number
  
  const EditRosterScreen({super.key, required this.rosterNumber});

  @override
  State<EditRosterScreen> createState() => _EditRosterScreenState();
}

class _EditRosterScreenState extends State<EditRosterScreen> {
  // Colors extracted/approximated from description
  static const Color appGreen = Color(0xFF555E40); // Updated Olive Green
  static const Color cardBackground = Color(0xCC5E4B35); // Semi-transparent brown/olive
  static const Color headerGreen = Color(0xFF3A4F1F); // Darker green strip
  static const Color inputBackground = Color(0xFFF5F5F0); // Off-white
  static const Color saveButtonGreen = Color(0xFF7CFC00); // Bright green
  static const Color saveButtonText = Color(0xFF006400); // Dark green
  static const Color editButtonOrange = Color(0xFFFFA07A); // Salmon/Orange for Edit
  static const Color qrPlaceholder = Color(0xFFE0E0E0); // Light grey

  // State for document ID to update existing record
  String? _docId;
  bool _isLoading = true;

  // Controllers
  final TextEditingController _rosterNoController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();

  bool _isSaving = false;
  int _selectedIndex = 1; // Default to Home (Center)

  // New Fields
  int _capacity = 6;
  final List<int> _capacityOptions = [6, 8];

  String _rosterStatus = "Available";
  final List<String> _statusOptions = ["Available", "Unavailable"];


  @override
  void initState() {
    super.initState();
    // Pre-fill roster number immediately
    _rosterNoController.text = widget.rosterNumber.toString();
    _fetchRosterData();
  }

  Future<void> _fetchRosterData() async {
    setState(() { _isLoading = true; });
    try {
      final rosterNumStr = widget.rosterNumber.toString();
      
      // 1. Try to get by Document ID directly (New Standard)
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('roosters')
          .doc(rosterNumStr)
          .get();

      if (!doc.exists) {
        // 2. Fallback: Query by field in case it was saved with random ID previously
        final querySnapshot = await FirebaseFirestore.instance
            .collection('roosters')
            .where('roosterNo', isEqualTo: rosterNumStr)
            .limit(1)
            .get();
        
        if (querySnapshot.docs.isNotEmpty) {
          doc = querySnapshot.docs.first;
        }
      }

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _docId = doc.id; // Store found ID (could be "1" or "8vB...")
          _driverNameController.text = data['driverName'] ?? '';
          _ownerNameController.text = data['ownerName'] ?? '';
          _driverPhoneController.text = data['driverPhone'] ?? '';
          _ownerPhoneController.text = data['ownerPhone'] ?? '';
          
          if(data['capacity'] != null && data['capacity'] is int) {
             _capacity = data['capacity'];
             if(!_capacityOptions.contains(_capacity)) _capacity = 6; // Fallback
          }

          if(data['status'] != null && data['status'] is String) {
            _rosterStatus = data['status'];
            if(!_statusOptions.contains(_rosterStatus)) _rosterStatus = "Available"; // Fallback
          } else {
             // Fallback if status not present, map from availability bool
             if(data['availability'] == false) _rosterStatus = "Unavailable";
          }

        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
       setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _rosterNoController.dispose();
    _driverNameController.dispose();
    _ownerNameController.dispose();
    _driverPhoneController.dispose();
    _ownerPhoneController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    debugPrint("Selected index: $index");
  }

  Future<void> _saveRoster() async {
    setState(() { _isSaving = true; });

    try {
      final Map<String, dynamic> rosterData = {
        'availability': _rosterStatus == "Available",
        'status': _rosterStatus,
        'capacity': _capacity,
        'docDrivers': 1,
        'driverName': _driverNameController.text,
        'driverPhone': _driverPhoneController.text,
        'licensePlate': _rosterNoController.text,
        'roosterNo': _rosterNoController.text,
        'ownerName': _ownerNameController.text,
        'ownerPhone': _ownerPhoneController.text,
        'totalDrivers': 1,
        // Only set createdAt if we are creating a fresh doc OR if it doesn't exist? 
        if (_docId == null) 'createdAt': FieldValue.serverTimestamp(),
      };
      
      final targetDocId = _rosterNoController.text;

      await FirebaseFirestore.instance
            .collection('roosters')
            .doc(targetDocId)
            .set(rosterData, SetOptions(merge: true)); // Merge updates if exists, creates if not

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Roster updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating roster: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 93,
        backgroundColor: appGreen,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        title: Text(
          "ROSTER NO. ${widget.rosterNumber}", // Dynamic Title
          style: GoogleFonts.langar(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false, 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 30, 
              backgroundImage: const AssetImage(
                 'assets/images/logo.png', 
              ), 
              backgroundColor: Colors.white,
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0), 
            bottomRight: Radius.circular(0),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/background.png',
                ), 
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: const Color(0xFF555E40).withOpacity(0.6),
            ),
          ),

          // MAIN CONTENT
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 160.0, bottom: 20.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // FORM CONTAINER
                    Container(
                      width: 310,
                      constraints: const BoxConstraints(minHeight: 560),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                           Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: headerGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "DETAILS",
                              style: TextStyle(
                                color: Colors.black, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),

                          // INPUT FIELDS
                          _buildInputField("ROSTER NO.", controller: _rosterNoController),
                          const SizedBox(height: 12),
                          _buildInputField("DRIVER NAME", controller: _driverNameController),
                          const SizedBox(height: 12),
                          
                          Row(
                            children: [
                               Expanded(
                                child: _buildDropdown(
                                  label: "CAPACITY",
                                  value: _capacity,
                                  items: _capacityOptions,
                                  onChanged: (val) {
                                    if(val != null) setState(() => _capacity = val);
                                  }
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDropdown(
                                  label: "STATUS",
                                  value: _rosterStatus,
                                  items: _statusOptions,
                                  onChanged: (val) {
                                    if(val != null) setState(() => _rosterStatus = val);
                                  }
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          _buildInputField("OWNER NAME", controller: _ownerNameController),
                          const SizedBox(height: 16),

                          // QR CODE SECTION
                          Text(
                            "QR CODE",
                            style: GoogleFonts.langar(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: qrPlaceholder,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/images/qr_code.png', fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // PHONE NUMBER FIELDS
                          _buildInputField("DRIVER NUMBER", isPhone: true, controller: _driverPhoneController),
                          const SizedBox(height: 12),
                          _buildInputField("OWNER NUMBER", isPhone: true, controller: _ownerPhoneController),
                          const SizedBox(height: 24),

                          // BUTTONS ROW (Save & Edit)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space them out
                            children: [
                              // SAVE BUTTON
                              SizedBox(
                                width: 120,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveRoster,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: saveButtonGreen,
                                    foregroundColor: saveButtonText,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: _isSaving 
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: saveButtonText, strokeWidth: 2))
                                    : Text(
                                    "Save",
                                    style: GoogleFonts.langar(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // EDIT BUTTON
                              SizedBox(
                                width: 120,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle Edit action
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Edit mode enabled')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: editButtonOrange, // Orange color
                                    foregroundColor: Colors.brown, // Dark text color for contrast
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    "Edit",
                                    style: GoogleFonts.langar(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
            _buildNavItem(0, 'assets/images/nav_menu.png'),
            _buildNavItem(1, 'assets/images/nav_home_new.png'), 
            _buildNavItem(2, 'assets/images/transaction.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required T value, required List<T> items, required ValueChanged<T?> onChanged}) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: inputBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
             icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            selectedItemBuilder: (BuildContext context) {
              return items.map<Widget>((T item) {
                return Align(
                   alignment: Alignment.centerLeft,
                    child: Text(
                    "$item", // Primitive toString
                    style: GoogleFonts.langar(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList();
            },
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  "$item",
                  style: GoogleFonts.langar(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text(
              label,
               style: GoogleFonts.langar(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 12, 
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildInputField(String hint, {bool isNumeric = false, bool isPhone = false, required TextEditingController controller}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: inputBackground, // Using same background as Add screen
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 12, right: 12), 
      child: TextField(
        controller: controller,
        keyboardType: isNumeric
            ? TextInputType.number
            : (isPhone ? TextInputType.phone : TextInputType.text),
        style: GoogleFonts.langar(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.langar(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 12, 
          ),
          contentPadding: const EdgeInsets.only(bottom: 2), 
          isDense: true, 
        ),
      ),
    );
  }

   Widget _buildNavItem(int index, String assetPath) {
    bool isSelected = _selectedIndex == index;
    
    // Style constants
    const Color selectedOuterColor = Colors.white;
    const Color selectedInnerColor = Color(0xFFD4AF37); 
    const Color unselectedColor = Color(0xFFD9D9D9); 
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 70 : 50,
        height: isSelected ? 70 : 50,
        padding: isSelected ? const EdgeInsets.all(6) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isSelected ? selectedOuterColor : unselectedColor,
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
            color: isSelected ? selectedInnerColor : Colors.transparent, 
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
