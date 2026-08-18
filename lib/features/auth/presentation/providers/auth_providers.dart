import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:wereat/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wereat/features/auth/domain/repositories/auth_repository.dart';
import 'package:wereat/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:wereat/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:wereat/features/auth/domain/usecases/sign_out.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(firebaseAuth: ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final signInWithEmailPasswordProvider = Provider<SignInWithEmailPassword>((ref) {
  return SignInWithEmailPassword(ref.watch(authRepositoryProvider));
});

final signInWithGoogleProvider = Provider<SignInWithGoogle>((ref) {
  return SignInWithGoogle(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});

/// Emite el usuario autenticado actual (o null) en tiempo real.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});
