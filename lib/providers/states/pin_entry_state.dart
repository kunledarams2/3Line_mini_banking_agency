
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_entry_state.freezed.dart';

@freezed
class PinEntryState with _$PinEntryState {
  const factory PinEntryState({
    @Default(['', '', '', '']) List<String> pin,
    @Default(0) int currentIndex,
    @Default(false) bool isComplete,
    @Default(false) bool confirmTransfer,
  }) = _PinEntryState;
}