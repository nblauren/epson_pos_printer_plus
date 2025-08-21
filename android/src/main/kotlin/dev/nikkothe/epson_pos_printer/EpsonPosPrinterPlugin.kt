package dev.nikkothe.epson_pos_printer

import dev.nikkothe.epson_pos_printer.discovery.EposDiscoveryManager
import dev.nikkothe.epson_pos_printer.printer.EposPrinterManager
import io.flutter.embedding.engine.plugins.FlutterPlugin

class EpsonPosPrinterPlugin : FlutterPlugin {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    EposDiscoveryManager.registerWith(binding)
    EposPrinterManager.registerWith(binding)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // Clean up if necessary
  }
}
