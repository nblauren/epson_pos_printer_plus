import 'package:epson_pos_printer/src/assertions.dart';
import 'package:epson_pos_printer/src/discovery/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class Epos2Device with _$Epos2Device {
  const Epos2Device._();

  const factory Epos2Device({
    required String target,
    required String deviceName,
    required String ipAddress,
    required String macAddress,
    required String bdAddress,
  }) = _Epos2Device;

  factory Epos2Device.fromMarshal(Map data) {
    check(data["deviceType"] == 1, "Only EPOS2_TYPE_PRINTER is supported");

    return Epos2Device(
      target: data['target'] as String,
      deviceName: data['deviceName'] as String,
      ipAddress: data['ipAddress'] as String,
      macAddress: data['macAddress'] as String,
      bdAddress: data['bdAddress'] as String,
    );
  }

  @override
  // TODO: implement bdAddress
  String get bdAddress => throw UnimplementedError();

  @override
  // TODO: implement deviceName
  String get deviceName => throw UnimplementedError();

  @override
  // TODO: implement ipAddress
  String get ipAddress => throw UnimplementedError();

  @override
  // TODO: implement macAddress
  String get macAddress => throw UnimplementedError();

  @override
  // TODO: implement target
  String get target => throw UnimplementedError();
}

@freezed
class Epos2FilterOption with _$Epos2FilterOption {
  const Epos2FilterOption._();

  const factory Epos2FilterOption({
    @Default(Epos2PortType.EPOS2_PORTTYPE_ALL) Epos2PortType portType,
    @Default("255.255.255.255") String broadcast,
    @Default(0) int deviceModel,
    @Default(0) int deviceType,
  }) = _Epos2FilterOption;

  factory Epos2FilterOption.fromMarshal(Map data) {
    return Epos2FilterOption(
      portType: data['portType'] as Epos2PortType,
      broadcast: data['broadcast'] as String,
      deviceModel: data['deviceModel'] as int,
      deviceType: data['deviceType'] as int,
    );
  }

  Map<String, dynamic> toMarshal() {
    return {
      'portType': portType.index,
      'broadcast': broadcast,
      'deviceModel': 0,
      'deviceType': 1,
    };
  }

  @override
  // TODO: implement broadcast
  String get broadcast => throw UnimplementedError();

  @override
  // TODO: implement deviceModel
  int get deviceModel => throw UnimplementedError();

  @override
  // TODO: implement deviceType
  int get deviceType => throw UnimplementedError();

  @override
  // TODO: implement portType
  Epos2PortType get portType => throw UnimplementedError();
}
