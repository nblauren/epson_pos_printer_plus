// web/epson_pos_printer_web.dart
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/discovery_manager_web.dart';
import 'src/printer_manager_web.dart';

class EpsonPosPrinterWeb {
  static void registerWith(Registrar registrar) {
    // Load the Epson SDK dynamically if not already loaded
    if (!_isSdkLoaded()) {
      _loadEposSdk();
    }
    // Register discovery manager
    const discoveryChannel = EventChannel('epson_pos_printer/discovery');
    discoveryChannel.setStreamHandler(DiscoveryManagerWeb());

    // Register printer manager
    const printerChannel = MethodChannel('epson_pos_printer/printer');
    final printerManagerWeb = PrinterManagerWeb();
    printerChannel.setMethodCallHandler(printerManagerWeb.handleMethodCall);
  }

  static bool _isSdkLoaded() {
    return html.document.querySelector('script[src*="epos-2"]') != null;
  }

  static void _loadEposSdk() {
    final script = html.ScriptElement()
      ..src = 'web/sdk/epos-2.27.0.js'
      ..type = 'text/javascript';

    html.document.head?.append(script);

    // You might want to wait for the script to load before initializing
    script.onLoad.listen((_) {
      print('Epson ePOS SDK loaded successfully');
    });
  }
}
