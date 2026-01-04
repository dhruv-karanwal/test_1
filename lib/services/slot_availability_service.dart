import 'package:flutter/foundation.dart';

class SlotAvailabilityService {
  // Singleton instance
  static final SlotAvailabilityService _instance = SlotAvailabilityService._internal();
  static SlotAvailabilityService get instance => _instance;

  SlotAvailabilityService._internal();

  // State
  final ValueNotifier<bool> isMorningSlotsOpen = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isEveningSlotsOpen = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isTodaysBookingOpen = ValueNotifier<bool>(true);

  // Methods to update state
  void setMorningSlots(bool value) => isMorningSlotsOpen.value = value;
  void setEveningSlots(bool value) => isEveningSlotsOpen.value = value;
  void setTodaysBooking(bool value) => isTodaysBookingOpen.value = value;
}
