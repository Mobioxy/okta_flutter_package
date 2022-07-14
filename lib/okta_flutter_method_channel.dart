import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:okta_flutter/src/okta_config.dart';
import 'package:okta_flutter/src/okta_result.dart';

import 'okta_flutter_platform_interface.dart';

/// An implementation of [OktaFlutterPlatform] that uses method channels.
class MethodChannelOktaFlutter extends OktaFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mobility.okta_flutter');

  @override
  Future<bool?> createOIDCConfig(OktaConfig config) {
    var arguments =
        Platform.isIOS ? config.toIOSConfig() : config.toAndroidConfig();
    return methodChannel.invokeMethod<bool?>('createOIDCConfig', arguments);
  }

  @override
  Future<OktaResult> open() {
    return methodChannel.invokeMethod('open').then((result) {
      return OktaResult.fromMap(Map<String, dynamic>.from(result));
    });
  }
}
