// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Epos2PrinterCreationOptions {
  Epos2Series get series;
  Epos2Model get model;
  String get target;

  /// Create a copy of Epos2PrinterCreationOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Epos2PrinterCreationOptionsCopyWith<Epos2PrinterCreationOptions>
      get copyWith => _$Epos2PrinterCreationOptionsCopyWithImpl<
              Epos2PrinterCreationOptions>(
          this as Epos2PrinterCreationOptions, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Epos2PrinterCreationOptions &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.target, target) || other.target == target));
  }

  @override
  int get hashCode => Object.hash(runtimeType, series, model, target);
}

/// @nodoc
abstract mixin class $Epos2PrinterCreationOptionsCopyWith<$Res> {
  factory $Epos2PrinterCreationOptionsCopyWith(
          Epos2PrinterCreationOptions value,
          $Res Function(Epos2PrinterCreationOptions) _then) =
      _$Epos2PrinterCreationOptionsCopyWithImpl;
  @useResult
  $Res call({Epos2Series series, Epos2Model model, String target});
}

/// @nodoc
class _$Epos2PrinterCreationOptionsCopyWithImpl<$Res>
    implements $Epos2PrinterCreationOptionsCopyWith<$Res> {
  _$Epos2PrinterCreationOptionsCopyWithImpl(this._self, this._then);

  final Epos2PrinterCreationOptions _self;
  final $Res Function(Epos2PrinterCreationOptions) _then;

  /// Create a copy of Epos2PrinterCreationOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? series = null,
    Object? model = null,
    Object? target = null,
  }) {
    return _then(_self.copyWith(
      series: null == series
          ? _self.series
          : series // ignore: cast_nullable_to_non_nullable
              as Epos2Series,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as Epos2Model,
      target: null == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Epos2PrinterCreationOptions extends Epos2PrinterCreationOptions {
  const _Epos2PrinterCreationOptions(
      {required this.series, required this.model, required this.target})
      : super._();

  @override
  final Epos2Series series;
  @override
  final Epos2Model model;
  @override
  final String target;

  /// Create a copy of Epos2PrinterCreationOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Epos2PrinterCreationOptionsCopyWith<_Epos2PrinterCreationOptions>
      get copyWith => __$Epos2PrinterCreationOptionsCopyWithImpl<
          _Epos2PrinterCreationOptions>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Epos2PrinterCreationOptions &&
            (identical(other.series, series) || other.series == series) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.target, target) || other.target == target));
  }

  @override
  int get hashCode => Object.hash(runtimeType, series, model, target);
}

/// @nodoc
abstract mixin class _$Epos2PrinterCreationOptionsCopyWith<$Res>
    implements $Epos2PrinterCreationOptionsCopyWith<$Res> {
  factory _$Epos2PrinterCreationOptionsCopyWith(
          _Epos2PrinterCreationOptions value,
          $Res Function(_Epos2PrinterCreationOptions) _then) =
      __$Epos2PrinterCreationOptionsCopyWithImpl;
  @override
  @useResult
  $Res call({Epos2Series series, Epos2Model model, String target});
}

