// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_entry_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PinEntryState {
  List<String> get pin => throw _privateConstructorUsedError;
  int get currentIndex => throw _privateConstructorUsedError;
  bool get isComplete => throw _privateConstructorUsedError;
  bool get confirmTransfer => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PinEntryStateCopyWith<PinEntryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinEntryStateCopyWith<$Res> {
  factory $PinEntryStateCopyWith(
          PinEntryState value, $Res Function(PinEntryState) then) =
      _$PinEntryStateCopyWithImpl<$Res, PinEntryState>;
  @useResult
  $Res call(
      {List<String> pin,
      int currentIndex,
      bool isComplete,
      bool confirmTransfer});
}

/// @nodoc
class _$PinEntryStateCopyWithImpl<$Res, $Val extends PinEntryState>
    implements $PinEntryStateCopyWith<$Res> {
  _$PinEntryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
    Object? currentIndex = null,
    Object? isComplete = null,
    Object? confirmTransfer = null,
  }) {
    return _then(_value.copyWith(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      confirmTransfer: null == confirmTransfer
          ? _value.confirmTransfer
          : confirmTransfer // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PinEntryStateImplCopyWith<$Res>
    implements $PinEntryStateCopyWith<$Res> {
  factory _$$PinEntryStateImplCopyWith(
          _$PinEntryStateImpl value, $Res Function(_$PinEntryStateImpl) then) =
      __$$PinEntryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> pin,
      int currentIndex,
      bool isComplete,
      bool confirmTransfer});
}

/// @nodoc
class __$$PinEntryStateImplCopyWithImpl<$Res>
    extends _$PinEntryStateCopyWithImpl<$Res, _$PinEntryStateImpl>
    implements _$$PinEntryStateImplCopyWith<$Res> {
  __$$PinEntryStateImplCopyWithImpl(
      _$PinEntryStateImpl _value, $Res Function(_$PinEntryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
    Object? currentIndex = null,
    Object? isComplete = null,
    Object? confirmTransfer = null,
  }) {
    return _then(_$PinEntryStateImpl(
      pin: null == pin
          ? _value._pin
          : pin // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isComplete: null == isComplete
          ? _value.isComplete
          : isComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      confirmTransfer: null == confirmTransfer
          ? _value.confirmTransfer
          : confirmTransfer // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PinEntryStateImpl implements _PinEntryState {
  const _$PinEntryStateImpl(
      {final List<String> pin = const ['', '', '', ''],
      this.currentIndex = 0,
      this.isComplete = false,
      this.confirmTransfer = false})
      : _pin = pin;

  final List<String> _pin;
  @override
  @JsonKey()
  List<String> get pin {
    if (_pin is EqualUnmodifiableListView) return _pin;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pin);
  }

  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final bool isComplete;
  @override
  @JsonKey()
  final bool confirmTransfer;

  @override
  String toString() {
    return 'PinEntryState(pin: $pin, currentIndex: $currentIndex, isComplete: $isComplete, confirmTransfer: $confirmTransfer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinEntryStateImpl &&
            const DeepCollectionEquality().equals(other._pin, _pin) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.isComplete, isComplete) ||
                other.isComplete == isComplete) &&
            (identical(other.confirmTransfer, confirmTransfer) ||
                other.confirmTransfer == confirmTransfer));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pin),
      currentIndex,
      isComplete,
      confirmTransfer);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PinEntryStateImplCopyWith<_$PinEntryStateImpl> get copyWith =>
      __$$PinEntryStateImplCopyWithImpl<_$PinEntryStateImpl>(this, _$identity);
}

abstract class _PinEntryState implements PinEntryState {
  const factory _PinEntryState(
      {final List<String> pin,
      final int currentIndex,
      final bool isComplete,
      final bool confirmTransfer}) = _$PinEntryStateImpl;

  @override
  List<String> get pin;
  @override
  int get currentIndex;
  @override
  bool get isComplete;
  @override
  bool get confirmTransfer;
  @override
  @JsonKey(ignore: true)
  _$$PinEntryStateImplCopyWith<_$PinEntryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
