## 0.0.1

### Added
- ✅ **Web Platform Support**: Complete web implementation using Epson ePOS SDK for JavaScript
  - Full printer discovery via network (TCP/IP)
  - All 21 printer command methods implemented
  - Real-time status monitoring
  - Event-based architecture with proper cleanup

- 🖨️ **Complete Printing API**:
  - Text alignment (left, center, right)
  - Text size and font selection
  - Text styles (bold, underline, reverse, color)
  - Line spacing and positioning
  - Paper feed and cut commands
  - Raw ESC/POS command support

- 🔍 **Device Discovery**:
  - Network printer discovery
  - Filter by port type, device type, and model
  - Stream-based device discovery API

- 📊 **Status Monitoring**:
  - Real-time printer status updates
  - Connection status
  - Paper and cover status
  - Error detection

- 📚 **Documentation**:
  - Comprehensive README with web platform guide
  - Detailed WEB_SETUP.md for web-specific configuration
  - CORS troubleshooting
  - Browser compatibility information

### Platform Support
- iOS: Native Epson ePOS SDK
- Android: Native Epson ePOS SDK
- Web: Epson ePOS SDK for JavaScript (v2.27.0)

### Technical Details
- JavaScript interop layer with @JS annotations
- Proper async/await support for all platforms
- Event-based status monitoring
- Automatic SDK loading for web
- Clean resource management

### Notes
- Web platform requires network-connected printers (TCP/IP)
- Bluetooth and USB not supported on web (browser limitations)
- Tested on Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
