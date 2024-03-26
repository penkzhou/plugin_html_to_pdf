import Flutter
import UIKit
import WebKit

public class SwiftHtmlToPdfPlugin: NSObject, FlutterPlugin{
    var wkWebView : WKWebView!
    var urlObservation: NSKeyValueObservation?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "html_to_pdf", binaryMessenger: registrar.messenger())
    let instance = SwiftHtmlToPdfPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "convertHtmlToPdf":
        let args = call.arguments as? [String: Any]
        let htmlFilePath = args!["htmlFilePath"] as? String
        let width = Double(args!["width"] as! Int)
        let height = Double(args!["height"] as! Int)
        let orientation = args!["orientation"]
        
        let viewControler = UIApplication.shared.delegate?.window?!.rootViewController
        wkWebView = WKWebView.init(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width:width, height: height)))
        wkWebView.isHidden = true
        wkWebView.tag = 100
        viewControler?.view.addSubview(wkWebView)

        // the `position: fixed` element not working as expected
        let contentController = wkWebView.configuration.userContentController
        contentController.addUserScript(WKUserScript(source: "document.documentElement.style.webkitUserSelect='none';", injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        contentController.addUserScript(WKUserScript(source: "document.documentElement.style.webkitTouchCallout='none';", injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        wkWebView.scrollView.bounces = false
        
        let htmlFileContent = FileHelper.getContent(from: htmlFilePath!) // get html content from file
        wkWebView.loadHTMLString(htmlFileContent, baseURL: Bundle.main.bundleURL) // load html into hidden webview
        
        urlObservation = wkWebView.observe(\.isLoading, changeHandler: { (webView, change) in
            // this is workaround for issue with loading local images
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let convertedFileURL = PDFCreator.create(printFormatter: self.wkWebView.viewPrintFormatter(), width: width, height: height)
                let convertedFilePath = convertedFileURL.absoluteString.replacingOccurrences(of: "file://", with: "") // return generated pdf path
                if let viewWithTag = viewControler?.view.viewWithTag(100) {
                    viewWithTag.removeFromSuperview() // remove hidden webview when pdf is generated
                    
                    // clear WKWebView cache
                    if #available(iOS 9.0, *) {
                        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                            records.forEach { record in
                                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                            }
                        }
                    }
                }
                
                // dispose WKWebView
                self.urlObservation = nil
                self.wkWebView = nil
                result(convertedFilePath)
            }
        })
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
