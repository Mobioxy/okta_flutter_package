import Flutter
import UIKit
import OktaOidc

public class SwiftOktaFlutterPlugin: NSObject, FlutterPlugin {
    
    private var oktaService: OktaService?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mobility.okta_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftOktaFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        oktaService = OktaService()
        if call.method == "createOIDCConfig" {
            
            if let arguments = call.arguments as? Dictionary<String, Any>{
                let configuration = processOIDCConfigArguments(arguments: arguments)
                oktaService?.createOIDCConfig(configuration: configuration)
            }
            
        } else if call.method == "signIn" {
            
            let viewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
            oktaService?.signIn(from: viewController) { oktaResult in
                result(oktaResult)
            }
            
            
        }  else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    func processOIDCConfigArguments(arguments : Dictionary<String, Any>) ->  OktaOidcConfig? {
        return try? OktaOidcConfig(with: [
            "issuer": (arguments["discoveryUri"] as? String) ?? "",
            "clientId": (arguments["clientId"] as? String) ?? "",
            "redirectUri": (arguments["redirectUri"] as? String) ?? "",
            "logoutRedirectUri": (arguments["endSessionRedirectUri"] as? String) ?? "",
            "scopes": (arguments["scopes"] as? String) ?? ""
        ])
    }
}
