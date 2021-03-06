import 'package:okta_flutter/okta_flutter_platform_interface.dart';
import 'package:okta_flutter/src/okta_config.dart';
import 'package:okta_flutter/src/okta_result.dart';
import 'package:okta_flutter/src/user_profile.dart';

export 'package:okta_flutter/src/authorization_status.dart';
export 'package:okta_flutter/src/okta_config.dart';
export 'package:okta_flutter/src/okta_result.dart';
export 'package:okta_flutter/src/tokens.dart';
export 'package:okta_flutter/src/user_profile.dart';

class OktaFlutter {
  OktaFlutter._();

  bool _isInitialized = false;

  static final OktaFlutter _instance = OktaFlutter._();

  final OktaFlutterPlatform _platform = OktaFlutterPlatform.instance;

  static OktaFlutter get instance => _instance;

  /// Okta config information.
  /// This is used to setup a configuration for AuthClient and SessionClient clients.
  ///
  Future<bool> createOIDCConfig(OktaConfig config) async {
    var result = await _platform.createOIDCConfig(config);
    if (result ?? false) {
      _isInitialized = true;
    }
    return result ?? false;
  }

  /// Sign in using implicit flow.
  /// The result will be returned in the `OktaResult`
  ///
  Future<OktaResult> signIn() {
    if (_isInitialized) {
      return _platform.signIn();
    } else {
      throw Exception('Okta is not initialized');
    }
  }

  /// Convenience method to completely sign out of application.
  /// Performs the following operations in order: 1. Revokes the `access_token`.
  /// If this fails step 3 will not be attempted. 2. Revokes the `refresh_token`.
  /// If this fails step 3 will not be attempted. 3. Removes all persistence data.
  /// Only if steps 1 & 2 succeeds. 4. Clears browser session only if this is a WebAuthClient instance.
  /// Will always be attempted regardless of the other operations.
  ///
  /// See Also:
  /// `SUCCESS`, `FAILED_REVOKE_ACCESS_TOKEN`, `FAILED_REVOKE_REFRESH_TOKEN`, `FAILED_CLEAR_DATA`, `FAILED_CLEAR_SESSION`
  ///
  Future<OktaResult> signOut() {
    if (_isInitialized) {
      return _platform.signOut();
    } else {
      throw Exception('Okta is not initialized');
    }
  }

  /// Refresh token returns access, refresh, and ID tokens Tokens.
  ///
  Future<OktaResult> refreshToken() {
    if (_isInitialized) {
      return _platform.refreshToken();
    } else {
      throw Exception('Okta is not initialized');
    }
  }

  /// Get user profile returns any claims for the currently logged-in user.
  /// This must be done after the user is logged-in (client has a valid access token).
  ///
  Future<UserProfile?> getUserProfile() {
    if (_isInitialized) {
      return _platform.getUserProfile();
    } else {
      throw Exception('Okta is not initialized');
    }
  }

  /// Checks to see if the user is authenticated.
  /// If the client have a access or ID token then the user is considered authenticated and this call will return true.
  /// This does not check the validity of the access token which could be expired or revoked.
  /// 
  Future<bool> isAuthenticated() {
    if (_isInitialized) {
      return _platform.isAuthenticated();
    } else {
      throw Exception('Okta is not initialized');
    }
  }
}
