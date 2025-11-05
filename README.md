# epson_pos_printer

A Flutter plugin to connect to and print from Epson POS printers using the Epson ePOS SDK. This plugin supports iOS, Android, and Web platforms.

## Features

- 🔍 **Discover** Epson POS printers on your network
- 🔌 **Connect** via Bluetooth (iOS/Android) or TCP/IP (all platforms)
- 🖨️ **Print** with full formatting support:
  - Text alignment (left, center, right)
  - Text size and font selection
  - Bold, underline, reverse styles
  - Line spacing and positioning
  - Paper feed and cut commands
  - Raw ESC/POS commands
- 📊 **Monitor** printer status in real-time
- 🌐 **Web support** with Epson ePOS SDK for JavaScript

## Supported Platforms

| Platform | Discovery | Bluetooth | TCP/IP | USB |
|----------|-----------|-----------|--------|-----|
| **iOS** | ✅ | ✅ | ✅ | ❌ |
| **Android** | ✅ | ✅ | ✅ | ✅ |
| **Web** | ✅ (network only) | ❌ | ✅ | ❌ |

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  epson_pos_printer:
    git:
      url: https://github.com/your-repo/epson_pos_printer.git
      ref: main
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:epson_pos_printer/epson_pos_printer.dart';

// 1. Discover printers
final devices = await discoverEpos2Devices(
  Epos2FilterOption(
    portType: Epos2PortType.tcp,
    deviceType: Epos2DeviceType.printer,
  ),
).toList();

// 2. Create and connect to printer
final printer = await Epos2Printer.create(
  series: Epos2PrinterSeries.tm_m30,
  model: Epos2PrinterModel.tm_m30,
);

await printer.connect(
  target: devices.first.target,
  timeout: const Duration(seconds: 15),
);

// 3. Build print job
printer.addTextAlign(Epos2TextAlign.center);
printer.addTextSize(width: 2, height: 2);
printer.addText('Hello World!\n');
printer.addTextSize(width: 1, height: 1);
printer.addText('Receipt #12345\n');
printer.addFeedLine(3);
printer.addCut(Epos2CutType.feed);

// 4. Send to printer
final status = await printer.sendData();
print('Print successful: ${status.online == 1}');

// 5. Disconnect
await printer.disconnect();
```

## Web Platform

### Quick Setup for Web

The web platform uses the Epson ePOS SDK for JavaScript to enable printing from web browsers.

**Key Points:**
- ✅ Works with network-connected printers (TCP/IP)
- ✅ All printing features supported
- ❌ Bluetooth/USB not available in browsers
- ⚠️ Requires same network connectivity

### Web-Specific Example

```dart
// Web printing works the same as mobile, but use TCP/IP
await printer.connect(
  target: '192.168.1.100',  // Printer IP address
  timeout: const Duration(seconds: 15),
);
```

### Browser Requirements

- Chrome 90+ (recommended)
- Firefox 88+
- Safari 14+
- Edge 90+

### Detailed Web Setup

For detailed web platform setup, CORS configuration, troubleshooting, and advanced topics, see:

📖 **[WEB_SETUP.md](WEB_SETUP.md)** - Complete Web Platform Guide

## Usage Examples

### Discovery

```dart
// Discover all printers
Stream<Epos2Device> stream = discoverEpos2Devices(
  Epos2FilterOption(
    portType: Epos2PortType.all,
    deviceType: Epos2DeviceType.printer,
  ),
);

await for (var device in stream) {
  print('Found: ${device.deviceName} at ${device.target}');
}
```

### Advanced Printing

```dart
// Text formatting
printer.addTextStyle(
  bold: true,
  underline: true,
  reverse: false,
);
printer.addText('Bold and Underlined\n');

// Positioning
printer.addHPosition(100);
printer.addText('At position 100\n');

// Multiple text sizes
printer.addTextSize(width: 2, height: 3);
printer.addText('Large Text\n');

// Line spacing
printer.addLineSpace(40);
printer.addText('With line spacing\n');
```

### Status Monitoring

```dart
// Listen to status changes
printer.statusStream.listen((status) {
  print('Online: ${status.online}');
  print('Paper: ${status.paper}');
  print('Cover: ${status.coverOpen}');
});
```

### Raw Commands

```dart
// Send raw ESC/POS commands
printer.addCommand('\x1B\x40'); // Initialize
printer.addCommand('\x1B\x61\x01'); // Center align
```

## Supported Printer Models

This plugin supports Epson TM series and other ePOS-compatible printers:

- TM-M30 series
- TM-M50 series
- TM-P20 series
- TM-P60 series
- TM-P80 series
- TM-T20 series
- TM-T60 series
- TM-T70 series
- TM-T81 series
- TM-T82 series
- TM-T83 series
- TM-T88 series
- TM-T90 series
- TM-T100 series
- TM-U220 series
- TM-L90 series

Check [Epson's documentation](https://download.epson-biz.com/modules/pos/index.php) for complete compatibility.

## API Reference

### Core Classes

- `Epos2Printer` - Main printer class
- `Epos2Device` - Discovered device information
- `Epos2FilterOption` - Discovery filter options
- `PrinterStatus` - Printer status information

### Key Methods

- `discoverEpos2Devices()` - Discover printers
- `Epos2Printer.create()` - Create printer instance
- `connect()` - Connect to printer
- `disconnect()` - Disconnect from printer
- `sendData()` - Send print job
- `addText()` - Add text to print
- `addTextAlign()` - Set text alignment
- `addTextSize()` - Set text size
- `addCut()` - Add paper cut

For complete API documentation, see the source code and examples.

## Troubleshooting

### Common Issues

**Printer not discovered**
- Ensure printer is on the same network
- Check printer's network settings
- Verify printer is powered on

**Connection failed**
- Check target address (IP or Bluetooth address)
- Increase timeout duration
- Verify printer is not already connected

**Print failed**
- Check printer status (paper, cover, errors)
- Ensure printer is online
- Verify commands are compatible with printer model

### Web-Specific Issues

See [WEB_SETUP.md](WEB_SETUP.md#troubleshooting) for web-specific troubleshooting.

## Example App

Check out the example app in the `example/` directory for a complete working implementation.

```bash
cd example
flutter run -d chrome  # For web
flutter run            # For mobile
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

See [LICENSE](LICENSE) file for details.

## Acknowledgments

This plugin uses the Epson ePOS SDK:
- iOS/Android: Epson ePOS SDK for native platforms
- Web: Epson ePOS SDK for JavaScript (v2.27.0)

## Support

For issues and questions:
- GitHub Issues: [Report an issue](https://github.com/your-repo/epson_pos_printer/issues)
- Epson SDK Documentation: [Epson Developer Portal](https://download.epson-biz.com/modules/pos/index.php)
