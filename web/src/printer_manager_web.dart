// web/src/printer_manager_web.dart
import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:flutter/services.dart';
import 'package:js/js.dart';
import 'epson_epos_interop.dart';

class PrinterManagerWeb {
  // Store printer instances and their metadata
  final Map<int, _WebPrinterInstance> _printers = {};
  int _nextPrinterId = 0;

  // Store status event channels
  final Map<int, EventChannel> _statusChannels = {};
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
        instance.printer.disconnect();
      } catch (_) {}
    }
    _printers.clear();

    // Clean up all status controllers
    for (var controller in _statusControllers.values) {
      controller.close();
    }
    _statusControllers.clear();
    _statusChannels.clear();

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
    final printer = EpsonPrinter();

    // Set default timeout
    printer.timeout = 10000;

    // Store the printer instance
    _printers[printerId] = _WebPrinterInstance(
      printer: printer,
      series: series,
      model: model,
    );

    // Setup status change listener
    _setupStatusListener(printerId, printer);

    return printerId;
  }

  void _setupStatusListener(int printerId, EpsonPrinter printer) {
    // Create status event handler
    printer.onstatuschange = allowInterop((dynamic status) {
      final controller = _statusControllers[printerId];
      if (controller != null && !controller.isClosed) {
        final statusMap = <String, dynamic>{
          'connection': js_util.getProperty(status, 'connection'),
          'online': js_util.getProperty(status, 'online'),
          'coverOpen': js_util.getProperty(status, 'coverOpen'),
          'paper': js_util.getProperty(status, 'paper'),
          'paperFeed': js_util.getProperty(status, 'paperFeed'),
          'panelSwitch': js_util.getProperty(status, 'panelSwitch'),
          'drawer': js_util.getProperty(status, 'drawer'),
          'errorStatus': js_util.getProperty(status, 'errorStatus'),
          'autoRecoverErr': js_util.getProperty(status, 'autoRecoverErr'),
          'adapter': js_util.getProperty(status, 'adapter'),
          'batteryLevel': js_util.getProperty(status, 'batteryLevel'),
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
      instance.printer.disconnect();
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

    final completer = Completer<void>();

    // Set timeout
    instance.printer.timeout = timeout;

    // Connect to printer
    // Mode: 0 = no crypto, 1 = crypto
    final result = instance.printer.connect(target, 0, allowInterop((dynamic response) {
      final success = js_util.getProperty<bool>(response, 'success');
      if (success) {
        completer.complete();
      } else {
        final code = js_util.getProperty<String>(response, 'code');
        completer.completeError(
          PlatformException(
            code: 'CONNECTION_FAILED',
            message: 'Failed to connect to printer: $code',
          ),
        );
      }
    }));

    if (result != 0) {
      throw PlatformException(
        code: 'CONNECTION_ERROR',
        message: 'Failed to initiate connection: error code $result',
      );
    }

    return completer.future;
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

    instance.printer.disconnect();
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

    final completer = Completer<Map<String, dynamic>>();

    // Set timeout
    instance.printer.timeout = timeout;

    // Setup receive callback
    instance.printer.onreceive = allowInterop((dynamic response) {
      final success = js_util.getProperty<bool>(response, 'success');
      final code = js_util.getProperty<String>(response, 'code');
      final status = js_util.getProperty(response, 'status');

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
    instance.printer.onerror = allowInterop((dynamic error) {
      final code = js_util.getProperty<String>(error, 'code');
      completer.completeError(
        PlatformException(
          code: 'PRINT_ERROR',
          message: 'Print error: $code',
        ),
      );
    });

    // Send the print data
    final result = instance.printer.send();
    if (result != 0) {
      throw PlatformException(
        code: 'SEND_ERROR',
        message: 'Failed to send print data: error code $result',
      );
    }

    return completer.future;
  }

  Map<String, dynamic> _convertStatus(dynamic status) {
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

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.clearCommandBuffer();
  }

  void _addText(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String data = args['data'] as String;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addText(data);
  }

  void _addTextAlign(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int align = args['align'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextAlign(align);
  }

  void _addLineSpace(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int space = args['space'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextLineSpace(space);
  }

  void _addTextRotate(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int rotate = args['rotate'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextRotate(rotate == 1);
  }

  void _addTextLang(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int lang = args['lang'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextLang(lang);
  }

  void _addTextFont(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int font = args['font'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextFont(font);
  }

  void _addTextSmooth(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final bool smooth = args['smooth'] as bool;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextSmooth(smooth);
  }

  void _addTextSize(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int width = args['width'] as int;
    final int height = args['height'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextSize(width, height);
  }

  void _addTextStyle(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final bool reverse = (args['reverse'] as bool?) ?? false;
    final bool underline = (args['underline'] as bool?) ?? false;
    final bool bold = (args['bold'] as bool?) ?? false;
    final int? color = args['color'] as int?;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addTextStyle(reverse, underline, bold, color);
  }

  void _addHPosition(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int position = args['position'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addHPosition(position);
  }

  void _addFeedUnit(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int unit = args['unit'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addFeedUnit(unit);
  }

  void _addFeedLine(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int line = args['line'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addFeedLine(line);
  }

  void _addCut(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final int cutType = args['cutType'] as int;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addCut(cutType);
  }

  void _addCommand(dynamic arguments) {
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String command = args['command'] as String;

    final instance = _printers[id];
    if (instance == null) {
      throw PlatformException(
        code: 'PrinterNotFound',
        message: 'No printer found with ID $id',
      );
    }

    instance.printer.addCommand(command);
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
  final EpsonPrinter printer;
  final int series;
  final int model;

  _WebPrinterInstance({
    required this.printer,
    required this.series,
    required this.model,
  });
}
