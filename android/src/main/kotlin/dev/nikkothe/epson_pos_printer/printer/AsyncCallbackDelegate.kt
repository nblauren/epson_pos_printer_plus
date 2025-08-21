package dev.nikkothe.epson_pos_printer.printer

import com.epson.epos2.printer.Printer
import com.epson.epos2.printer.PrinterStatusInfo
import com.epson.epos2.printer.ReceiveListener

class PrinterAsyncDelegate(
    private val callback: FlutterAsyncCallback,
    private val printer: Printer
) : ReceiveListener {

    init {
        printer.setReceiveEventListener(this)
    }

    override fun onPtrReceive(printerObj: Printer?, code: Int, status: PrinterStatusInfo?, printJobId: String?) {
        // Callback should be only called once, it should be cleared after the use
        printer.setReceiveEventListener(null)

        try {
            val printerStatus = mapOf(
                "printerJobId" to printJobId,
                "connection" to (status?.connection == 1),
                "online" to (status?.online == 1),
                "coverOpen" to (status?.coverOpen == 1),
                "paper" to status?.paper,
                "paperFeed" to (status?.paperFeed == 0),
                "panelSwitch" to (status?.panelSwitch == 0),
                "waitOnline" to (status?.waitOnline?.toInt() ?: 0),
                "drawer" to (status?.drawer == 0),
                "errorStatus" to status?.errorStatus,
                "autoRecoverError" to status?.autoRecoverError,
                "buzzer" to (status?.buzzer == 0),
                "adapter" to (status?.adapter == 0),
                "batteryLevel" to status?.batteryLevel,
                "removalWaiting" to status?.removalWaiting,
                "unrecoverError" to status?.unrecoverError
            )

            checkCallbackCode(code, printerStatus)

            callback(printerStatus)
        } catch (e: Exception) {
            throw e
        }
    }
}