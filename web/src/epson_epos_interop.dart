// web/src/epson_epos_interop.dart
// JavaScript interop layer for Epson ePOS SDK

@JS()
library epson_epos_interop;

import 'package:js/js.dart';

/// Epson ePOS Printer class
@JS('epson.ePOSDevice.Printer')
class EpsonPrinter {
  external factory EpsonPrinter();

  external int timeout;
  external Function? onreceive;
  external Function? onerror;
  external Function? onstatuschange;

  // Printer connection
  external int connect(String address, int mode, [Function? callback]);
  external int disconnect();

  // Print commands
  external int send();
  external void clearCommandBuffer();

  // Text commands
  external void addText(String data);
  external void addTextAlign(int align);
  external void addTextSize(int width, int height);
  external void addTextStyle(bool reverse, bool ul, bool em, int? color);
  external void addTextFont(int font);
  external void addTextSmooth(bool smooth);
  external void addTextLang(int lang);
  external void addTextRotate(bool rotate);
  external void addTextLineSpace(int linespc);
  external void addHPosition(int x);

  // Feed commands
  external void addFeedUnit(int unit);
  external void addFeedLine(int line);

  // Cut command
  external void addCut(int type);

  // Raw command
  external void addCommand(String data);

  // Constants for alignment
  static const int ALIGN_LEFT = 0;
  static const int ALIGN_CENTER = 1;
  static const int ALIGN_RIGHT = 2;

  // Constants for cut type
  static const int CUT_NO_FEED = 0;
  static const int CUT_FEED = 1;
  static const int CUT_RESERVE = 2;

  // Constants for font
  static const int FONT_A = 0;
  static const int FONT_B = 1;
  static const int FONT_C = 2;
  static const int FONT_D = 3;
  static const int FONT_E = 4;

  // Constants for language
  static const int LANG_EN = 0;
  static const int LANG_JA = 1;
  static const int LANG_ZH_CN = 2;
  static const int LANG_ZH_TW = 3;
  static const int LANG_KO = 4;
  static const int LANG_TH = 5;
  static const int LANG_VI = 6;

  // Constants for color
  static const int COLOR_NONE = 0;
  static const int COLOR_1 = 1;
  static const int COLOR_2 = 2;
  static const int COLOR_3 = 3;
  static const int COLOR_4 = 4;
}

/// Epson ePOS Discovery Filter Option
@JS()
@anonymous
class DiscoveryFilterOption {
  external factory DiscoveryFilterOption({
    int? portType,
    String? broadcast,
    int? deviceModel,
    int? deviceType,
  });

  external int? get portType;
  external String? get broadcast;
  external int? get deviceModel;
  external int? get deviceType;
}

/// Epson ePOS Device
@JS()
@anonymous
class EpsonDevice {
  external int get deviceType;
  external String get target;
  external String get deviceName;
  external String get ipAddress;
  external String get macAddress;
  external String get bdAddress;

  external factory EpsonDevice({
    int deviceType,
    String target,
    String deviceName,
    String ipAddress,
    String macAddress,
    String bdAddress,
  });
}

/// Epson ePOS Discovery API
@JS('epson.ePOSDevice.Discovery')
class EpsonDiscovery {
  external factory EpsonDiscovery();

  external void start(
    DiscoveryFilterOption filterOption,
    Function onDeviceFound,
    Function onComplete,
  );

  external void stop();

  // Port type constants
  static const int PORTTYPE_ALL = 0;
  static const int PORTTYPE_TCP = 1;
  static const int PORTTYPE_BLUETOOTH = 2;
  static const int PORTTYPE_USB = 3;

  // Device type constants
  static const int DEVTYPE_ALL = 0;
  static const int DEVTYPE_PRINTER = 1;
  static const int DEVTYPE_HYBRID_PRINTER = 2;
  static const int DEVTYPE_DISPLAY = 3;
  static const int DEVTYPE_KEYBOARD = 4;
  static const int DEVTYPE_SCANNER = 5;
  static const int DEVTYPE_SERIAL = 6;

  // Device model constants
  static const int MODEL_ALL = 0;
}

/// Printer status object
@JS()
@anonymous
class PrinterStatus {
  external int get connection;
  external int get online;
  external int get coverOpen;
  external int get paper;
  external int get paperFeed;
  external int get panelSwitch;
  external int get drawer;
  external int get errorStatus;
  external int get autoRecoverErr;
  external int get adapter;
  external int get batteryLevel;

  external factory PrinterStatus({
    int connection,
    int online,
    int coverOpen,
    int paper,
    int paperFeed,
    int panelSwitch,
    int drawer,
    int errorStatus,
    int autoRecoverErr,
    int adapter,
    int batteryLevel,
  });
}

/// Print response
@JS()
@anonymous
class PrintResponse {
  external bool get success;
  external String get code;
  external int get status;
  external PrinterStatus? get battery;

  external factory PrintResponse({
    bool success,
    String code,
    int status,
    PrinterStatus? battery,
  });
}

/// Helper to check if ePOS SDK is loaded
@JS('epson')
external Object? get epsonSDK;

@JS('epson.ePOSDevice')
external Object? get epsonDevice;

/// Helper function to create a printer with specific series and model
@JS('epson.ePOSDevice.createDevice')
external EpsonPrinter? createEpsonPrinter(String deviceId, int target, DiscoveryFilterOption? options, Function? callback);
