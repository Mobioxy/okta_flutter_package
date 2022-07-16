import Flutter
import UIKit
import OktaOidc

public class SwiftOktaFlutterPlugin: NSObject, FlutterPlugin {
    
    private var oktaService = OktaService()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mobility.okta_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftOktaFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let viewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        
        if call.method == "createOIDCConfig" {
            
            if let arguments = call.arguments as? Dictionary<String, Any>{
                let configuration = processOIDCConfigArguments(arguments: arguments)
                let configResult =  oktaService.createOIDCConfig(configuration: configuration)
                result(configResult.boolValue)
            }
            
        } else if call.method == "signIn" {
            
            oktaService.signIn(from: viewController) { oktaResult in
                result(oktaResult)
            }
            
        } else if call.method == "signOut" {
            
            oktaService.signOut(from: viewController) { oktaResult in
                result(oktaResult)
            }
            
        } else if call.method == "refreshToken" {
            
            oktaService.refreshToken { oktaResult in
                result(oktaResult)
            }
            
        } else {
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
