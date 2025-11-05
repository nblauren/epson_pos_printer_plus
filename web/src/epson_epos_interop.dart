// web/src/epson_epos_interop.dart
// JavaScript interop layer for Epson ePOS SDK (Corrected to match real API)

@JS()
library epson_epos_interop;

import 'package:js/js.dart';

/// Main ePOSDevice class - used to connect to printers and create device objects
/// Usage: var device = new epson.ePOSDevice();
@JS('epson.ePOSDevice')
class EpsonEPOSDevice {
  external factory EpsonEPOSDevice();

  /// Connect to a printer
  /// @param ip - IP address of the printer
  /// @param port - Port number (usually 8008 or 8043 for SSL)
  /// @param callback - Callback function(data) where data is "OK" or error code
  external void connect(String ip, String port, Function callback);

  /// Disconnect from the printer
  external void disconnect();

  /// Create a device object (printer, display, etc.)
  /// @param deviceId - Unique identifier for the device
  /// @param deviceType - Type constant (DEVICE_TYPE_PRINTER, etc.)
  /// @param options - Configuration object {crypto: bool, buffer: bool}
  /// @param callback - Callback function(deviceObject, returnCode)
  external void createDevice(
    String deviceId,
    int deviceType,
    DeviceOptions options,
    Function callback,
  );

  /// Delete a device object
  /// @param deviceObject - The device object to delete
  /// @param callback - Callback function(errorCode)
  external void deleteDevice(Object deviceObject, Function callback);

  // Device type constants
  external static int get DEVICE_TYPE_PRINTER;
  external static int get DEVICE_TYPE_HYBRID_PRINTER;
  external static int get DEVICE_TYPE_DISPLAY;
  external static int get DEVICE_TYPE_KEYBOARD;
  external static int get DEVICE_TYPE_SCANNER;
  external static int get DEVICE_TYPE_SERIAL;

  // For getting constants at runtime
  static const int DEVICE_TYPE_PRINTER_VALUE = 1;
  static const int DEVICE_TYPE_HYBRID_PRINTER_VALUE = 2;
  static const int DEVICE_TYPE_DISPLAY_VALUE = 3;
}

/// Device creation options
@JS()
@anonymous
class DeviceOptions {
  external factory DeviceOptions({
    bool? crypto,
    bool? buffer,
  });

  external bool? get crypto;
  external bool? get buffer;
}

/// Printer object (returned from createDevice)
/// This is actually an ePOSBuilder/ePOSPrint object
@JS()
@anonymous
class EpsonPrinter {
  // Timeout for operations (milliseconds)
  external int get timeout;
  external set timeout(int value);

  // Event handlers
  external Function? get onreceive;
  external set onreceive(Function? callback);

  external Function? get onerror;
  external set onerror(Function? callback);

  external Function? get onstatuschange;
  external set onstatuschange(Function? callback);

  // Print command methods
  external void addText(String data);
  external void addTextLang(String lang);
  external void addTextAlign(int align);
  external void addTextRotate(bool rotate);
  external void addTextLineSpace(int linespc);
  external void addTextFont(String font);
  external void addTextSmooth(bool smooth);
  external void addTextSize(int width, int height);
  external void addTextStyle(bool reverse, bool ul, bool em, String color);
  external void addTextPosition(int x);

  // Feed commands
  external void addFeedUnit(int unit);
  external void addFeedLine(int line);
  external void addFeed();

  // Cut command
  external void addCut(String type);

  // Raw command
  external void addCommand(String data);

  // Send the print job
  external void send();

  // Clear buffer
  external void clearCommandBuffer();

  // Alignment constants (string values)
  external static String get ALIGN_LEFT;
  external static String get ALIGN_CENTER;
  external static String get ALIGN_RIGHT;

  // Cut type constants (string values)
  external static String get CUT_NO_FEED;
  external static String get CUT_FEED;
  external static String get CUT_RESERVE;

  // Font constants (string values)
  external static String get FONT_A;
  external static String get FONT_B;
  external static String get FONT_C;
  external static String get FONT_D;
  external static String get FONT_E;

  // Color constants (string values)
  external static String get COLOR_NONE;
  external static String get COLOR_1;
  external static String get COLOR_2;
  external static String get COLOR_3;
  external static String get COLOR_4;

  // Status constants
  external static int get ASB_NO_RESPONSE;
  external static int get ASB_PRINT_SUCCESS;
  external static int get ASB_OFF_LINE;
  external static int get ASB_COVER_OPEN;
  external static int get ASB_PAPER_FEED;
}

/// Response object for print operations
@JS()
@anonymous
class PrintResponse {
  external bool get success;
  external String get code;
  external int get status;
  external int? get battery;

  external factory PrintResponse({
    bool success,
    String code,
    int status,
    int? battery,
  });
}

/// Status object
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
}

/// Helper to check if Epson SDK is loaded
@JS('epson')
external Object? get epsonSDK;

@JS('epson.ePOSDevice')
external Object? get epsonDevice;

/// Helper to access constants
/// Since we can't directly access static getters in JS interop,
/// we'll define the constant values here based on the SDK documentation
class EpsonConstants {
  // Device types
  static const int DEVICE_TYPE_PRINTER = 1;
  static const int DEVICE_TYPE_HYBRID_PRINTER = 2;
  static const int DEVICE_TYPE_DISPLAY = 3;

  // Alignment (string values used by SDK)
  static const String ALIGN_LEFT = 'left';
  static const String ALIGN_CENTER = 'center';
  static const String ALIGN_RIGHT = 'right';

  // Cut types (string values)
  static const String CUT_NO_FEED = 'no_feed';
  static const String CUT_FEED = 'feed';
  static const String CUT_RESERVE = 'reserve';

  // Font (string values)
  static const String FONT_A = 'font_a';
  static const String FONT_B = 'font_b';
  static const String FONT_C = 'font_c';
  static const String FONT_D = 'font_d';
  static const String FONT_E = 'font_e';

  // Color (string values)
  static const String COLOR_NONE = 'none';
  static const String COLOR_1 = 'color_1';
  static const String COLOR_2 = 'color_2';
  static const String COLOR_3 = 'color_3';
  static const String COLOR_4 = 'color_4';

  // Status codes
  static const int ASB_NO_RESPONSE = 1;
  static const int ASB_PRINT_SUCCESS = 2;
  static const int ASB_OFF_LINE = 8;
  static const int ASB_COVER_OPEN = 32;
  static const int ASB_PAPER_FEED = 64;
  static const int ASB_RECEIPT_END = 524288;
  static const int ASB_RECEIPT_NEAR_END = 131072;

  // Return codes
  static const String OK = 'OK';
  static const String ERR_PARAM = 'ERR_PARAM';
  static const String ERR_CONNECT = 'ERR_CONNECT';
  static const String ERR_TIMEOUT = 'ERR_TIMEOUT';
  static const String ERR_MEMORY = 'ERR_MEMORY';
  static const String ERR_ILLEGAL = 'ERR_ILLEGAL';
  static const String ERR_PROCESSING = 'ERR_PROCESSING';
  static const String ERR_NOT_FOUND = 'ERR_NOT_FOUND';
}
