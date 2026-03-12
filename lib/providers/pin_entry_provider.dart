

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_line_agency_banking/providers/states/pin_entry_state.dart';




class PinEntryNotifier extends StateNotifier<PinEntryState> {
  PinEntryNotifier() : super(const PinEntryState());

  void addDigit(String digit) {
    if (state.isComplete) return; // Prevent extra input after complete

    final newPin = List<String>.from(state.pin);
    final index = newPin.indexWhere((element) => element.isEmpty);
    if (index != -1) {
      newPin[index] = digit;
      final complete = !newPin.contains('');
      state = state.copyWith(pin: newPin, isComplete: complete);
    }
  }

  void confirmTransfer(bool isConfirm){
    state = state.copyWith(confirmTransfer: isConfirm);
  }

  void removeDigit() {
    final newPin = List<String>.from(state.pin);
    final index = newPin.lastIndexWhere((element) => element.isNotEmpty);
    if (index != -1) {
      newPin[index] = '';
      state = state.copyWith(pin: newPin, isComplete: false);
    }
  }

  String get pinValue => state.pin.join();

  void resetKeyPad() {
    state = const PinEntryState();
  }
}

final pinEntryProvider =
StateNotifierProvider<PinEntryNotifier, PinEntryState>((ref) {
  return PinEntryNotifier();
});


// class PinEntryNotifier extends Notifier<PinEntryState> {
//   @override
//   PinEntryState build() {
//     return const PinEntryState();
//   }
//
//   void addDigit(String digit) {
//     if (state.currentIndex < 4) {
//       final updatedPin = List<String>.from(state.pin);
//       updatedPin[state.currentIndex] = digit;
//       state = state.copyWith(
//         pin: updatedPin,
//         currentIndex: state.currentIndex + 1,
//       );
//     }
//   }
//
//   void removeDigit() {
//     if (state.currentIndex > 0) {
//       final updatedPin = List<String>.from(state.pin);
//       updatedPin[state.currentIndex - 1] = '';
//       state = state.copyWith(
//         pin: updatedPin,
//         currentIndex: state.currentIndex - 1,
//       );
//     }
//   }
//
//   void resetKeyPad() {
//     state = state.copyWith(
//       pin: ['', '', '', ''],
//       currentIndex: 0,
//     );
//   }
//
//   bool isComplete() => state.currentIndex == 4;
//
//   String get pinValue => state.pin.join();
// }

// final pinEntryProvider =
// NotifierProvider<PinEntryNotifier, PinEntryState>(PinEntryNotifier.new);