// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Epos2Device {
  String get target;
  String get deviceName;
  String get ipAddress;
  String get macAddress;
  String get bdAddress;

  /// Create a copy of Epos2Device
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Epos2DeviceCopyWith<Epos2Device> get copyWith =>
      _$Epos2DeviceCopyWithImpl<Epos2Device>(this as Epos2Device, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Epos2Device &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.bdAddress, bdAddress) ||
                other.bdAddress == bdAddress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, target, deviceName, ipAddress, macAddress, bdAddress);

  @override
  String toString() {
    return 'Epos2Device(target: $target, deviceName: $deviceName, ipAddress: $ipAddress, macAddress: $macAddress, bdAddress: $bdAddress)';
  }
}

/// @nodoc
abstract mixin class $Epos2DeviceCopyWith<$Res> {
  factory $Epos2DeviceCopyWith(
          Epos2Device value, $Res Function(Epos2Device) _then) =
      _$Epos2DeviceCopyWithImpl;
  @useResult
  $Res call(
      {String target,
      String deviceName,
      String ipAddress,
      String macAddress,
      String bdAddress});
}

/// @nodoc
class _$Epos2DeviceCopyWithImpl<$Res> implements $Epos2DeviceCopyWith<$Res> {
  _$Epos2DeviceCopyWithImpl(this._self, this._then);

  final Epos2Device _self;
  final $Res Function(Epos2Device) _then;

  /// Create a copy of Epos2Device
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? target = null,
    Object? deviceName = null,
    Object? ipAddress = null,
    Object? macAddress = null,
    Object? bdAddress = null,
  }) {
    return _then(_self.copyWith(
      target: null == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _self.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _self.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      bdAddress: null == bdAddress
          ? _self.bdAddress
          : bdAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Epos2Device extends Epos2Device {
  const _Epos2Device(
      {required this.target,
      required this.deviceName,
      required this.ipAddress,
      required this.macAddress,
      required this.bdAddress})
      : super._();

  @override
  final String target;
  @override
  final String deviceName;
  @override
  final String ipAddress;
  @override
  final String macAddress;
  @override
  final String bdAddress;

  /// Create a copy of Epos2Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Epos2DeviceCopyWith<_Epos2Device> get copyWith =>
      __$Epos2DeviceCopyWithImpl<_Epos2Device>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Epos2Device &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.bdAddress, bdAddress) ||
                other.bdAddress == bdAddress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, target, deviceName, ipAddress, macAddress, bdAddress);

  @override
  String toString() {
    return 'Epos2Device(target: $target, deviceName: $deviceName, ipAddress: $ipAddress, macAddress: $macAddress, bdAddress: $bdAddress)';
  }
}

/// @nodoc
abstract mixin class _$Epos2DeviceCopyWith<$Res>
    implements $Epos2DeviceCopyWith<$Res> {
  factory _$Epos2DeviceCopyWith(
          _Epos2Device value, $Res Function(_Epos2Device) _then) =
      __$Epos2DeviceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String target,
      String deviceName,
      String ipAddress,
      String macAddress,
      String bdAddress});
}

/// @nodoc
class __$Epos2DeviceCopyWithImpl<$Res> implements _$Epos2DeviceCopyWith<$Res> {
  __$Epos2DeviceCopyWithImpl(this._self, this._then);

  final _Epos2Device _self;
  final $Res Function(_Epos2Device) _then;

