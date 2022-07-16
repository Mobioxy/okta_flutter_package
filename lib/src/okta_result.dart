import 'package:okta_flutter/okta_flutter.dart';

class OktaResult {
  OktaResult({this.status, this.message, this.tokens});

  final AuthorizationStatus? status;
  final String? message;
  final Tokens? tokens;

  factory OktaResult.fromMap(Map<String, dynamic> result) {
    return OktaResult(
      status: getAuthorizationStatus(result['authorizationStatus']),
      message: result['message'],
      tokens: result['tokens'] != null
          ? Tokens.fromMap(Map.from(result['tokens']))
          : null,
    );
  }

  @override
  String toString() {
    return 'OktaResult(status: $status, message: $message, tokens: $tokens)';
  }
}
