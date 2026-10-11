/// Built-in OAuth client ids for the FrameWorkz Google Cloud project.
///
/// Fill these in once and users never paste anything: "Connect Google" opens
/// the browser, they approve, done. Anything typed into Settings → Google
/// account still overrides these (useful for a second Cloud project).
///
/// Desktop client secrets are not secret in the OAuth sense: Google documents
/// that installed apps cannot keep them confidential, which is why desktop
/// clients use the loopback (localhost) flow with PKCE.
///
/// Where each one comes from (Google Cloud Console → Credentials):
///   desktopClientId / desktopClientSecret  OAuth client, type "Desktop app"
///   webClientId                            OAuth client, type "Web application"
///                                          (Android needs it as serverClientId;
///                                          an "Android" client with the release
///                                          SHA-1 must exist in the same project)
///   iosClientId                            OAuth client, type "iOS" — also put
///                                          it in ios/Runner/Info.plist
///                                          (GIDClientID + reversed URL scheme)
class GoogleDefaults {
  static const desktopClientId = '';
  static const desktopClientSecret = '';
  static const webClientId = '';
  static const iosClientId = '';

  static bool get hasDesktop => desktopClientId.isNotEmpty;
  static bool get hasWeb => webClientId.isNotEmpty;
  static bool get hasIos => iosClientId.isNotEmpty;
}
