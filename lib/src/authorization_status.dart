/// The Authorization status returned from a auth requests.
///
enum AuthorizationStatus {
  /// Authorized authorization status. User is authorized. Received access, refresh, and ID tokens/
  ///
  authorized,

  /// Signed out authorization status. Browser session is cleared.
  ///
  signedOut,

  /// Operation was canceled.
  ///
  canceled,

  /// Operation resulted in an exception.
  ///
  error,

  /// Email verified and user is authenticated with a valid browser session but the user is not
  /// authorized so it won't have any valid tokens.
  /// To complete the code exchange, client's should call `signIn()` again.
  /// Since the user already have a valid browser session(AUTHENTICATED), they are not required to enter any credentials.
  ///
  emailVerificationAuthenticated,

  /// Email verified but user is not authenticated.
  /// To complete the code exchange, client's should call `signIn()` again.
  /// Since the user is not authenticated they are required to enter credentials.
  /// It is good practice to set the login hint in the payload so users don't have to enter it again.
  ///
  emailVerificationUnauthenticated,

  /// Status returned when sign out steps have all completed.
  ///
  success,

  /// Bitwise status returned when clearing browser failed.
  ///
  failedRevokeAccessToken,

  /// Bitwise status returned when revoking access token failed.
  ///
  failedRevokeRefreshToken,

  /// Bitwise status returned when revoking refresh token failed.
  ///
  failedClearData,

  /// Bitwise status returned when clearing data failed.
  ///
  failedClearSession,


  /// iOS only
  revokeAccessToken,
  revokeRefreshToken,
  signOutFromOkta,
  removeTokensFromStorage,
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
    'SUCCESS': AuthorizationStatus.success,
    'FAILED_REVOKE_ACCESS_TOKEN': AuthorizationStatus.failedRevokeAccessToken,
    'FAILED_REVOKE_REFRESH_TOKEN': AuthorizationStatus.failedRevokeRefreshToken,
    'FAILED_CLEAR_DATA': AuthorizationStatus.failedClearData,
    'FAILED_CLEAR_SESSION': AuthorizationStatus.failedClearSession,
    'REVOKE_ACCESS_TOKEN': AuthorizationStatus.revokeAccessToken,
    'REVOKE_REFRESH_TOKEN': AuthorizationStatus.revokeRefreshToken,
    'SIGN_OUT_FROM_OKTA': AuthorizationStatus.signOutFromOkta,
    'REMOVE_TOKENS_FROM_STORAGE': AuthorizationStatus.removeTokensFromStorage,
  };
  return authorizationStatus[status];
}
