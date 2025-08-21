#import "EpsonPosPrinterPlugin.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <libxml2/libxml/parser.h>
#import <ExternalAccessory/ExternalAccessory.h>
#if __has_include(<epson_pos_printer/epson_pos_printer-Swift.h>)
#import <epson_pos_printer/epson_pos_printer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "epson_pos_printer-Swift.h"
#endif

@implementation EpsonPosPrinterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [EposDiscoveryManager registerWith: registrar];
    [EposPrinterManager registerWithRegistrar: registrar];
}
@end