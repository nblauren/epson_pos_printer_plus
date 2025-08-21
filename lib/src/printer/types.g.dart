// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Epos2PrinterStatusInfo _$Epos2PrinterStatusInfoFromJson(
        Map<String, dynamic> json) =>
    _Epos2PrinterStatusInfo(
      printerJobId: json['printerJobId'] as String?,
      connection: json['connection'] as bool,
      online: json['online'] as bool?,
      coverOpen: json['coverOpen'] as bool?,
      paper: (json['paper'] as num?)?.toInt(),
      paperFeed: json['paperFeed'] as bool?,
      panelSwitch: json['panelSwitch'] as bool?,
      waitOnline: (json['waitOnline'] as num).toInt(),
      drawer: json['drawer'] as bool?,
      errorStatus: (json['errorStatus'] as num?)?.toInt(),
      autoRecoverError: (json['autoRecoverError'] as num?)?.toInt(),
      buzzer: json['buzzer'] as bool?,
      adapter: json['adapter'] as bool?,
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      removalWaiting: (json['removalWaiting'] as num?)?.toInt(),
      unrecoverError: (json['unrecoverError'] as num?)?.toInt(),
    );

Map<String, dynamic> _$Epos2PrinterStatusInfoToJson(
        _Epos2PrinterStatusInfo instance) =>
    <String, dynamic>{
      'printerJobId': instance.printerJobId,
      'connection': instance.connection,
      'online': instance.online,
      'coverOpen': instance.coverOpen,
      'paper': instance.paper,
      'paperFeed': instance.paperFeed,
      'panelSwitch': instance.panelSwitch,
      'waitOnline': instance.waitOnline,
      'drawer': instance.drawer,
      'errorStatus': instance.errorStatus,
      'autoRecoverError': instance.autoRecoverError,
      'buzzer': instance.buzzer,
      'adapter': instance.adapter,
      'batteryLevel': instance.batteryLevel,
      'removalWaiting': instance.removalWaiting,
      'unrecoverError': instance.unrecoverError,
    };
