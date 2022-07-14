import 'package:okta_flutter/src/authorization_status.dart';

class OktaResult {
  OktaResult({this.status, this.message});

  final AuthorizationStatus? status;
  final String? message;

  factory OktaResult.fromMap(Map<String, dynamic> result) {
    return OktaResult(
      status: getAuthorizationStatus(result['authorizationStatus']),
      message: result['message'],
    );
  }

  @override
  String toString() {
    return 'OktaResult(status: $status, message: $message)';
  }
}
