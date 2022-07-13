enum AuthorizationStatus {
  authorized,
  signedOut,
  canceled,
  error,
  emailVerificationAuthenticated,
  emailVerificationUnauthenticated
}

AuthorizationStatus? getAuthorizationStatus(String status) {
  var authorizationStatus = <String, AuthorizationStatus>{
    'AUTHORIZED': AuthorizationStatus.authorized,
    'SIGNED_OUT': AuthorizationStatus.signedOut,
    'CANCELED': AuthorizationStatus.canceled,
    'ERROR': AuthorizationStatus.error,
    'EMAIL_VERIFICATION_AUTHENTICATED':
        AuthorizationStatus.emailVerificationAuthenticated,
    'EMAIL_VERIFICATION_UNAUTHENTICATED':
        AuthorizationStatus.emailVerificationUnauthenticated,
  };
  return authorizationStatus[status];
}
