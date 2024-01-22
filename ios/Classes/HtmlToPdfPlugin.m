#import HtmlToPdfPlugin.h
#if __has_include(<html_to_pdf/html_to_pdf-Swift.h>)
#import <html_to_pdf/html_to_pdf-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "html_to_pdf-Swift.h"
#endif

@implementation HtmlToPdfPlugin
UIViewController *_viewController;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHtmlToPdfPlugin registerWithRegistrar:registrar];
}@end