  /// Create a copy of Epos2Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? target = null,
    Object? deviceName = null,
    Object? ipAddress = null,
    Object? macAddress = null,
    Object? bdAddress = null,
  }) {
    return _then(_Epos2Device(
      target: null == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _self.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _self.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _self.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      bdAddress: null == bdAddress
          ? _self.bdAddress
          : bdAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$Epos2FilterOption {
  Epos2PortType get portType;
  String get broadcast;
  int get deviceModel;
  int get deviceType;

  /// Create a copy of Epos2FilterOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Epos2FilterOptionCopyWith<Epos2FilterOption> get copyWith =>
      _$Epos2FilterOptionCopyWithImpl<Epos2FilterOption>(
          this as Epos2FilterOption, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Epos2FilterOption &&
            (identical(other.portType, portType) ||
                other.portType == portType) &&
            (identical(other.broadcast, broadcast) ||
                other.broadcast == broadcast) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, portType, broadcast, deviceModel, deviceType);

  @override
  String toString() {
    return 'Epos2FilterOption(portType: $portType, broadcast: $broadcast, deviceModel: $deviceModel, deviceType: $deviceType)';
  }
}

/// @nodoc
abstract mixin class $Epos2FilterOptionCopyWith<$Res> {
  factory $Epos2FilterOptionCopyWith(
          Epos2FilterOption value, $Res Function(Epos2FilterOption) _then) =
      _$Epos2FilterOptionCopyWithImpl;
  @useResult
  $Res call(
      {Epos2PortType portType,
      String broadcast,
      int deviceModel,
      int deviceType});
}

/// @nodoc
class _$Epos2FilterOptionCopyWithImpl<$Res>
    implements $Epos2FilterOptionCopyWith<$Res> {
  _$Epos2FilterOptionCopyWithImpl(this._self, this._then);

  final Epos2FilterOption _self;
  final $Res Function(Epos2FilterOption) _then;

  /// Create a copy of Epos2FilterOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? portType = null,
    Object? broadcast = null,
    Object? deviceModel = null,
    Object? deviceType = null,
  }) {
    return _then(_self.copyWith(
      portType: null == portType
          ? _self.portType
          : portType // ignore: cast_nullable_to_non_nullable
              as Epos2PortType,
      broadcast: null == broadcast
          ? _self.broadcast
          : broadcast // ignore: cast_nullable_to_non_nullable
              as String,
      deviceModel: null == deviceModel
          ? _self.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as int,
      deviceType: null == deviceType
          ? _self.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _Epos2FilterOption extends Epos2FilterOption {
  const _Epos2FilterOption(
      {this.portType = Epos2PortType.EPOS2_PORTTYPE_ALL,
      this.broadcast = "255.255.255.255",
      this.deviceModel = 0,
      this.deviceType = 0})
      : super._();

  @override
  @JsonKey()
  final Epos2PortType portType;
  @override
  @JsonKey()
  final String broadcast;
  @override
  @JsonKey()
  final int deviceModel;
  @override
  @JsonKey()
  final int deviceType;

  /// Create a copy of Epos2FilterOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Epos2FilterOptionCopyWith<_Epos2FilterOption> get copyWith =>
      __$Epos2FilterOptionCopyWithImpl<_Epos2FilterOption>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Epos2FilterOption &&
            (identical(other.portType, portType) ||
                other.portType == portType) &&
            (identical(other.broadcast, broadcast) ||
                other.broadcast == broadcast) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, portType, broadcast, deviceModel, deviceType);

  @override
  String toString() {
    return 'Epos2FilterOption(portType: $portType, broadcast: $broadcast, deviceModel: $deviceModel, deviceType: $deviceType)';
  }
}

/// @nodoc
abstract mixin class _$Epos2FilterOptionCopyWith<$Res>
    implements $Epos2FilterOptionCopyWith<$Res> {
  factory _$Epos2FilterOptionCopyWith(
          _Epos2FilterOption value, $Res Function(_Epos2FilterOption) _then) =
      __$Epos2FilterOptionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Epos2PortType portType,
      String broadcast,
      int deviceModel,
      int deviceType});
}

/// @nodoc
class __$Epos2FilterOptionCopyWithImpl<$Res>
    implements _$Epos2FilterOptionCopyWith<$Res> {
  __$Epos2FilterOptionCopyWithImpl(this._self, this._then);

  final _Epos2FilterOption _self;
  final $Res Function(_Epos2FilterOption) _then;

  /// Create a copy of Epos2FilterOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? portType = null,
    Object? broadcast = null,
    Object? deviceModel = null,
    Object? deviceType = null,
  }) {
    return _then(_Epos2FilterOption(
      portType: null == portType
          ? _self.portType
          : portType // ignore: cast_nullable_to_non_nullable
              as Epos2PortType,
      broadcast: null == broadcast
          ? _self.broadcast
          : broadcast // ignore: cast_nullable_to_non_nullable
              as String,
      deviceModel: null == deviceModel
          ? _self.deviceModel
          : deviceModel // ignore: cast_nullable_to_non_nullable
              as int,
      deviceType: null == deviceType
          ? _self.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
