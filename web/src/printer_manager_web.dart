// web/src/printer_manager_web.dart
import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'epson_epos_interop.dart';

class PrinterManagerWeb {
  // Store printer instances with their metadata
  final Map<int, _WebPrinterInstance> _printers = {};
  int _nextPrinterId = 0;

  // Store status event controllers
  final Map<int, StreamController<Map<String, dynamic>>> _statusControllers = {};

  Future<dynamic> handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'init':
          return _init();
        case 'createPrinter':
          return _createPrinter(call.arguments);
        case 'destroyPrinter':
          return _destroyPrinter(call.arguments);
        case 'connect':
          return await _connect(call.arguments);
        case 'disconnect':
          return await _disconnect(call.arguments);
        case 'sendData':
          return await _sendData(call.arguments);
        case 'clearCommandBuffer':
          return _clearCommandBuffer(call.arguments);
        case 'addText':
          return _addText(call.arguments);
        case 'addTextAlign':
          return _addTextAlign(call.arguments);
        case 'addLineSpace':
          return _addLineSpace(call.arguments);
        case 'addTextRotate':
          return _addTextRotate(call.arguments);
        case 'addTextLang':
          return _addTextLang(call.arguments);
        case 'addTextFont':
          return _addTextFont(call.arguments);
        case 'addTextSmooth':
          return _addTextSmooth(call.arguments);
        case 'addTextSize':
          return _addTextSize(call.arguments);
        case 'addTextStyle':
          return _addTextStyle(call.arguments);
        case 'addHPosition':
          return _addHPosition(call.arguments);
        case 'addFeedUnit':
          return _addFeedUnit(call.arguments);
        case 'addFeedLine':
          return _addFeedLine(call.arguments);
        case 'addCut':
          return _addCut(call.arguments);
        case 'addCommand':
          return _addCommand(call.arguments);
        default:
          throw PlatformException(
            code: 'Unimplemented',
            details: 'Method ${call.method} not implemented on web platform',
          );
      }
    } catch (e) {
      throw PlatformException(
        code: 'ERROR',
        message: e.toString(),
      );
    }
  }

  void _init() {
    // Clean up all existing printers
    for (var instance in _printers.values) {
      try {
        if (instance.eposDevice != null) {
          instance.eposDevice!.disconnect();
        }
      } catch (_) {}
    }
    _printers.clear();

    // Clean up all status controllers
    for (var controller in _statusControllers.values) {
      controller.close();
    }
    _statusControllers.clear();

    _nextPrinterId = 0;
  }

  int _createPrinter(dynamic arguments) {
    if (!_isEpsonSDKLoaded()) {
      throw PlatformException(
        code: 'SDK_NOT_LOADED',
        message: 'Epson ePOS SDK not loaded. Make sure the SDK JavaScript file is included.',
      );
    }

    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int series = args['series'] as int;
    final int model = args['model'] as int;

    final printerId = _nextPrinterId++;

    // Create ePOSDevice instance
    final eposDevice = EpsonEPOSDevice();

    // Store the printer instance
    _printers[printerId] = _WebPrinterInstance(
      eposDevice: eposDevice,
      printer: null, // Will be set after createDevice
      series: series,
      model: model,
      isConnected: false,
    );

    return printerId;
  }

  void _destroyPrinter(dynamic arguments) {
    final id = arguments as int;
    final instance = _printers[id];

    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    try {
      // Disconnect ePOSDevice
      if (instance.eposDevice != null) {
        instance.eposDevice!.disconnect();
      }
    } catch (_) {}

    _printers.remove(id);

    // Clean up status controller
    final controller = _statusControllers[id];
    if (controller != null) {
      controller.close();
      _statusControllers.remove(id);
    }
  }

  Future<void> _connect(dynamic arguments) async {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String target = args['target'] as String;
    final int timeout = (args['timeout'] as int?) ?? 15000;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    if (instance.isConnected) {
      return; // Already connected
    }

    // Parse target - should be IP:port or just IP (default port 8008)
    String ipAddress = target;
    String port = '8008';

    if (target.contains(':')) {
      final parts = target.split(':');
      ipAddress = parts[0];
      port = parts[1];
    }

    final completer = Completer<void>();

    // Step 1: Connect to ePOSDevice
    instance.eposDevice!.connect(
      ipAddress,
      port,
      allowInterop((dynamic data) {
        final String result = data.toString();

        if (result == EpsonConstants.OK) {
          // Step 2: Create printer device object
          instance.eposDevice!.createDevice(
            'printer_$id',
            EpsonConstants.DEVICE_TYPE_PRINTER,
            DeviceOptions(crypto: false, buffer: false),
            allowInterop((dynamic deviceObject, dynamic returnCode) {
              final String code = returnCode.toString();

              if (code == EpsonConstants.OK) {
                // Store the printer object
                instance.printer = deviceObject as EpsonPrinter;
                instance.isConnected = true;

                // Setup status change listener
                _setupStatusListener(id, instance.printer!);

                // Set timeout
                instance.printer!.timeout = timeout;

                completer.complete();
              } else {
                completer.completeError(
                  PlatformException(
                    code: 'DEVICE_CREATE_FAILED',
                    message: 'Failed to create device: $code',
                  ),
                );
              }
            }),
          );
        } else {
          completer.completeError(
            PlatformException(
              code: 'CONNECTION_FAILED',
              message: 'Failed to connect to printer: $result',
            ),
          );
        }
      }),
    );

    return completer.future;
  }

  void _setupStatusListener(int printerId, EpsonPrinter printer) {
    // Create status event handler
    printer.onstatuschange = allowInterop((dynamic status) {
      final controller = _statusControllers[printerId];
      if (controller != null && !controller.isClosed) {
        final statusMap = <String, dynamic>{
          'connection': js_util.getProperty(status, 'connection') ?? 0,
          'online': js_util.getProperty(status, 'online') ?? 0,
          'coverOpen': js_util.getProperty(status, 'coverOpen') ?? 0,
          'paper': js_util.getProperty(status, 'paper') ?? 0,
          'paperFeed': js_util.getProperty(status, 'paperFeed') ?? 0,
          'panelSwitch': js_util.getProperty(status, 'panelSwitch') ?? 0,
          'drawer': js_util.getProperty(status, 'drawer') ?? 0,
          'errorStatus': js_util.getProperty(status, 'errorStatus') ?? 0,
          'autoRecoverErr': js_util.getProperty(status, 'autoRecoverErr') ?? 0,
          'adapter': js_util.getProperty(status, 'adapter') ?? 0,
          'batteryLevel': js_util.getProperty(status, 'batteryLevel') ?? 0,
        };
        controller.add(statusMap);
      }
    });
  }

  StreamController<Map<String, dynamic>>? getStatusController(int printerId) {
    if (!_statusControllers.containsKey(printerId)) {
      _statusControllers[printerId] = StreamController<Map<String, dynamic>>.broadcast();
    }
    return _statusControllers[printerId];
  }

  Future<void> _disconnect(dynamic arguments) async {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    if (instance.eposDevice != null) {
      instance.eposDevice!.disconnect();
      instance.isConnected = false;
      instance.printer = null;
    }
  }

  Future<Map<String, dynamic>> _sendData(dynamic arguments) async {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int timeout = (args['timeout'] as int?) ?? 10000;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    if (instance.printer == null) {
      throw PlatformException(
        code: 'NOT_CONNECTED',
        message: 'Printer not connected',
      );
    }

    final completer = Completer<Map<String, dynamic>>();

    // Set timeout
    instance.printer!.timeout = timeout;

    // Setup receive callback
    instance.printer!.onreceive = allowInterop((dynamic response) {
      final bool success = js_util.getProperty<bool>(response, 'success') ?? false;
      final String code = js_util.getProperty<String>(response, 'code') ?? '';
      final dynamic status = js_util.getProperty(response, 'status');

      if (success) {
        completer.complete({
          'success': true,
          'code': code,
          'status': _convertStatus(status),
        });
      } else {
        completer.completeError(
          PlatformException(
            code: 'PRINT_FAILED',
            message: 'Print failed: $code',
          ),
        );
      }
    });

    // Setup error callback
    instance.printer!.onerror = allowInterop((dynamic error) {
      final String code = js_util.getProperty<String>(error, 'status')?.toString() ?? 'UNKNOWN';
      completer.completeError(
        PlatformException(
          code: 'PRINT_ERROR',
          message: 'Print error: $code',
        ),
      );
    });

    // Send the print data
    instance.printer!.send();

    return completer.future;
  }

  Map<String, dynamic> _convertStatus(dynamic status) {
    if (status == null) {
      return {
        'connection': 0,
        'online': 0,
        'coverOpen': 0,
        'paper': 0,
        'paperFeed': 0,
        'panelSwitch': 0,
        'drawer': 0,
        'errorStatus': 0,
        'autoRecoverErr': 0,
        'adapter': 0,
        'batteryLevel': 0,
      };
    }

    return {
      'connection': js_util.getProperty(status, 'connection') ?? 0,
      'online': js_util.getProperty(status, 'online') ?? 0,
      'coverOpen': js_util.getProperty(status, 'coverOpen') ?? 0,
      'paper': js_util.getProperty(status, 'paper') ?? 0,
      'paperFeed': js_util.getProperty(status, 'paperFeed') ?? 0,
      'panelSwitch': js_util.getProperty(status, 'panelSwitch') ?? 0,
      'drawer': js_util.getProperty(status, 'drawer') ?? 0,
      'errorStatus': js_util.getProperty(status, 'errorStatus') ?? 0,
      'autoRecoverErr': js_util.getProperty(status, 'autoRecoverErr') ?? 0,
      'adapter': js_util.getProperty(status, 'adapter') ?? 0,
      'batteryLevel': js_util.getProperty(status, 'batteryLevel') ?? 0,
    };
  }

  void _clearCommandBuffer(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final printer = _getPrinter(id);
    printer.clearCommandBuffer();
  }

  void _addText(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String data = args['data'] as String;
    final printer = _getPrinter(id);
    printer.addText(data);
  }

  void _addTextAlign(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int align = args['align'] as int;
    final printer = _getPrinter(id);

    // Convert int to SDK string constant
    final alignValue = _convertAlign(align);
    printer.addTextAlign(alignValue);
  }

  int _convertAlign(int align) {
    switch (align) {
      case 0: return 0; // LEFT
      case 1: return 1; // CENTER
      case 2: return 2; // RIGHT
      default: return 0;
    }
  }

  void _addLineSpace(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int space = args['space'] as int;
    final printer = _getPrinter(id);
    printer.addTextLineSpace(space);
  }

  void _addTextRotate(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int rotate = args['rotate'] as int;
    final printer = _getPrinter(id);
    printer.addTextRotate(rotate == 1);
  }

  void _addTextLang(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int lang = args['lang'] as int;
    final printer = _getPrinter(id);

    // Convert int to SDK string constant
    final langValue = _convertLang(lang);
    printer.addTextLang(langValue);
  }

  String _convertLang(int lang) {
    // Map language codes - these are SDK-specific
    switch (lang) {
      case 0: return 'en';
      case 1: return 'ja';
      case 2: return 'zh-cn';
      case 3: return 'zh-tw';
      case 4: return 'ko';
      default: return 'en';
    }
  }

  void _addTextFont(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int font = args['font'] as int;
    final printer = _getPrinter(id);

    // Convert int to SDK string constant
    final fontValue = _convertFont(font);
    printer.addTextFont(fontValue);
  }

  String _convertFont(int font) {
    switch (font) {
      case 0: return EpsonConstants.FONT_A;
      case 1: return EpsonConstants.FONT_B;
      case 2: return EpsonConstants.FONT_C;
      case 3: return EpsonConstants.FONT_D;
      case 4: return EpsonConstants.FONT_E;
      default: return EpsonConstants.FONT_A;
    }
  }

  void _addTextSmooth(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final bool smooth = args['smooth'] as bool;
    final printer = _getPrinter(id);
    printer.addTextSmooth(smooth);
  }

  void _addTextSize(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int width = args['width'] as int;
    final int height = args['height'] as int;
    final printer = _getPrinter(id);
    printer.addTextSize(width, height);
  }

  void _addTextStyle(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final bool reverse = (args['reverse'] as bool?) ?? false;
    final bool underline = (args['underline'] as bool?) ?? false;
    final bool bold = (args['bold'] as bool?) ?? false;
    final int? color = args['color'] as int?;

    final printer = _getPrinter(id);
    final colorValue = _convertColor(color);
    printer.addTextStyle(reverse, underline, bold, colorValue);
  }

  String _convertColor(int? color) {
    if (color == null) return EpsonConstants.COLOR_NONE;

    switch (color) {
      case 0: return EpsonConstants.COLOR_NONE;
      case 1: return EpsonConstants.COLOR_1;
      case 2: return EpsonConstants.COLOR_2;
      case 3: return EpsonConstants.COLOR_3;
      case 4: return EpsonConstants.COLOR_4;
      default: return EpsonConstants.COLOR_NONE;
    }
  }

  void _addHPosition(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int position = args['position'] as int;
    final printer = _getPrinter(id);
    printer.addTextPosition(position);
  }

  void _addFeedUnit(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int unit = args['unit'] as int;
    final printer = _getPrinter(id);
    printer.addFeedUnit(unit);
  }

  void _addFeedLine(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int line = args['line'] as int;
    final printer = _getPrinter(id);
    printer.addFeedLine(line);
  }

  void _addCut(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int cutType = args['cutType'] as int;

    final printer = _getPrinter(id);
    final cutValue = _convertCutType(cutType);
    printer.addCut(cutValue);
  }

  String _convertCutType(int cutType) {
    switch (cutType) {
      case 0: return EpsonConstants.CUT_NO_FEED;
      case 1: return EpsonConstants.CUT_FEED;
      case 2: return EpsonConstants.CUT_RESERVE;
      default: return EpsonConstants.CUT_FEED;
    }
  }

  void _addCommand(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String command = args['command'] as String;
    final printer = _getPrinter(id);
    printer.addCommand(command);
  }

  EpsonPrinter _getPrinter(int id) {
    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    if (instance.printer == null) {
      throw PlatformException(
        code: 'NOT_CONNECTED',
        message: 'Printer not connected. Call connect() first.',
      );
    }

    return instance.printer!;
  }

  bool _isEpsonSDKLoaded() {
    try {
      return epsonSDK != null && epsonDevice != null;
    } catch (_) {
      return false;
    }
  }
}

class _WebPrinterInstance {
  final EpsonEPOSDevice? eposDevice;
  EpsonPrinter? printer;
  final int series;
  final int model;
  bool isConnected;

  _WebPrinterInstance({
    required this.eposDevice,
    required this.printer,
    required this.series,
    required this.model,
    required this.isConnected,
  });
}
