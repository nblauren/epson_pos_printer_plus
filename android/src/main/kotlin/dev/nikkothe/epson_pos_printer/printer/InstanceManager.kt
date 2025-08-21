package dev.nikkothe.epson_pos_printer.printer

import com.epson.epos2.printer.Printer
import dev.nikkothe.epson_pos_printer.common.LibraryError
import java.util.concurrent.ConcurrentHashMap

class InstanceManager {
    companion object {
        private val printers: MutableMap<Int, Printer> = ConcurrentHashMap()
        private var nextId: Int = 0

        private fun allocId(): Int {
            val id = nextId
            nextId += 1
            return id
        }

        @JvmStatic
        fun register(printer: Printer): Int {
            val id = allocId()
            printers[id] = printer
            return id
        }

        @JvmStatic
        fun release(id: Int): Printer? {
            return printers.remove(id)
        }

        @JvmStatic
        @Throws(LibraryError.InvalidId::class)
        fun printer(id: Int): Printer {
            return printers[id] ?: throw LibraryError.InvalidId(id)
        }

        @JvmStatic
        fun allPrinters(): Collection<Printer> {
            return printers.values
        }

        @JvmStatic
        fun reset() {
            printers.clear()
            nextId = 0
        }
    }
}
