package dev.nikkothe.epson_pos_printer.printer

import android.app.Activity
import android.content.Context
import com.epson.epos2.printer.Printer
import dev.nikkothe.epson_pos_printer.common.LibraryError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * Manages the discovery of Epson POS printers.
 *
 * @property context The application context.
 */
class EposPrinterManager(private val context: Context) :
        FlutterPlugin, ActivityAware, MethodCallHandler {
            
    companion object {
        @JvmStatic
        fun registerWith(binding: FlutterPlugin.FlutterPluginBinding) {
            val instance = EposPrinterManager(binding.applicationContext)
            instance.setupChannel(binding.binaryMessenger)
        }
    }

    private var activity: Activity? = null
    private lateinit var channel: MethodChannel
    private lateinit var binaryManager: BinaryMessenger

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun setupChannel(messenger: BinaryMessenger) {
        binaryManager = messenger
        channel = MethodChannel(messenger, "epson_pos_printer/printer")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                // Handle createPrinter method
                runHandler(::init, call, result)
            }
            "createPrinter" -> {
                // Handle createPrinter method
                runHandler(::createPrinter, call, result)
            }
            "destroyPrinter" -> {
                // Handle destroyPrinter method
                runHandler(::destroyPrinter, call, result)
            }
            "sendData" -> {
                runAsyncHandler(::sendData, call, result)
            }
            "clearCommandBuffer" -> {
                runHandler(::clearCommandBuffer, call, result)
            }
            "connect" -> {
                runHandler(::connect, call, result)
            }
            "disconnect" -> {
                runHandler(::disconnect, call, result)
            }
            "addTextAlign" -> {
                runHandler(::addTextAlign, call, result)
            }
            "addLineSpace" -> {
                runHandler(::addLineSpace, call, result)
            }
            "addTextRotate" -> {
                runHandler(::addTextRotate, call, result)
            }
            "addText" -> {
                runHandler(::addText, call, result)
            }
            "addTextLang" -> {
                runHandler(::addTextLang, call, result)
            }
            "addTextFont" -> {
                runHandler(::addTextFont, call, result)
            }
            "addTextSmooth" -> {
                runHandler(::addTextSmooth, call, result)
            }
            "addTextSize" -> {
                runHandler(::addTextSize, call, result)
            }
            "addTextStyle" -> {
                runHandler(::addTextStyle, call, result)
            }
            "addHPosition" -> {
                runHandler(::addHPosition, call, result)
            }
            "addFeedUnit" -> {
                runHandler(::addFeedUnit, call, result)
            }
            "addFeedLine" -> {
                runHandler(::addFeedLine, call, result)
            }
            "addCut" -> {
                runHandler(::addCut, call, result)
            }
            "addCommand" -> {
                runHandler(::addCommand, call, result)
            }
            else -> result.notImplemented()
        }
    }

    @Throws(LibraryError::class)
    fun createPrinter(arguments: Any?): Int {

        val argMap = arguments as? Map<*, *> ?: throw LibraryError.BadMarshal

        val series = argMap["series"] as? Int ?: throw LibraryError.BadMarshal
        val model = argMap["model"] as? Int ?: throw LibraryError.BadMarshal

        val printer = Printer(series, model, this.context)

        val id = InstanceManager.register(printer)

        val statusDelegate = PrinterStatusDelegate(printer, id, binaryManager)
        printer.setStatusChangeEventListener(statusDelegate)

        return id
    }

    @Throws(LibraryError::class)
    fun init(arguments: Any?) {
        for (printer in InstanceManager.allPrinters()) {
            safeDispose(printer)
        }
        InstanceManager.reset()
    }

    @Throws(LibraryError::class)
    fun destroyPrinter(arguments: Any?) {
        val printerId = arguments as? Int ?: throw LibraryError.BadMarshal

        val printer = InstanceManager.release(printerId) ?: throw LibraryError.InvalidId(printerId)
        safeDispose(printer)
    }

    @Throws(LibraryError::class)
    fun connect(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val target = args["target"] as? String ?: throw LibraryError.BadMarshal
        val timeout = args["timeout"] as? Long ?: 15000

        if (printer.status.online != 1) printer.connect(target, timeout.toInt())
    }

    @Throws(LibraryError::class)
    fun disconnect(arguments: Any?) {
        val printer = instIdOnly(arguments)

        printer.disconnect()
    }

    @Throws(LibraryError::class)
    fun sendData(arguments: Any?, callback: FlutterAsyncCallback) {

        val (printer, args) = instArgsDict(arguments)

        val timeout = args["timeout"] as? Int ?: throw LibraryError.BadMarshal

        PrinterAsyncDelegate(callback, printer)

        printer.sendData(timeout)
    }

    @Throws(LibraryError::class)
    fun clearCommandBuffer(arguments: Any?) {
        val printer = instIdOnly(arguments)

        printer.clearCommandBuffer()
    }

    @Throws(LibraryError::class)
    fun addTextAlign(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)
        val align = args["align"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextAlign(align)
    }

    @Throws(LibraryError::class)
    fun addLineSpace(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)
        val space = args["space"] as? Int ?: throw LibraryError.BadMarshal

        printer.addLineSpace(space)
    }

    @Throws(LibraryError::class)
    fun addTextRotate(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val rotate = args["rotate"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextRotate(rotate)
    }

    @Throws(LibraryError::class)
    fun addText(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val data = args["data"] as? String ?: throw LibraryError.BadMarshal

        printer.addText(data)
    }

    @Throws(LibraryError::class)
    fun addTextLang(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val lang = args["lang"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextLang(lang)
    }

    @Throws(LibraryError::class)
    fun addTextFont(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val font = args["font"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextFont(font)
    }

    @Throws(LibraryError::class)
    fun addTextSmooth(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)
        val smooth = args["smooth"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextSmooth(smooth)
    }

    @Throws(LibraryError::class)
    fun addTextSize(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val width = args["width"] as? Int ?: throw LibraryError.BadMarshal
        val height = args["height"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextSize(width, height)
    }

    @Throws(LibraryError::class)
    fun addTextStyle(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val em = args["em"] as? Int ?: throw LibraryError.BadMarshal
        val ul = args["ul"] as? Int ?: throw LibraryError.BadMarshal
        val reverse = args["reverse"] as? Int ?: throw LibraryError.BadMarshal
        val color = args["color"] as? Int ?: throw LibraryError.BadMarshal

        printer.addTextStyle(reverse, ul, em, color)
    }

    @Throws(LibraryError::class)
    fun addHPosition(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val position = args["position"] as? Int ?: throw LibraryError.BadMarshal

        printer.addHPosition(position)
    }

    @Throws(LibraryError::class)
    fun addFeedUnit(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val unit = args["unit"] as? Int ?: throw LibraryError.BadMarshal

        printer.addFeedUnit(unit)
    }

    @Throws(LibraryError::class)
    fun addFeedLine(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val line = args["line"] as? Int ?: throw LibraryError.BadMarshal

        printer.addFeedLine(line)
    }

    @Throws(LibraryError::class)
    fun addCut(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val cutType = args["cutType"] as? Int ?: throw LibraryError.BadMarshal

        printer.addCut(cutType)
    }

    @Throws(LibraryError::class)
    fun addCommand(arguments: Any?) {
        val (printer, args) = instArgsDict(arguments)

        val data = args["data"] as? ByteArray ?: throw LibraryError.BadMarshal

        printer.addCommand(data)
    }
}
