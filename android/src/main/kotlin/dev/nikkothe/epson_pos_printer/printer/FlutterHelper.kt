package dev.nikkothe.epson_pos_printer.printer

import com.epson.epos2.printer.Printer
import com.epson.eposdevice.EposCallbackCode.SUCCESS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

typealias FlutterCallHandler = (arguments: Any?) -> Any?

typealias FlutterAsyncCallback = (result: Any?) -> Unit

typealias FlutterAsyncCallHandler = (arguments: Any?, callback: FlutterAsyncCallback) -> Unit

typealias PrinterStatus = Map<String, Any?>

fun checkReturnCode(returnCode: Int, methodOverride: String? = null) {
    if (returnCode != SUCCESS) {
        throw Exception("Error code: $returnCode, method: $methodOverride")
    }
}

fun checkCallbackCode(
        callbackCode: Int,
        printerStatus: PrinterStatus,
        methodOverride: String? = null
) {
    if (callbackCode != SUCCESS) {
        throw Exception(
                "Callback error code: $callbackCode, status: $printerStatus, method: $methodOverride"
        )
    }
}

fun runHandler(
        handler: FlutterCallHandler,
        call: MethodCall,
        result: MethodChannel.Result,
        apiHost: String = "Epos2Printer"
) {
    try {
        val res = handler(call.arguments)
        if (res == null || res is Unit) {
            result.success(null)
        } else {
            result.success(res)
        }
    } catch (e: Exception) {
        result.error("$apiHost.${call.method}", e.message, null)
    }
}

fun runAsyncHandler(
        handler: FlutterAsyncCallHandler,
        call: MethodCall,
        result: MethodChannel.Result,
        apiHost: String = "Epos2Printer"
) {
    try {
        handler(call.arguments) { res ->
            if (res is Exception) {
                result.error("$apiHost.${call.method}", res.message, null)
            } else {
                result.success(res)
            }
        }
    } catch (e: Exception) {
        result.error("$apiHost.${call.method}", e.message, null)
    }
}

fun instIdOnly(arguments: Any?): Printer {
    val marshalMap = arguments as? Map<String, Any> ?: throw Exception("Bad marshal")
    val id = marshalMap["id"] as? Int ?: throw Exception("Bad marshal")

    return InstanceManager.printer(id)
}

fun instArgsDict(arguments: Any?): Pair<Printer, Map<String, Any?>> {
    val marshalMap = arguments as? Map<String, Any> ?: throw Exception("Bad marshal")
    val id = marshalMap["id"] as? Int ?: throw Exception("Bad marshal")
    val args = marshalMap["args"] as? Map<String, Any?> ?: throw Exception("Bad marshal")
    return Pair(InstanceManager.printer(id), args)
}
