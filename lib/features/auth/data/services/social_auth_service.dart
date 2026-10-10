import 'dart:io';

import 'package:arashmati_app/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/error/exceptions.dart';

class AppleSignInPayload {
  final String identityToken;
  final String? email;
  final String? givenName;
  final String? familyName;

  const AppleSignInPayload({
    required this.identityToken,
    this.email,
    this.givenName,
    this.familyName,
  });
}

class SocialAuthService {
  SocialAuthService._();
  static final SocialAuthService instance = SocialAuthService._();

  GoogleSignIn? _googleSignIn;

  GoogleSignIn get googleSignIn {
    if (_googleSignIn != null) return _googleSignIn!;
    // Web client (type 3) from the Firebase project. Required so Google
    // returns an ID token the backend can verify.
    const webClientId =
        '347085841227-r7glvuj2mjshioto6udte7ktp5qlb595.apps.googleusercontent.com';
    final iosClientId = DefaultFirebaseOptions.ios.iosClientId;

    _googleSignIn = GoogleSignIn(
      scopes: const ['email', 'profile', 'openid'],
      clientId: Platform.isIOS ? iosClientId : null,
      serverClientId: webClientId,
    );
    return _googleSignIn!;
  }

  Future<String> getGoogleIdToken() async {
    try {
      await googleSignIn.signOut();
      final account = await googleSignIn.signIn();
      if (account == null) {
        throw SocialAuthCancelledException();
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw ApiException(
          'Google Sign-In did not return an ID token. Try again.',
        );
      }
      return idToken;
    } on SocialAuthCancelledException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      final message = e.toString();
      if (message.contains('canceled') ||
          message.contains('cancelled') ||
          message.contains('sign_in_canceled')) {
        throw SocialAuthCancelledException();
      }
      throw ApiException('Google Sign-In failed. Please try again.');
    }
  }

  Future<AppleSignInPayload> getAppleCredential() async {
    final available = await SignInWithApple.isAvailable();
    if (!available) {
      throw ApiException('Apple Sign-In is not available on this device.');
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      if (identityToken == null || identityToken.isEmpty) {
        throw ApiException('Apple Sign-In did not return an identity token.');
      }

      return AppleSignInPayload(
        identityToken: identityToken,
        email: credential.email,
        givenName: credential.givenName,
        familyName: credential.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw SocialAuthCancelledException();
      }
      throw ApiException('Apple Sign-In failed. Please try again.');
    } on SocialAuthCancelledException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Apple Sign-In failed. Please try again.');
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
    } catch (_) {}
  }
}