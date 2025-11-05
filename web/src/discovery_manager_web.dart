// web/src/discovery_manager_web.dart
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class DiscoveryManagerWeb implements StreamHandler {
  StreamController<Map<String, dynamic>>? _controller;

  @override
  Stream<dynamic>? onListen(Object? arguments, EventSink? events) {
    // Close any existing controller
    _controller?.close();

    _controller = StreamController<Map<String, dynamic>>.broadcast();

    // IMPORTANT: The Epson ePOS SDK for JavaScript does NOT support
    // automatic printer discovery like the iOS/Android SDKs do.
    //
    // Web applications must connect to printers using known IP addresses.
    // Users should manually configure printer IP addresses in their application.
    //
    // This is a fundamental limitation of web browsers - they cannot
    // perform network device discovery for security reasons.

    // Immediately send an error to inform the user
    Future.microtask(() {
      events?.addError(
        PlatformException(
          code: 'NOT_SUPPORTED',
          message: 'Printer discovery is not supported on web platform. '
              'The Epson ePOS SDK for JavaScript requires a known printer IP address. '
              'Please connect directly using printer.connect(target: "192.168.1.100") '
              'where the target is your printer\'s IP address.',
          details: {
            'platform': 'web',
            'reason': 'Browser security restrictions prevent automatic network device discovery',
            'solution': 'Use direct IP connection: printer.connect(target: "PRINTER_IP")',
            'port_default': '8008',
            'port_ssl': '8043',
          },
        ),
      );

      // Close the stream after sending the error
      _controller?.close();
    });

    return _controller?.stream;
  }

  @override
  void onCancel(Object? arguments) {
    _controller?.close();
    _controller = null;
  }
}
