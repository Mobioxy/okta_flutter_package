import OktaOidc

public class OktaService : NSObject {
    
    private var oktaAppAuth: OktaOidc?
   
    
    func createOIDCConfig(configuration : OktaOidcConfig?) {
       
        oktaAppAuth = try? OktaOidc(configuration: configuration)
        if #available(iOS 13.0, *) {
            configuration?.noSSO = true
        }
        guard oktaAppAuth != nil else {
            print("OktaService initialization failed")
            return
        }
    }
    
    func signIn(from: UIViewController, oktaResult : @escaping ([String : Any]) -> Void) {
        oktaAppAuth?.signInWithBrowser(from: from) { authStateManager, error in
            if let error = error {
                print("onError: \(error.localizedDescription)")
                return
            }
            
        }
    }
}
