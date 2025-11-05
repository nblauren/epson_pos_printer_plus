# Web Platform Setup Guide

This guide explains how to use the Epson POS Printer plugin on the web platform with the **Epson ePOS SDK for JavaScript**.

## ⚠️ Important Web Platform Limitations

The web implementation has **significant limitations** compared to iOS/Android:

### ❌ NO Automatic Printer Discovery
- **The Epson ePOS SDK for JavaScript does NOT support printer discovery**
- You **MUST** know the printer's IP address beforehand
- Browsers cannot perform network device discovery for security reasons
- Users must manually configure printer IP addresses in your application

### ✅ What IS Supported
- Direct connection via IP address and port
- All printing commands (text, formatting, cut, feed, etc.)
- Real-time status monitoring
- TCP/IP network printers only

## Requirements

### Browser Requirements
- Modern web browser with JavaScript enabled
- **Tested browsers:**
  - Chrome 90+ (recommended)
  - Firefox 88+
  - Edge 90+
  - Safari 14+ (may have CORS issues)

### Network Requirements
- Epson printer with TCP/IP network interface
- Printer and web browser on same network (or properly configured routing)
- Printer's IP address must be known
- Default port: **8008** (HTTP) or **8043** (HTTPS/SSL)

### Printer Requirements
- Epson POS printer with network capability
- ePOS-compatible printer models (TM series, etc.)
- Printer's embedded web server enabled

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

3. The Epson ePOS SDK JavaScript file is automatically included

## Usage

### Basic Example (Web Platform)

**IMPORTANT**: On web, you **cannot discover printers**. You must connect directly with a known IP address.

```dart
import 'package:epson_pos_printer/epson_pos_printer.dart';

// Create printer instance
final printer = await Epos2Printer.create(
  series: Epos2PrinterSeries.tm_m30,
  model: Epos2PrinterModel.tm_m30,
);

// Connect directly using IP address (NO discovery on web!)
await printer.connect(
  target: '192.168.1.100',  // Your printer's IP address
  timeout: const Duration(seconds: 15),
);

// Build print job
printer.addTextAlign(Epos2TextAlign.center);
printer.addText('Hello from web!\n');
printer.addCut(Epos2CutType.feed);

// Send to printer
final status = await printer.sendData();
print('Print successful: ${status.online == 1}');

// Disconnect
await printer.disconnect();
```

### Connection Targets

```dart
// Format: IP address only (uses default port 8008)
await printer.connect(target: '192.168.1.100');

// Format: IP:port (explicit port)
await printer.connect(target: '192.168.1.100:8008');

// For SSL/HTTPS (port 8043)
await printer.connect(target: '192.168.1.100:8043');
```

### How to Get Printer IP Address

Since discovery doesn't work on web, users must find the printer IP manually:

1. **Print Configuration Page**: Most Epson printers can print a network configuration page
2. **Printer's LCD Panel**: Some printers display IP on screen
3. **Router Admin Page**: Check connected devices in router settings
4. **Network Scanner**: Use external tools like `nmap` or `Advanced IP Scanner`
5. **Static IP**: Configure printer with static IP for consistency

### Handling "Discovery Not Supported" Error

```dart
try {
  // This will fail on web!
  final devices = await discoverEpos2Devices(
    Epos2FilterOption(portType: Epos2PortType.tcp),
  ).toList();
} on PlatformException catch (e) {
  if (e.code == 'NOT_SUPPORTED') {
    // On web, show IP input dialog to user
    final ipAddress = await showIpInputDialog();
    await printer.connect(target: ipAddress);
  }
}
```

### Recommended Web UI Pattern

```dart
class WebPrinterSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Web Platform: Manual IP Configuration Required'),
        TextField(
          decoration: InputDecoration(
            labelText: 'Printer IP Address',
            hintText: '192.168.1.100',
          ),
          onChanged: (ip) => printerIpAddress = ip,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Port (default: 8008)',
            hintText: '8008',
          ),
          onChanged: (port) => printerPort = port,
        ),
        ElevatedButton(
          onPressed: () async {
            await printer.connect(
              target: '$printerIpAddress:$printerPort',
            );
          },
          child: Text('Connect to Printer'),
        ),
      ],
    );
  }
}
```

## Web-Specific Considerations

### 1. No Discovery = Manual Configuration

**Reality**: Web browsers cannot scan networks for devices.

**Solution**:
- Provide UI for users to enter printer IP
- Save printer IPs in local storage
- Consider QR code scanning for easy configuration

### 2. CORS Configuration

If your web app and printer are on different domains, configure CORS:

**Option 1: Printer Configuration**
- Access printer's web interface (http://printer-ip)
- Enable CORS if available
- Add your domain to allowed origins

**Option 2: Same Origin**
- Host your web app on same network
- Use relative addressing

**⚠️ Development Only:**
```bash
# NEVER do this in production!
chrome --disable-web-security --user-data-dir=/tmp/chrome-dev
```

