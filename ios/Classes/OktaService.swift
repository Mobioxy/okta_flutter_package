import OktaOidc

public class OktaService : NSObject {
    
    private var oktaAppAuth: OktaOidc?
    private var authStateManager: OktaOidcStateManager? {
        didSet {
            authStateManager?.writeToSecureStorage()
        }
    }
    
    func createOIDCConfig(configuration : OktaOidcConfig?) {
        if #available(iOS 13.0, *) {
            configuration?.noSSO = true
        }
        oktaAppAuth = try? OktaOidc(configuration: configuration)
   
        
        if let config = oktaAppAuth?.configuration {
            authStateManager = OktaOidcStateManager.readFromSecureStorage(for: config)
        }
        
        guard oktaAppAuth != nil else {
            print("OktaService initialization failed")
            return
        }
    }
    
    func signIn(from: UIViewController, oktaResult : @escaping ([String : Any]) -> Void) {
        oktaAppAuth?.signInWithBrowser(from: from) { authStateManager, error in
            if let error = error {
                self.authStateManager = nil
                print("onError: \(error.localizedDescription)")
                return
            }
            
            self.authStateManager = authStateManager
            
        }
    }
}
