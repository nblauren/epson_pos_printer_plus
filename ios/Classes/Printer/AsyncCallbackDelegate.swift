import Foundation

class PrinterAsyncDelegate :  NSObject, Epos2PtrReceiveDelegate  {
    unowned private let printer: Epos2Printer
    private let callback: FlutterAsyncCallback

    init(_ callback: @escaping FlutterAsyncCallback, attachTo printer: Epos2Printer) {
        self.printer = printer
        self.callback = callback
        
        super.init()
        
        printer.setReceiveEventDelegate(self)
    }

    func onPtrReceive(_ printerObj: Epos2Printer!, code: Int32, status: Epos2PrinterStatusInfo, printJobId: String!) {
        // Callback should be only called once, it should be cleared after the use
        printer.setReceiveEventDelegate(nil)    
    
        do {
            let printerStatus: PrinterStatus = [
                "printerJobId": printJobId,
                "connection": (status.connection == 1),
                "online": (status.online == 1),
                "coverOpen": (status.coverOpen == 1),
                "paper": status.paper,
                "paperFeed": (status.paperFeed == 0),
                "panelSwitch": (status.panelSwitch == 0),
                "waitOnline": (status.waitOnline),
                "drawer": (status.drawer == 0),
                "errorStatus": status.errorStatus,
                "autoRecoverError": status.autoRecoverError,
                "buzzer": (status.buzzer == 0),
                "adapter": (status.adapter == 0),
                "batteryLevel": status.batteryLevel,
                "removalWaiting": status.removalWaiting,
                "unrecoverError": status.unrecoverError
            ]
                        
            try check(callbackCode: code, printerStatus: printerStatus, methodOverride: "Error with status")
            
            callback(printerStatus)
        } catch {
            print("Error onPtrReceive \(error)")
            callback(flutterError(fromError: error, method: "Epos2Printer.onPtrReceive"))
        }
    }
}
