class UserProfile {
  UserProfile({
    this.sub,
    this.name,
    this.locale,
    this.email,
    this.preferredUsername,
    this.givenName,
    this.familyName,
    this.zoneInfo,
    this.updatedAt,
    this.emailVerified,
  });

  String? sub;
  String? name;
  String? locale;
  String? email;
  String? preferredUsername;
  String? givenName;
  String? familyName;
  String? zoneInfo;
  int? updatedAt;
  bool? emailVerified;

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      sub: data['sub'],
      name: data['name'],
      locale: data['locale'],
      email: data['email'],
      preferredUsername: data['preferred_username'],
      givenName: data['given_name'],
      familyName: data['family_name'],
      zoneInfo: data['zoneinfo'],
      updatedAt: data['updated_at'],
      emailVerified: data['email_verified'],
    );
  }

  bool get hasData => sub != null;

  factory UserProfile.empty() {
    return UserProfile(
      sub: null,
      name: null,
      locale: null,
      email: null,
      preferredUsername: null,
      givenName: null,
      familyName: null,
      zoneInfo: null,
      updatedAt: null,
      emailVerified: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sub': sub,
      'name': name,
      'locale': locale,
      'email': email,
      'preferred_username': preferredUsername,
      'given_name': givenName,
      'family_name': familyName,
      'zoneinfo': zoneInfo,
      'updated_at': updatedAt,
      'email_verified': emailVerified,
    };
  }
}
