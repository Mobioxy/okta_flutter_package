import 'package:okta_flutter/okta_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'okta_flutter_method_channel.dart';

abstract class OktaFlutterPlatform extends PlatformInterface {
  /// Constructs a OktaFlutterPlatform.
  OktaFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static OktaFlutterPlatform _instance = MethodChannelOktaFlutter();

  /// The default instance of [OktaFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelOktaFlutter].
  static OktaFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OktaFlutterPlatform] when
  /// they register themselves.
  static set instance(OktaFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> createOIDCConfig(OktaConfig config);

  Future<OktaResult> signIn();

  Future<OktaResult> signOut();

  Future<OktaResult> refreshToken();

  Future<UserProfile?> getUserProfile();
}