/// @nodoc
class __$Epos2PrinterCreationOptionsCopyWithImpl<$Res>
    implements _$Epos2PrinterCreationOptionsCopyWith<$Res> {
  __$Epos2PrinterCreationOptionsCopyWithImpl(this._self, this._then);

  final _Epos2PrinterCreationOptions _self;
  final $Res Function(_Epos2PrinterCreationOptions) _then;

  /// Create a copy of Epos2PrinterCreationOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? series = null,
    Object? model = null,
    Object? target = null,
  }) {
    return _then(_Epos2PrinterCreationOptions(
      series: null == series
          ? _self.series
          : series // ignore: cast_nullable_to_non_nullable
              as Epos2Series,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as Epos2Model,
      target: null == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$Epos2PrinterStatusInfo {
  String? get printerJobId;
  bool get connection;
  bool? get online;
  bool? get coverOpen;
  int? get paper;
  bool? get paperFeed;
  bool? get panelSwitch;
  int get waitOnline;
  bool? get drawer;
  int? get errorStatus;
  int? get autoRecoverError;
  bool? get buzzer;
  bool? get adapter;
  int? get batteryLevel;
  int? get removalWaiting;
  int? get unrecoverError;

  /// Create a copy of Epos2PrinterStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $Epos2PrinterStatusInfoCopyWith<Epos2PrinterStatusInfo> get copyWith =>
      _$Epos2PrinterStatusInfoCopyWithImpl<Epos2PrinterStatusInfo>(
          this as Epos2PrinterStatusInfo, _$identity);

  /// Serializes this Epos2PrinterStatusInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Epos2PrinterStatusInfo &&
            (identical(other.printerJobId, printerJobId) ||
                other.printerJobId == printerJobId) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.coverOpen, coverOpen) ||
                other.coverOpen == coverOpen) &&
            (identical(other.paper, paper) || other.paper == paper) &&
            (identical(other.paperFeed, paperFeed) ||
                other.paperFeed == paperFeed) &&
            (identical(other.panelSwitch, panelSwitch) ||
                other.panelSwitch == panelSwitch) &&
            (identical(other.waitOnline, waitOnline) ||
                other.waitOnline == waitOnline) &&
            (identical(other.drawer, drawer) || other.drawer == drawer) &&
            (identical(other.errorStatus, errorStatus) ||
                other.errorStatus == errorStatus) &&
            (identical(other.autoRecoverError, autoRecoverError) ||
                other.autoRecoverError == autoRecoverError) &&
            (identical(other.buzzer, buzzer) || other.buzzer == buzzer) &&
            (identical(other.adapter, adapter) || other.adapter == adapter) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.removalWaiting, removalWaiting) ||
                other.removalWaiting == removalWaiting) &&
            (identical(other.unrecoverError, unrecoverError) ||
                other.unrecoverError == unrecoverError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      printerJobId,
      connection,
      online,
      coverOpen,
      paper,
      paperFeed,
      panelSwitch,
      waitOnline,
      drawer,
      errorStatus,
      autoRecoverError,
      buzzer,
      adapter,
      batteryLevel,
      removalWaiting,
      unrecoverError);

  @override
  String toString() {
    return 'Epos2PrinterStatusInfo(printerJobId: $printerJobId, connection: $connection, online: $online, coverOpen: $coverOpen, paper: $paper, paperFeed: $paperFeed, panelSwitch: $panelSwitch, waitOnline: $waitOnline, drawer: $drawer, errorStatus: $errorStatus, autoRecoverError: $autoRecoverError, buzzer: $buzzer, adapter: $adapter, batteryLevel: $batteryLevel, removalWaiting: $removalWaiting, unrecoverError: $unrecoverError)';
  }
}

/// @nodoc
abstract mixin class $Epos2PrinterStatusInfoCopyWith<$Res> {
  factory $Epos2PrinterStatusInfoCopyWith(Epos2PrinterStatusInfo value,
          $Res Function(Epos2PrinterStatusInfo) _then) =
      _$Epos2PrinterStatusInfoCopyWithImpl;
  @useResult
  $Res call(
      {String? printerJobId,
      bool connection,
      bool? online,
      bool? coverOpen,
      int? paper,
      bool? paperFeed,
      bool? panelSwitch,
      int waitOnline,
      bool? drawer,
      int? errorStatus,
      int? autoRecoverError,
      bool? buzzer,
      bool? adapter,
      int? batteryLevel,
      int? removalWaiting,
      int? unrecoverError});
}

