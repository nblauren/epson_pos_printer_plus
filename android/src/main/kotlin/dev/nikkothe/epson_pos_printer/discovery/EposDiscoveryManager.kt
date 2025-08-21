package dev.nikkothe.epson_pos_printer.discovery

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import com.epson.epos2.discovery.Discovery
import com.epson.epos2.discovery.DiscoveryListener
import com.epson.epos2.discovery.FilterOption
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * Manages the discovery of Epson POS printers.
 *
 * @property context The application context.
 */
class EposDiscoveryManager(private val context: Context) :
        EventChannel.StreamHandler, ActivityAware {

    companion object {
        @JvmStatic
        fun registerWith(binding: FlutterPlugin.FlutterPluginBinding) {
            // Create an EventChannel for printer discovery
            val streamChannel = EventChannel(binding.binaryMessenger, "epson_pos_printer/discovery")
            // Create an instance of EposDiscoveryManager
            val instance = EposDiscoveryManager(binding.applicationContext)
            // Set the StreamHandler for the EventChannel
            streamChannel.setStreamHandler(instance)
        }
    }
    private var activity: Activity? = null
    private var eventSink: EventChannel.EventSink? = null

    /**
     * Called when the Flutter side starts listening for discovery events.
     *
     * @param arguments The arguments passed from Flutter.
     * @param events The EventSink to send discovery events to Flutter.
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events

        // Parse the arguments from Flutter
        val args = arguments as? Map<String, Any>
        val portType = args?.get("portType") as? Int
        val broadcast = args?.get("broadcast") as? String
        val deviceModel = args?.get("deviceModel") as? Int
        val deviceType = args?.get("deviceType") as? Int

        // Validate the arguments
        if (portType == null || broadcast == null || deviceModel == null || deviceType == null) {
            events?.error("lib-BadMarshal", "Bad Marshal from EposDiscoveryPlugin.onListen", null)
            return
        }

        // Create a FilterOption for discovery
        val filterOption =
                FilterOption().apply {
                    this.portType = portType
                    this.broadcast = broadcast
                    this.deviceModel = deviceModel
                    this.deviceType = deviceType
                    this.bondedDevices = Discovery.TRUE
                }

        // Start the discovery process
        Handler(Looper.getMainLooper()).post {
            try {
                Discovery.start(context, filterOption, mDiscoveryListener)
            } catch (e: Exception) {
                events?.error("DiscoveryError", e.message, null)
            }
        }
    }

    /**
     * Called when the Flutter side cancels listening for discovery events.
     *
     * @param arguments The arguments passed from Flutter.
     */
    override fun onCancel(arguments: Any?) {
        eventSink = null
        try {
            Discovery.stop()
        } catch (e: Exception) {
            // Ignore exceptions during stop
        }
    }

    /**
     * Called when the plugin is attached to an activity.
     *
     * @param binding The ActivityPluginBinding.
     */
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    /** Called when the activity is detached for configuration changes. */
    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    /**
     * Called when the activity is reattached after configuration changes.
     *
     * @param binding The ActivityPluginBinding.
     */
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    /** Called when the plugin is detached from the activity. */
    override fun onDetachedFromActivity() {
        activity = null
    }

    /** Listener for discovery events. */
    private val mDiscoveryListener = DiscoveryListener { deviceInfo ->
        Handler(Looper.getMainLooper()).post {
            if (deviceInfo?.deviceName != null && deviceInfo.deviceName.isNotEmpty()) {
                // Map the discovered device information to a Flutter-compatible format
                val deviceMap =
                        mapOf(
                                "deviceType" to deviceInfo.deviceType,
                                "deviceName" to deviceInfo.deviceName,
                                "ipAddress" to deviceInfo.ipAddress,
                                "macAddress" to deviceInfo.macAddress,
                                "bdAddress" to deviceInfo.bdAddress,
                                "target" to deviceInfo.target
                        )
                // Send the device information to Flutter
                eventSink?.success(deviceMap)
            }
        }
    }
}
