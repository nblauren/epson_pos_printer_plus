package dev.nikkothe.epson_pos_printer.printer

import com.epson.epos2.printer.Printer

fun safeDispose(printer: Printer) {
    printer.setStatusChangeEventListener(null)
    printer.setReceiveEventListener(null)
    printer.setConnectionEventListener(null)
    printer.clearCommandBuffer()
    printer.disconnect()
}