/// @nodoc
class _$Epos2PrinterStatusInfoCopyWithImpl<$Res>
    implements $Epos2PrinterStatusInfoCopyWith<$Res> {
  _$Epos2PrinterStatusInfoCopyWithImpl(this._self, this._then);

  final Epos2PrinterStatusInfo _self;
  final $Res Function(Epos2PrinterStatusInfo) _then;

  /// Create a copy of Epos2PrinterStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? printerJobId = freezed,
    Object? connection = null,
    Object? online = freezed,
    Object? coverOpen = freezed,
    Object? paper = freezed,
    Object? paperFeed = freezed,
    Object? panelSwitch = freezed,
    Object? waitOnline = null,
    Object? drawer = freezed,
    Object? errorStatus = freezed,
    Object? autoRecoverError = freezed,
    Object? buzzer = freezed,
    Object? adapter = freezed,
    Object? batteryLevel = freezed,
    Object? removalWaiting = freezed,
    Object? unrecoverError = freezed,
  }) {
    return _then(_self.copyWith(
      printerJobId: freezed == printerJobId
          ? _self.printerJobId
          : printerJobId // ignore: cast_nullable_to_non_nullable
              as String?,
      connection: null == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as bool,
      online: freezed == online
          ? _self.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      coverOpen: freezed == coverOpen
          ? _self.coverOpen
          : coverOpen // ignore: cast_nullable_to_non_nullable
              as bool?,
      paper: freezed == paper
          ? _self.paper
          : paper // ignore: cast_nullable_to_non_nullable
              as int?,
      paperFeed: freezed == paperFeed
          ? _self.paperFeed
          : paperFeed // ignore: cast_nullable_to_non_nullable
              as bool?,
      panelSwitch: freezed == panelSwitch
          ? _self.panelSwitch
          : panelSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
      waitOnline: null == waitOnline
          ? _self.waitOnline
          : waitOnline // ignore: cast_nullable_to_non_nullable
              as int,
      drawer: freezed == drawer
          ? _self.drawer
          : drawer // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorStatus: freezed == errorStatus
          ? _self.errorStatus
          : errorStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      autoRecoverError: freezed == autoRecoverError
          ? _self.autoRecoverError
          : autoRecoverError // ignore: cast_nullable_to_non_nullable
              as int?,
      buzzer: freezed == buzzer
          ? _self.buzzer
          : buzzer // ignore: cast_nullable_to_non_nullable
              as bool?,
      adapter: freezed == adapter
          ? _self.adapter
          : adapter // ignore: cast_nullable_to_non_nullable
              as bool?,
      batteryLevel: freezed == batteryLevel
          ? _self.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      removalWaiting: freezed == removalWaiting
          ? _self.removalWaiting
          : removalWaiting // ignore: cast_nullable_to_non_nullable
              as int?,
      unrecoverError: freezed == unrecoverError
          ? _self.unrecoverError
          : unrecoverError // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Epos2PrinterStatusInfo implements Epos2PrinterStatusInfo {
  const _Epos2PrinterStatusInfo(
      {required this.printerJobId,
      required this.connection,
      required this.online,
      required this.coverOpen,
      required this.paper,
      required this.paperFeed,
      required this.panelSwitch,
      required this.waitOnline,
      required this.drawer,
      required this.errorStatus,
      required this.autoRecoverError,
      required this.buzzer,
      required this.adapter,
      required this.batteryLevel,
      required this.removalWaiting,
      required this.unrecoverError});
  factory _Epos2PrinterStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$Epos2PrinterStatusInfoFromJson(json);

  @override
  final String? printerJobId;
  @override
  final bool connection;
  @override
  final bool? online;
  @override
  final bool? coverOpen;
  @override
  final int? paper;
  @override
  final bool? paperFeed;
  @override
  final bool? panelSwitch;
  @override
  final int waitOnline;
  @override
  final bool? drawer;
  @override
  final int? errorStatus;
  @override
  final int? autoRecoverError;
  @override
  final bool? buzzer;
  @override
  final bool? adapter;
  @override
  final int? batteryLevel;
  @override
  final int? removalWaiting;
  @override
  final int? unrecoverError;

  /// Create a copy of Epos2PrinterStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$Epos2PrinterStatusInfoCopyWith<_Epos2PrinterStatusInfo> get copyWith =>
      __$Epos2PrinterStatusInfoCopyWithImpl<_Epos2PrinterStatusInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$Epos2PrinterStatusInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Epos2PrinterStatusInfo &&
            (identical(other.printerJobId, printerJobId) ||
                other.printerJobId == printerJobId) &&
            (identical(other.connection, connection) ||
                other.connection == connection) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.coverOpen, coverOpen) ||
                other.coverOpen == coverOpen) &&
            (identical(other.paper, paper) || other.paper == paper) &&
            (identical(other.paperFeed, paperFeed) ||
                other.paperFeed == paperFeed) &&
            (identical(other.panelSwitch, panelSwitch) ||
                other.panelSwitch == panelSwitch) &&
            (identical(other.waitOnline, waitOnline) ||
                other.waitOnline == waitOnline) &&
            (identical(other.drawer, drawer) || other.drawer == drawer) &&
            (identical(other.errorStatus, errorStatus) ||
                other.errorStatus == errorStatus) &&
            (identical(other.autoRecoverError, autoRecoverError) ||
                other.autoRecoverError == autoRecoverError) &&
            (identical(other.buzzer, buzzer) || other.buzzer == buzzer) &&
            (identical(other.adapter, adapter) || other.adapter == adapter) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.removalWaiting, removalWaiting) ||
                other.removalWaiting == removalWaiting) &&
            (identical(other.unrecoverError, unrecoverError) ||
                other.unrecoverError == unrecoverError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      printerJobId,
      connection,
      online,
      coverOpen,
      paper,
      paperFeed,
      panelSwitch,
      waitOnline,
      drawer,
      errorStatus,
      autoRecoverError,
      buzzer,
      adapter,
      batteryLevel,
      removalWaiting,
      unrecoverError);

  @override
  String toString() {
    return 'Epos2PrinterStatusInfo(printerJobId: $printerJobId, connection: $connection, online: $online, coverOpen: $coverOpen, paper: $paper, paperFeed: $paperFeed, panelSwitch: $panelSwitch, waitOnline: $waitOnline, drawer: $drawer, errorStatus: $errorStatus, autoRecoverError: $autoRecoverError, buzzer: $buzzer, adapter: $adapter, batteryLevel: $batteryLevel, removalWaiting: $removalWaiting, unrecoverError: $unrecoverError)';
  }
}