### 3. HTTPS Requirements

Some printer operations may require HTTPS:
- Use port 8043 for SSL connections
- Ensure your web app uses HTTPS in production
- Mixed content (HTTPS site → HTTP printer) may be blocked

### 4. Port Numbers

| Port | Protocol | Usage |
|------|----------|-------|
| 8008 | HTTP | Default, most common |
| 8043 | HTTPS/SSL | Secure connections |
| 80 | HTTP | Alternative (less common) |
| 443 | HTTPS | Alternative (less common) |

## Architecture (How It Actually Works)

```
Flutter App (Dart)
       ↓
  MethodChannel / EventChannel
       ↓
 epson_pos_printer_web.dart
       ↓
  EpsonEPOSDevice (JavaScript interop)
       ↓
  new epson.ePOSDevice()
       ↓
  eposDevice.connect(ip, port, callback)
       ↓
  eposDevice.createDevice(deviceId, type, options, callback)
       ↓
  printer.addText(...) / printer.send()
       ↓
  Epson ePOS SDK JavaScript (epos-2.27.0.js)
       ↓
  HTTP/WebSocket to Printer
       ↓
  Epson Network Printer
```

## Troubleshooting

### "SDK Not Loaded" Error

**Solutions**:
1. Verify SDK file exists at `web/sdk/epos-2.27.0.js`
2. Check browser console for load errors
3. Ensure `assets` are properly configured in `pubspec.yaml`
4. Clear browser cache

### "Connection Failed" Error

**Common causes:**
1. Wrong IP address → Double-check printer IP
2. Wrong port → Try 8008 (default) or 8043 (SSL)
3. Firewall blocking → Check network/firewall settings
4. Printer offline → Verify printer is powered and connected
5. Network mismatch → Ensure same network or proper routing

### CORS Errors

**Symptoms**: Console shows "CORS policy" errors

**Solutions**:
1. Configure printer to allow your domain
2. Host web app on same network as printer
3. Use proxy server in development

### Print Fails Silently

**Check**:
1. Printer status (paper, cover, errors)
2. Network connectivity
3. Console for JavaScript errors
4. Printer's web interface for status

## Comparison: Web vs Native

| Feature | Web | iOS/Android |
|---------|-----|-------------|
| **Discovery** | ❌ None | ✅ Automatic |
| **Bluetooth** | ❌ | ✅ |
| **USB** | ❌ | ✅ |
| **TCP/IP** | ✅ | ✅ |
| **Print Commands** | ✅ All | ✅ All |
| **Status Events** | ✅ | ✅ |
| **Setup Complexity** | 🟡 Manual IP | 🟢 Auto-discover |

## Best Practices

1. **Save Printer IPs**: Store configured printer IPs in local storage
2. **Connection Pooling**: Reuse ePOSDevice connections when possible
3. **Error Handling**: Provide clear error messages to users
4. **Timeouts**: Set appropriate timeouts based on network
5. **Testing**: Test on actual network printer, not simulators
6. **Documentation**: Clearly document IP configuration requirements for users

## Example: Complete Web Printing Flow

```dart
class WebPrinterService {
  Epos2Printer? _printer;

  Future<void> setupPrinter(String ipAddress) async {
    _printer = await Epos2Printer.create(
      series: Epos2PrinterSeries.tm_m30,
      model: Epos2PrinterModel.tm_m30,
    );

    try {
      await _printer!.connect(
        target: ipAddress,
        timeout: Duration(seconds: 15),
      );
      print('Connected to printer at $ipAddress');
    } catch (e) {
      print('Connection failed: $e');
      rethrow;
    }
  }

  Future<void> printReceipt(String content) async {
    if (_printer == null) {
      throw Exception('Printer not initialized');
    }

    _printer!.addTextAlign(Epos2TextAlign.center);
    _printer!.addText(content);
    _printer!.addFeedLine(3);
    _printer!.addCut(Epos2CutType.feed);

    try {
      final status = await _printer!.sendData();
      if (status.online != 1) {
        throw Exception('Printer offline');
      }
    } catch (e) {
      print('Print failed: $e');
      rethrow;
    }
  }

  Future<void> dispose() async {
    if (_printer != null) {
      await _printer!.disconnect();
      _printer = null;
    }
  }
}
```

## Support

For web platform issues:
- Verify IP address and port
- Check browser console for errors
- Test printer's web interface (http://printer-ip)
- Ensure network connectivity

For general issues:
- See main README.md
- Check GitHub issues
- Consult Epson ePOS SDK documentation

## References

- [Epson ePOS SDK for JavaScript Documentation](https://download4.epson.biz/sec_pubs/pos/reference_en/epos_js/index.html)
- [Flutter Web Documentation](https://flutter.dev/web)
- [Dart JavaScript Interop](https://dart.dev/web/js-interop)
