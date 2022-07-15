import 'package:okta_flutter/okta_flutter_platform_interface.dart';
import 'package:okta_flutter/src/okta_config.dart';
import 'package:okta_flutter/src/okta_result.dart';

export 'package:okta_flutter/src/authorization_status.dart';
export 'package:okta_flutter/src/okta_config.dart';
export 'package:okta_flutter/src/okta_result.dart';
export 'package:okta_flutter/src/tokens.dart';

class OktaFlutter {
  OktaFlutter._();

  static final OktaFlutter _instance = OktaFlutter._();

  final OktaFlutterPlatform _platform = OktaFlutterPlatform.instance;

  static OktaFlutter get instance => _instance;

  /// Okta config information.
  /// This is used to setup a configuration for AuthClient and SessionClient clients.
  /// 
  Future<bool> createOIDCConfig(OktaConfig config) async {
    var result = await _platform.createOIDCConfig(config);
    return result ?? false;
  }

  /// Sign in using implicit flow.
  /// The result will be returned in the `OktaResult`
  ///
  Future<OktaResult> signIn() => _platform.signIn();

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
  Future<OktaResult> signOut() => _platform.signOut();
}
