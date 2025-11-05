// web/src/discovery_manager_web.dart
import 'dart:async';
import 'dart:js_util' as js_util;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js.dart';
import 'epson_epos_interop.dart';

class DiscoveryManagerWeb implements StreamHandler {
  StreamController<Map<String, dynamic>>? _controller;
  EpsonDiscovery? _discovery;
  bool _isDiscovering = false;

  @override
  Stream<dynamic>? onListen(Object? arguments, EventSink? events) {
    // Close any existing controller
    _controller?.close();

    _controller = StreamController<Map<String, dynamic>>(
      onCancel: () {
        _stopDiscovery();
      },
    );

    // Parse filter options from arguments
    final Map<String, dynamic>? filterArgs = arguments as Map<String, dynamic>?;

    // Start discovery
    _startDiscovery(filterArgs, events);

    return _controller?.stream;
  }

  @override
  void onCancel(Object? arguments) {
    _stopDiscovery();
    _controller?.close();
    _controller = null;
  }

  void _startDiscovery(Map<String, dynamic>? filterArgs, EventSink? events) {
    if (!_isEpsonSDKLoaded()) {
      events?.addError(
        PlatformException(
          code: 'SDK_NOT_LOADED',
          message: 'Epson ePOS SDK not loaded. Make sure the SDK JavaScript file is included.',
        ),
      );
      return;
    }

    if (_isDiscovering) {
      return;
    }

    try {
      _discovery = EpsonDiscovery();
      _isDiscovering = true;

      // Build filter option
      final filterOption = _buildFilterOption(filterArgs);

      // Callback when a device is found
      final onDeviceFound = allowInterop((dynamic device) {
        try {
          final deviceMap = _convertDeviceToMap(device);
          _controller?.add(deviceMap);
          events?.add(deviceMap);
        } catch (e) {
          // Silently ignore errors in device conversion
        }
      });

      // Callback when discovery is complete
      final onComplete = allowInterop((dynamic result) {
        _isDiscovering = false;
        // Discovery complete, but keep the stream open
        // The stream will be closed when the user cancels it
      });

      // Start the discovery process
      _discovery!.start(filterOption, onDeviceFound, onComplete);
    } catch (e) {
      _isDiscovering = false;
      events?.addError(
        PlatformException(
          code: 'DISCOVERY_ERROR',
          message: 'Failed to start discovery: $e',
        ),
      );
    }
  }

  void _stopDiscovery() {
    if (_discovery != null && _isDiscovering) {
      try {
        _discovery!.stop();
      } catch (_) {}
      _isDiscovering = false;
    }
  }

  DiscoveryFilterOption _buildFilterOption(Map<String, dynamic>? filterArgs) {
    if (filterArgs == null) {
      // Default: discover all printers
      return DiscoveryFilterOption(
        portType: EpsonDiscovery.PORTTYPE_ALL,
        deviceType: EpsonDiscovery.DEVTYPE_PRINTER,
        deviceModel: EpsonDiscovery.MODEL_ALL,
      );
    }

    final int? portType = filterArgs['portType'] as int?;
    final String? broadcast = filterArgs['broadcast'] as String?;
    final int? deviceModel = filterArgs['deviceModel'] as int?;
    final int? deviceType = filterArgs['deviceType'] as int?;

    return DiscoveryFilterOption(
      portType: portType ?? EpsonDiscovery.PORTTYPE_ALL,
      broadcast: broadcast,
      deviceModel: deviceModel ?? EpsonDiscovery.MODEL_ALL,
      deviceType: deviceType ?? EpsonDiscovery.DEVTYPE_PRINTER,
    );
  }

  Map<String, dynamic> _convertDeviceToMap(dynamic device) {
    return {
      'deviceType': js_util.getProperty<int>(device, 'deviceType') ?? 0,
      'target': js_util.getProperty<String>(device, 'target') ?? '',
      'deviceName': js_util.getProperty<String>(device, 'deviceName') ?? '',
      'ipAddress': js_util.getProperty<String>(device, 'ipAddress') ?? '',
      'macAddress': js_util.getProperty<String>(device, 'macAddress') ?? '',
      'bdAddress': js_util.getProperty<String>(device, 'bdAddress') ?? '',
    };
  }

  bool _isEpsonSDKLoaded() {
    try {
      return epsonSDK != null && epsonDevice != null;
    } catch (_) {
      return false;
    }
  }
}