/// @nodoc
abstract mixin class _$Epos2PrinterStatusInfoCopyWith<$Res>
    implements $Epos2PrinterStatusInfoCopyWith<$Res> {
  factory _$Epos2PrinterStatusInfoCopyWith(_Epos2PrinterStatusInfo value,
          $Res Function(_Epos2PrinterStatusInfo) _then) =
      __$Epos2PrinterStatusInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? printerJobId,
      bool connection,
      bool? online,
      bool? coverOpen,
      int? paper,
      bool? paperFeed,
      bool? panelSwitch,
      int waitOnline,
      bool? drawer,
      int? errorStatus,
      int? autoRecoverError,
      bool? buzzer,
      bool? adapter,
      int? batteryLevel,
      int? removalWaiting,
      int? unrecoverError});
}

/// @nodoc
class __$Epos2PrinterStatusInfoCopyWithImpl<$Res>
    implements _$Epos2PrinterStatusInfoCopyWith<$Res> {
  __$Epos2PrinterStatusInfoCopyWithImpl(this._self, this._then);

  final _Epos2PrinterStatusInfo _self;
  final $Res Function(_Epos2PrinterStatusInfo) _then;

  /// Create a copy of Epos2PrinterStatusInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? printerJobId = freezed,
    Object? connection = null,
    Object? online = freezed,
    Object? coverOpen = freezed,
    Object? paper = freezed,
    Object? paperFeed = freezed,
    Object? panelSwitch = freezed,
    Object? waitOnline = null,
    Object? drawer = freezed,
    Object? errorStatus = freezed,
    Object? autoRecoverError = freezed,
    Object? buzzer = freezed,
    Object? adapter = freezed,
    Object? batteryLevel = freezed,
    Object? removalWaiting = freezed,
    Object? unrecoverError = freezed,
  }) {
    return _then(_Epos2PrinterStatusInfo(
      printerJobId: freezed == printerJobId
          ? _self.printerJobId
          : printerJobId // ignore: cast_nullable_to_non_nullable
              as String?,
      connection: null == connection
          ? _self.connection
          : connection // ignore: cast_nullable_to_non_nullable
              as bool,
      online: freezed == online
          ? _self.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      coverOpen: freezed == coverOpen
          ? _self.coverOpen
          : coverOpen // ignore: cast_nullable_to_non_nullable
              as bool?,
      paper: freezed == paper
          ? _self.paper
          : paper // ignore: cast_nullable_to_non_nullable
              as int?,
      paperFeed: freezed == paperFeed
          ? _self.paperFeed
          : paperFeed // ignore: cast_nullable_to_non_nullable
              as bool?,
      panelSwitch: freezed == panelSwitch
          ? _self.panelSwitch
          : panelSwitch // ignore: cast_nullable_to_non_nullable
              as bool?,
      waitOnline: null == waitOnline
          ? _self.waitOnline
          : waitOnline // ignore: cast_nullable_to_non_nullable
              as int,
      drawer: freezed == drawer
          ? _self.drawer
          : drawer // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorStatus: freezed == errorStatus
          ? _self.errorStatus
          : errorStatus // ignore: cast_nullable_to_non_nullable
              as int?,
      autoRecoverError: freezed == autoRecoverError
          ? _self.autoRecoverError
          : autoRecoverError // ignore: cast_nullable_to_non_nullable
              as int?,
      buzzer: freezed == buzzer
          ? _self.buzzer
          : buzzer // ignore: cast_nullable_to_non_nullable
              as bool?,
      adapter: freezed == adapter
          ? _self.adapter
          : adapter // ignore: cast_nullable_to_non_nullable
              as bool?,
      batteryLevel: freezed == batteryLevel
          ? _self.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      removalWaiting: freezed == removalWaiting
          ? _self.removalWaiting
          : removalWaiting // ignore: cast_nullable_to_non_nullable
              as int?,
      unrecoverError: freezed == unrecoverError
          ? _self.unrecoverError
          : unrecoverError // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
