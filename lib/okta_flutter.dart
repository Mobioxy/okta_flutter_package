import 'package:okta_flutter/okta_flutter_platform_interface.dart';
import 'package:okta_flutter/src/okta_config.dart';
import 'package:okta_flutter/src/okta_result.dart';

export 'package:okta_flutter/src/authorization_status.dart';
export 'package:okta_flutter/src/okta_config.dart';
export 'package:okta_flutter/src/okta_result.dart';

class OktaFlutter {
  OktaFlutter._();

  static final OktaFlutter _instance = OktaFlutter._();

  final OktaFlutterPlatform _platform = OktaFlutterPlatform.instance;

  static OktaFlutter get instance => _instance;

  Future<bool> createOIDCConfig(OktaConfig config) async {
    var result = await _platform.createOIDCConfig(config);
    return result ?? false;
  }

  Future<OktaResult> open() => _platform.open();
}
