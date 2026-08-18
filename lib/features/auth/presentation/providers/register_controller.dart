import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/domain/entities/app_user.dart';
import 'package:wereat/features/auth/domain/usecases/register_with_email_password.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, AppUser?>(RegisterController.new);

class RegisterController extends AsyncNotifier<AppUser?> {
  @override
  AppUser? build() => null;

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final useCase = ref.read(registerWithEmailPasswordProvider);
    final result = await useCase(
      RegisterWithEmailPasswordParams(
        name: name,
        email: email,
        password: password,
      ),
    );
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => AsyncData(user),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final useCase = ref.read(signInWithGoogleProvider);
    final result = await useCase(const NoParams());
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (user) => AsyncData(user),
    );
  }
}
