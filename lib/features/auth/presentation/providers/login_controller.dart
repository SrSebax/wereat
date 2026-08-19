import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';
import 'package:wereat/features/auth/domain/usecases/sign_in_with_email_password.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, AppUser?>(LoginController.new);

class LoginController extends AsyncNotifier<AppUser?> {
  @override
  AppUser? build() => null;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(signInWithEmailPasswordProvider);
    final result = await useCase(
      SignInWithEmailPasswordParams(email: email, password: password),
    );
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final useCase = ref.read(signInWithGoogleProvider);
    try {
      final result = await useCase(const NoParams());
      state = result.fold(
        (failure) => AsyncError(failure.message, StackTrace.current),
        (user) => AsyncData(user),
      );
    } catch (e, st) {
      state = AsyncError('Algo salió mal. Intentá de nuevo.', st);
    }
  }
}
