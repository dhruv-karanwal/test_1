import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../services/slot_availability_service.dart';

class SlotControlDialog extends StatefulWidget {
  const SlotControlDialog({super.key});

  @override
  State<SlotControlDialog> createState() => _SlotControlDialogState();
}

class _SlotControlDialogState extends State<SlotControlDialog> {
  final SlotAvailabilityService _service = SlotAvailabilityService.instance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.inputBg,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Slot Controls",
              style: GoogleFonts.langar(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.appGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: _service.isMorningSlotsOpen,
              builder: (context, val, _) => _buildSwitchTile("Morning Slots", val, (newValue) {
                _service.setMorningSlots(newValue);
              }),
            ),
             Divider(color: Colors.grey.shade400),
            ValueListenableBuilder<bool>(
              valueListenable: _service.isEveningSlotsOpen,
              builder: (context, val, _) => _buildSwitchTile("Evening Slots", val, (newValue) {
                _service.setEveningSlots(newValue);
              }),
            ),
            Divider(color: Colors.grey.shade400),
            ValueListenableBuilder<bool>(
              valueListenable: _service.isTodaysBookingOpen,
              builder: (context, val, _) => _buildSwitchTile("Today's Booking", val, (newValue) {
                _service.setTodaysBooking(newValue);
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBrown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "CLOSE",
                style: GoogleFonts.langar(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: GoogleFonts.langar(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500
        ),
      ),
      value: value,
      activeColor: AppColors.activeNavGold,
      activeTrackColor: AppColors.activeNavGold.withOpacity(0.4),
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
