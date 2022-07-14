class OktaConfig {
  OktaConfig({
    required this.clientId,
    required this.redirectUri,
    required this.endSessionRedirectUri,
    required this.discoveryUri,
    required this.scopes,
  });

  final String clientId;
  final String redirectUri;
  final String endSessionRedirectUri;
  final String discoveryUri;
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
