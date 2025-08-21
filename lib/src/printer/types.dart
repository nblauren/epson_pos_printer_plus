import 'package:epson_pos_printer/src/assertions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'types.freezed.dart';
part 'types.g.dart';

@freezed
class Epos2PrinterCreationOptions with _$Epos2PrinterCreationOptions {
  const Epos2PrinterCreationOptions._();

  const factory Epos2PrinterCreationOptions({
    required Epos2Series series,
    required Epos2Model model,
    required String target,
  }) = _Epos2PrinterCreationOptions;

  static final _connectionStringPattern = RegExp(
    r"^\{Epos2Printer series=(?<series>\w+),\s*model=(?<model>\w+),\s*target=(?<target>[\w:]+)\}$",
    caseSensitive: false,
  );

  factory Epos2PrinterCreationOptions.from(String connectionString) {
    final match = _connectionStringPattern.firstMatch(connectionString);
    if (match == null) {
      throw ArgumentError.value(
        connectionString,
        "connectionString",
        "Bad connection string",
      );
    }

    return Epos2PrinterCreationOptions(
      series: Epos2Series.values.byName(
        match.namedGroup("series").requireNotNull(),
      ),
      model: Epos2Model.values.byName(
        match.namedGroup("model").requireNotNull(),
      ),
      target: match.namedGroup("target").requireNotNull(),
    );
  }

  @override
  String toString() => toConnectionString();

  String toConnectionString() =>
      "{Epos2Printer series=${series.name}, model=${model.name}, target=$target}";

  @override
  // TODO: implement model
  Epos2Model get model => throw UnimplementedError();

  @override
  // TODO: implement series
  Epos2Series get series => throw UnimplementedError();

  @override
  // TODO: implement target
  String get target => throw UnimplementedError();
}

@freezed
class Epos2PrinterStatusInfo with _$Epos2PrinterStatusInfo {
  const factory Epos2PrinterStatusInfo({
    required String? printerJobId,
    required bool connection,
    required bool? online,
    required bool? coverOpen,
    required int? paper,
    required bool? paperFeed,
    required bool? panelSwitch,
    required int waitOnline,
    required bool? drawer,
    required int? errorStatus,
    required int? autoRecoverError,
    required bool? buzzer,
    required bool? adapter,
    required int? batteryLevel,
    required int? removalWaiting,
    required int? unrecoverError,
  }) = _Epos2PrinterStatusInfo;

  factory Epos2PrinterStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$Epos2PrinterStatusInfoFromJson(json);

  @override
  // TODO: implement adapter
  bool? get adapter => throw UnimplementedError();

  @override
  // TODO: implement autoRecoverError
  int? get autoRecoverError => throw UnimplementedError();

  @override
  // TODO: implement batteryLevel
  int? get batteryLevel => throw UnimplementedError();

  @override
  // TODO: implement buzzer
  bool? get buzzer => throw UnimplementedError();

  @override
  // TODO: implement connection
  bool get connection => throw UnimplementedError();

  @override
  // TODO: implement coverOpen
  bool? get coverOpen => throw UnimplementedError();

  @override
  // TODO: implement drawer
  bool? get drawer => throw UnimplementedError();

  @override
  // TODO: implement errorStatus
  int? get errorStatus => throw UnimplementedError();

  @override
  // TODO: implement online
  bool? get online => throw UnimplementedError();

  @override
  // TODO: implement panelSwitch
  bool? get panelSwitch => throw UnimplementedError();

  @override
  // TODO: implement paper
  int? get paper => throw UnimplementedError();

  @override
  // TODO: implement paperFeed
  bool? get paperFeed => throw UnimplementedError();

  @override
  // TODO: implement printerJobId
  String? get printerJobId => throw UnimplementedError();

  @override
  // TODO: implement removalWaiting
  int? get removalWaiting => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement unrecoverError
  int? get unrecoverError => throw UnimplementedError();

  @override
  // TODO: implement waitOnline
  int get waitOnline => throw UnimplementedError();
}
