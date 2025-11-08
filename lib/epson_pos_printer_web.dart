// lib/epson_pos_printer_web.dart
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import '../web/src/discovery_manager_web.dart';
import '../web/src/printer_manager_web.dart';

class EpsonPosPrinterWeb {
  static void registerWith(Registrar registrar) {
    // Load the Epson SDK dynamically if not already loaded
    if (!_isSdkLoaded()) {
      _loadEposSdk();
    }

    // Create managers
    final discoveryManager = DiscoveryManagerWeb();
    final printerManager = PrinterManagerWeb();

    // Register discovery event channel
    const discoveryChannel = EventChannel(
      'epson_pos_printer/discovery',
      StandardMethodCodec(),
      registrar,
    );
    discoveryChannel.setStreamHandler(discoveryManager);

    // Register printer method channel
    const printerChannel = MethodChannel(
      'epson_pos_printer/printer',
      StandardMethodCodec(),
      registrar,
    );
    printerChannel.setMethodCallHandler(printerManager.handleMethodCall);

    // Register status event channels dynamically
    // We'll set up individual status channels as printers are created
    _printerManagerInstance = printerManager;
  }

  static PrinterManagerWeb? _printerManagerInstance;

  static void registerStatusChannel(Registrar registrar, int printerId) {
    if (_printerManagerInstance == null) return;

    final statusChannel = EventChannel(
      'epson_pos_printer/printer/$printerId/status',
      StandardMethodCodec(),
      registrar,
    );

    statusChannel.setStreamHandler(_StatusStreamHandler(printerId, _printerManagerInstance!));
  }

  static bool _isSdkLoaded() {
    try {
      final script = html.document.querySelector('script[src*="epos-2"]');
      return script != null;
    } catch (_) {
      return false;
    }
  }

  static void _loadEposSdk() {
    try {
      final script = html.ScriptElement()
        ..src = 'assets/packages/epson_pos_printer/sdk/epos-2.27.0.js'
        ..type = 'text/javascript'
        ..async = false;

      html.document.head?.append(script);

      script.onLoad.listen((_) {
        print('Epson ePOS SDK loaded successfully');
      });

      script.onError.listen((error) {
        print('Failed to load Epson ePOS SDK: $error');
        print('Make sure the SDK file is in the correct location:');
        print('web/sdk/epos-2.27.0.js');
      });
    } catch (e) {
      print('Error loading Epson ePOS SDK: $e');
    }
  }
}

/// Stream handler for printer status events
class _StatusStreamHandler implements StreamHandler {
  final int printerId;
  final PrinterManagerWeb printerManager;

  _StatusStreamHandler(this.printerId, this.printerManager);

  @override
  Stream<dynamic>? onListen(Object? arguments, EventSink? events) {
    final controller = printerManager.getStatusController(printerId);
    return controller?.stream;
  }

  @override
  void onCancel(Object? arguments) {
    // Status controller is managed by PrinterManager
    // It will be cleaned up when the printer is destroyed
  }
}
