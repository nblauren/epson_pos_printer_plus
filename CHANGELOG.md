## 0.0.1

### Added
- ✅ **Web Platform Support**: Web implementation using Epson ePOS SDK for JavaScript (v2.27.0)
  - All 21 printer command methods implemented
  - Real-time status monitoring
  - Event-based architecture with proper cleanup
  - Corrected to use actual Epson ePOS JavaScript API

- 🖨️ **Complete Printing API**:
  - Text alignment (left, center, right)
  - Text size and font selection
  - Text styles (bold, underline, reverse, color)
  - Line spacing and positioning
  - Paper feed and cut commands
  - Raw ESC/POS command support

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
  - Clear documentation of web limitations

### Fixed
- **Corrected Web API Implementation**: Rewrote web implementation to match actual Epson ePOS SDK for JavaScript API
  - Fixed: Now uses `epson.ePOSDevice()` → `connect()` → `createDevice()` flow
  - Fixed: Removed non-existent Discovery API (web requires manual IP configuration)
  - Fixed: Proper JavaScript interop with correct method signatures
  - Fixed: String-based constants for alignment, fonts, colors, cut types

### Platform Support
- iOS: Native Epson ePOS SDK (with discovery)
- Android: Native Epson ePOS SDK (with discovery)
- Web: Epson ePOS SDK for JavaScript (v2.27.0) - **NO discovery, manual IP required**

### Technical Details
- JavaScript interop layer with @JS annotations matching real SDK API
- Proper async/await support using JavaScript callbacks
- Event-based status monitoring via onstatuschange callback
- Automatic SDK loading for web
- Clean resource management with ePOSDevice lifecycle

### Web Platform Limitations
- ❌ **NO automatic printer discovery** - requires known IP address
- ❌ Bluetooth not supported (browser limitation)
- ❌ USB not supported (browser limitation)
- ✅ TCP/IP network printers only (IP:port connection)
- ⚠️ CORS configuration may be required
- Tested on Chrome 90+, Firefox 88+, Safari 14+, Edge 90+

### Breaking Changes
- Web: Discovery will return `NOT_SUPPORTED` error - applications must provide UI for manual IP entry
