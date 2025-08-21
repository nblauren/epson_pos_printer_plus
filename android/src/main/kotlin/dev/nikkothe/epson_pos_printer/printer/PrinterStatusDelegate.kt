package dev.nikkothe.epson_pos_printer.printer

import com.epson.epos2.printer.Printer
import com.epson.epos2.printer.StatusChangeListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink


import android.util.Log


private var logTag: String = "Epson_ePOS"

class PrinterStatusDelegate(
        private val printer: Printer,
        id: Int,
        messenger: BinaryMessenger
) : StatusChangeListener, EventChannel.StreamHandler {

    private val channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    init {
        channel = EventChannel(messenger, "epson_pos_printer/printer/$id/status")
        channel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        try {
            val code = printer.startMonitor()
            eventSink = events
        } catch (e: Exception) {
            events?.error("Epos2Printer.startMonitor", e.message, null)
        }
    }

    override fun onCancel(arguments: Any?) {
        try {
            val code = printer.stopMonitor()
            eventSink = null
        } catch (e: Exception) {
            eventSink?.error("Epos2Printer.stopMonitor", e.message, null)
        }
    }

    override fun onPtrStatusChange(printerObj: Printer, eventType: Int) {
        val sink = eventSink ?: return

        try {
            sink.success(eventType)
        } catch (error: Exception) {
            sink.error("Epos2PtrStatusChangeDelegate.onPtrStatusChange", error.message, null)
        }
    }
}
