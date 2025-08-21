package dev.nikkothe.epson_pos_printer.common

import com.epson.epos2.printer.PrinterStatusInfo
import io.flutter.plugin.common.MethodChannel

sealed class LibraryError : Exception() {
        object BadMarshal : LibraryError()
        data class BadEnum(val name: String, val value: Any) : LibraryError()
        data class InvalidId(val id: Int) : LibraryError()
        data class Epos2ReturnCode(val code: Int, val methodOverride: String? = null) : LibraryError()
        data class Epos2CallbackCode @JvmOverloads constructor(val code: Int, val printerStatus: PrinterStatusInfo, val methodOverride: String? = null) : LibraryError()
}

fun flutterError(error: Throwable, method: String, result: MethodChannel.Result): Any {
        return when (error) {
                is LibraryError -> when (error) {
                        is LibraryError.BadMarshal -> result.error(
                                "lib-BadMarshal",
                                "Bad Marshal from $method",
                                null
                        )
                        is LibraryError.BadEnum -> result.error(
                                "lib-BadEnum",
                                "Unknown Enum ${error.name} = ${error.value} from $method",
                                "${error.name} = ${error.value}"
                        )
                        is LibraryError.InvalidId -> result.error(
                                "lib-InvalidInstanceId",
                                "Invalid instance id ${error.id} from $method",
                                error.id
                        )
                        is LibraryError.Epos2ReturnCode -> flutterError(
                                error.code,
                                ::decodeEpos2ErrorStatus,
                                method = error.methodOverride ?: method,
                                result
                        ) ?: result.success(null)
                        is LibraryError.Epos2CallbackCode -> flutterError(
                                error.code,
                                ::decodeEpos2CallbackCode,
                                method = error.methodOverride ?: method,
                                result,
                                details = error.printerStatus
                        ) ?: result.success(null)
                }
                else -> result.error(
                        "lib-Unknown",
                        "Unknown Error from $method",
                        error.toString()
                )
        }
}

typealias ErrorCodeDecoder = (code: Int) -> String

fun flutterError(
        code: Int,
        decoder: ErrorCodeDecoder,
        method: String,
        result: MethodChannel.Result,
        details: Any? = null
) {
        val errorMessage = decoder(code)
        return result.error(
                "lib-$code",
                "Error $code from $method: $errorMessage",
                details
        )
}

fun decodeEpos2ErrorStatus(code: Int): String {
        // Implement the decoding logic for Epos2 error status
        return "Decoded Epos2 Error Status for code $code"
}

fun decodeEpos2CallbackCode(code: Int): String {
        // Implement the decoding logic for Epos2 callback code
        return "Decoded Epos2 Callback Code for code $code"
}