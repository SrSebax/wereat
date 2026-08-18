import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wereat/core/error/exceptions.dart';
import 'package:wereat/features/auth/data/models/app_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AppUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUserModel> signInWithGoogle();

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInit;

  /// clientId/serverClientId no se pasan: se resuelven de
  /// google-services.json (Android) y GoogleService-Info.plist (iOS).
  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInit ??= _googleSignIn.initialize();
  }

  @override
  Future<AppUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw const AuthException('No pudimos iniciar tu sesión. Probá de nuevo.');
      }
      return AppUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  @override
  Future<AppUserModel> signInWithGoogle() async {
    if (kIsWeb) return _signInWithGooglePopup();

    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      throw AuthException(_messageForGoogle(e.code));
    }

    try {
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      final authorization =
          await authorizationClient.authorizationForScopes(['email']) ??
              await authorizationClient.authorizeScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('No pudimos iniciar tu sesión con Google.');
      }
      return AppUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    } on GoogleSignInException catch (e) {
      throw AuthException(_messageForGoogle(e.code));
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (_googleSignInInit != null) {
      await _googleSignIn.signOut();
    }
  }

  /// En web no se usa el plugin google_sign_in (requiere un OAuth client id
  /// aparte vía meta tag): se abre el popup de Google directo con Firebase Auth.
  Future<AppUserModel> _signInWithGooglePopup() async {
    try {
      final userCredential =
          await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('No pudimos iniciar tu sesión con Google.');
      }
      return AppUserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e.code));
    }
  }

  String _messageForGoogle(GoogleSignInExceptionCode code) {
    switch (code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Cancelaste el inicio de sesión con Google.';
      default:
        return 'No pudimos conectar con Google. Intentá de nuevo.';
    }
  }

  String _messageFor(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No encontramos una cuenta con ese email.';
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Email o contraseña incorrectos.';
      case 'invalid-email':
        return 'Ese email no es válido.';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Probá de nuevo en unos minutos.';
      case 'network-request-failed':
        return 'Sin conexión. Revisá tu internet.';
      case 'account-exists-with-different-credential':
        return 'Ese email ya está registrado con otro método de inicio de sesión.';
      case 'operation-not-allowed':
        return 'Este método de inicio de sesión no está habilitado.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Cancelaste el inicio de sesión con Google.';
      default:
        return 'Algo salió mal. Intentá de nuevo.';
    }
  }
}
