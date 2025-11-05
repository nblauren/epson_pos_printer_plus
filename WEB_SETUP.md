# Web Platform Setup Guide

This guide explains how to use the Epson POS Printer plugin on the web platform.

## Overview

The web implementation uses the **Epson ePOS SDK for JavaScript** (version 2.27.0) to communicate with Epson POS printers over the network. The SDK is included in this package at `web/sdk/epos-2.27.0.js`.

## Requirements

### Browser Requirements
- Modern web browser with JavaScript enabled
- Browsers tested:
  - Chrome/Edge (recommended)
  - Firefox
  - Safari

### Network Requirements
- Epson printer must be connected to the same network as the web browser
- Printer must have network printing enabled (TCP/IP)
- CORS must be configured if printer and web app are on different domains

### Printer Requirements
- Epson POS printer with network capability
- ePOS-compatible printer models (TM series, etc.)
- Printer's web server must be enabled

## Installation

1. Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  epson_pos_printer:
    git:
      url: https://github.com/your-repo/epson_pos_printer.git
      ref: main
```

2. Run `flutter pub get`

3. The Epson ePOS SDK JavaScript file is automatically included as an asset

## Usage

### Basic Example

```dart
import 'package:epson_pos_printer/epson_pos_printer.dart';

// Discover printers on the network
final devices = await discoverEpos2Devices(
  Epos2FilterOption(
    portType: Epos2PortType.tcp,
    deviceType: Epos2DeviceType.printer,
  ),
).toList();

// Create printer instance
final printer = await Epos2Printer.create(
  series: Epos2PrinterSeries.tm_m30,
  model: Epos2PrinterModel.tm_m30,
);

// Connect to printer
await printer.connect(
  target: devices.first.target,
  timeout: const Duration(seconds: 15),
);

// Print text
printer.addText('Hello from web!\n');
printer.addCut(Epos2CutType.feed);

// Send print job
final status = await printer.sendData();
print('Print status: ${status.online}');

// Disconnect
await printer.disconnect();
```

## Web-Specific Considerations

### 1. Discovery Limitations

**Network Discovery Only**: Web browsers cannot directly access USB or Bluetooth devices. Discovery only works for network-connected printers (TCP/IP).

**Same Network Required**: The web browser and printer must be on the same local network for discovery to work.

### 2. Connection Methods

**TCP/IP Only**: On web, only TCP/IP connections are supported.

```dart
// Example connection targets for web:
await printer.connect(
  target: '192.168.1.100',  // Direct IP
  timeout: const Duration(seconds: 15),
);
```

### 3. CORS Configuration

If your web app and printer are on different domains, you may need to configure CORS:

**Option 1: Use Printer's Web Interface**
- Access printer's web interface (e.g., http://printer-ip)
- Enable CORS in security settings
- Add your web app's domain to allowed origins

**Option 2: Development Proxy**
For development, you can use a proxy:

```bash
# Using Chrome with CORS disabled (development only)
chrome --disable-web-security --user-data-dir=/tmp/chrome-dev
```

**⚠️ WARNING**: Never disable CORS in production!

### 4. Security Considerations

**HTTPS Required**: Some browsers require HTTPS for network printing features.

**Mixed Content**: If your site uses HTTPS, ensure printer communication uses secure protocols.

## Browser Compatibility

| Browser | Support | Notes |
|---------|---------|-------|
| Chrome 90+ | ✅ Full | Recommended |
| Edge 90+ | ✅ Full | Recommended |
| Firefox 88+ | ✅ Full | Works well |
| Safari 14+ | ⚠️ Partial | May have CORS issues |
| Mobile browsers | ❌ Limited | Not recommended |

## Troubleshooting

### SDK Not Loaded Error

**Error**: `Epson ePOS SDK not loaded`

**Solutions**:
1. Check browser console for JavaScript errors
2. Verify SDK file is accessible at `assets/packages/epson_pos_printer/sdk/epos-2.27.0.js`
3. Clear browser cache and reload

### Discovery Not Finding Printers

**Solutions**:
1. Verify printer is on the same network
2. Check printer's IP address is accessible (ping test)
3. Ensure printer's web server is enabled
4. Check firewall settings

### Connection Failed

**Solutions**:
1. Verify target IP address is correct
2. Check printer is powered on and ready
3. Try direct IP instead of hostname
4. Increase timeout duration
5. Check CORS configuration

### Print Failed

**Solutions**:
1. Check printer status (paper, cover, errors)
2. Verify printer is online
3. Reduce print job size
4. Check command compatibility

## Advanced Configuration

### Custom SDK Loading

If you need to load the SDK from a different location:

```html
<!-- Add to your web/index.html -->
<script src="path/to/custom/epos-2.27.0.js"></script>
```

### Printer Connection Pooling

For high-volume printing, consider maintaining persistent connections:

```dart
class PrinterPool {
  final Map<String, Epos2Printer> _printers = {};

  Future<Epos2Printer> getOrConnect(String target) async {
    if (_printers.containsKey(target)) {
      return _printers[target]!;
    }

    final printer = await Epos2Printer.create(/* ... */);
    await printer.connect(target: target);
    _printers[target] = printer;
    return printer;
  }
}
```

## Limitations

Compared to native platforms (iOS/Android), the web platform has these limitations:

| Feature | Web | Native |
|---------|-----|--------|
| USB Connection | ❌ | ✅ |
| Bluetooth | ❌ | ✅ |
| TCP/IP Network | ✅ | ✅ |
| Auto Discovery | ⚠️ Local only | ✅ |
| Background Printing | ❌ | ✅ |
| Offline Queue | ❌ | ✅ |

## Performance Tips

1. **Reuse Connections**: Keep printer connections alive for multiple print jobs
2. **Batch Commands**: Group multiple print commands before sending
3. **Optimize Images**: Compress images before sending to printer
4. **Handle Timeouts**: Set appropriate timeouts based on network conditions
5. **Error Recovery**: Implement retry logic for network failures

## Support

For issues specific to web platform:
- Check browser console for errors
- Verify Epson ePOS SDK compatibility
- Review network configuration
- Test with different browsers

For general plugin issues:
- See main README.md
- Check GitHub issues
- Review example app

## References

- [Epson ePOS SDK Documentation](https://download.epson-biz.com/modules/pos/index.php?page=soft&pcat=3)
- [Flutter Web Documentation](https://flutter.dev/web)
- [JavaScript Interop in Dart](https://dart.dev/web/js-interop)
