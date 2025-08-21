package dev.nikkothe.epson_pos_printer

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

internal class EpsonPosPrinterPluginTest {

  @Test
  fun onMethodCall_getPlatformVersion_returnsExpectedValue() {
    val plugin = EpsonPosPrinterPlugin()

    val call = MethodCall("getPlatformVersion", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE)
  }

  @Test
  fun onMethodCall_initializePrinter_returnsSuccess() {
    val plugin = EpsonPosPrinterPlugin()

    val call = MethodCall("initializePrinter", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(null)
  }

  @Test
  fun onMethodCall_printText_returnsSuccess() {
    val plugin = EpsonPosPrinterPlugin()

    val arguments = mapOf("text" to "Hello, World!")
    val call = MethodCall("printText", arguments)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).success(null)
  }

  @Test
  fun onMethodCall_unknownMethod_returnsNotImplemented() {
    val plugin = EpsonPosPrinterPlugin()

    val call = MethodCall("unknownMethod", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).notImplemented()
  }
}
