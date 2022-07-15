class Tokens {
  Tokens({
    this.idToken,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  final String? idToken;
  final String? accessToken;
  final String? refreshToken;
  final Duration? expiresIn;

  factory Tokens.fromMap(Map<String, dynamic> map) {
    return Tokens(
      idToken: map['idToken'],
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
      expiresIn: map['expiresIn'] != null
          ? Duration(seconds: map['expiresIn'])
          : Duration.zero,
    );
  }

  @override
  String toString() {
    return 'Tokens(idToken: $idToken, accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn)';
  }
}
