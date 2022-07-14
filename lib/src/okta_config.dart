class OktaConfig {
  OktaConfig({
    required this.clientId,
    required this.redirectUri,
    required this.endSessionRedirectUri,
    required this.discoveryUri,
    required this.scopes,
  });

  /// Client id of your `Okta` application.
  ///
  final String clientId;

  /// Sets redirect uri to go to once the authorization `log in` flow is complete.
  /// 
  final String redirectUri;

  /// Sets redirect uri to go to once the authorization `log out` flow is complete.
  /// 
  final String endSessionRedirectUri;

  /// The discovery uri for the authorization server. This is your applications `domain url`
  /// 
  final String discoveryUri;

  /// Sets the scopes of the for authorization.
  /// See Alos : [https://developer.okta.com/docs/reference/api/oidc/#scopes]
  /// 
  final List<String> scopes;

  Map<String, dynamic> toAndroidConfig() {
    return {
      'clientId': clientId,
      'redirectUri': redirectUri,
      'endSessionRedirectUri': endSessionRedirectUri,
      'discoveryUri': discoveryUri,
      'scopes': scopes,
    };
  }

  Map<String, dynamic> toIOSConfig() {
    return {
      'clientId': clientId,
      'redirectUri': redirectUri,
      'endSessionRedirectUri': endSessionRedirectUri,
      'discoveryUri': discoveryUri,
      'scopes': scopes.join(' '),
    };
  }
}
