import OktaOidc
import Darwin

public class OktaService : NSObject {
    
    var oktaOidc: OktaOidc?
    var stateManager: OktaOidcStateManager?
    
    
    func createOIDCConfig(configuration : OktaOidcConfig?) -> DarwinBoolean {
        
        do {
            oktaOidc = try OktaOidc(configuration: configuration)
            
            if  let oktaOidc = oktaOidc,
                let _ = OktaOidcStateManager.readFromSecureStorage(for: oktaOidc.configuration)?.accessToken {
                self.stateManager = OktaOidcStateManager.readFromSecureStorage(for: oktaOidc.configuration)
            }
            print("OktaService initialized")
            return true
        } catch let error {
            print("OktaService initialization failed \(error.localizedDescription)")
            return false
        }
    }
    
    func signIn(from: UIViewController, oktaResult : @escaping ([String : Any]) -> Void) {
        if #available(iOS 13.0, *) {
            oktaOidc?.configuration.noSSO = true
        }
        
        oktaOidc?.signInWithBrowser(from: from, callback: { [weak self] stateManager, error in
            var response = [String : Any]()
            if let error = error {
                print("SignIn onError: \(error.localizedDescription)")
                response["authorizationStatus"] = "ERROR"
                response["message"] = error.localizedDescription
                return oktaResult(response)
            }
            print("SignIn onSuccess: Authentication Success")
            self?.stateManager = nil
            self?.stateManager = stateManager
            self?.stateManager?.writeToSecureStorage()
            
            var oktaTokens = [String : Any]()
            oktaTokens["idToken"] = stateManager?.idToken
            oktaTokens["accessToken"] = stateManager?.accessToken
            oktaTokens["refreshToken"] = stateManager?.refreshToken
            
            response["authorizationStatus"] = self?.getAuthorizationStatus(authState: stateManager?.authState)
            response["message"] = "Sign In Successes"
            response["tokens"] = oktaTokens
            return oktaResult(response)
            
        })
    }
    
    func signOut(from: UIViewController, oktaResult : @escaping ([String : Any]) -> Void){
        var response = [String : Any]()
        
        oktaOidc?.signOut(authStateManager: stateManager!, from: from, progressHandler: { options in
            //
        }, completionHandler: { success, failedOptions in
            
            response["authorizationStatus"] = self.getSignOutStatus(option: failedOptions)
            
            if (success){
                response["message"] = "Sign Out Successes"
            } else {
                response["message"] = "Sign Out Failed"
            }
            return oktaResult(response)
        })
    }
    
    func refreshToken(oktaResult : @escaping ([String : Any]) -> Void) {
        var response = [String : Any]()
        
        stateManager?.renew(callback: { stateManager, error in
            if let error = error {
                print("RefreshToken onError: \(error.localizedDescription)")
                response["authorizationStatus"] = "ERROR"
                response["message"] = error.localizedDescription
                return oktaResult(response)
            }
            
            print("RefreshToken onSuccess: Token Refreshed")
            
            var oktaTokens = [String : Any]()
            oktaTokens["idToken"] = stateManager?.idToken
            oktaTokens["accessToken"] = stateManager?.accessToken
            oktaTokens["refreshToken"] = stateManager?.refreshToken
            
            response["authorizationStatus"] = "SUCCESS"
            response["message"] = "Token Refreshed"
            response["tokens"] = oktaTokens
            return oktaResult(response)
        })
    }
    
    func getAuthorizationStatus(authState: OKTAuthState?) -> String {
        if (authState!.isAuthorized){
            return "AUTHORIZED"
        } else{
            return "ERROR"
        }
    }
    
    func getSignOutStatus(option: OktaSignOutOptions) -> String {
        if option.contains(.revokeAccessToken) {
            return "REVOKE_ACCESS_TOKEN"
        } else if option.contains(.revokeRefreshToken) {
            return "REVOKE_REFRESH_TOKEN"
        } else if option.contains(.signOutFromOkta) {
            return "SIGN_OUT_FROM_OKTA"
        } else if option.contains(.removeTokensFromStorage){
            return "REMOVE_TOKENS_FROM_STORAGE"
        } else {
            return  "ERROR"
        }
    }
    
}
