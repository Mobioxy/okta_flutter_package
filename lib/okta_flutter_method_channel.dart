import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:okta_flutter/src/okta_config.dart';
import 'package:okta_flutter/src/okta_result.dart';
import 'package:okta_flutter/src/user_profile.dart';

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
  Future<OktaResult> signIn() {
    return methodChannel.invokeMethod('signIn').then((result) {
      return OktaResult.fromMap(Map<String, dynamic>.from(result));
    });
  }

  @override
  Future<OktaResult> signOut() {
    return methodChannel.invokeMethod('signOut').then((result) {
      return OktaResult.fromMap(Map<String, dynamic>.from(result));
    });
  }

  @override
  Future<OktaResult> refreshToken() {
    return methodChannel.invokeMethod('refreshToken').then((result) {
      return OktaResult.fromMap(Map<String, dynamic>.from(result));
    });
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    var result = await methodChannel.invokeMethod('getUserProfile');
    if (result != null) {
      if (result['isSuccess']) {
        var decodedUserProfile = jsonDecode(result['userProfile']);
        return UserProfile.fromMap(decodedUserProfile);
      } else {
        throw PlatformException(code: 'ERROR', message: result['message']);
      }
    } else {
      throw Exception('getUserProfile() failed');
    }
  }
}
