import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/auth/domain/usecases/send_password_reset_email.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, bool>(
      ForgotPasswordController.new,
    );

/// El estado data (true) indica que el email de recuperación se envió.
class ForgotPasswordController extends AsyncNotifier<bool> {
  @override
  bool build() => false;

  Future<void> sendResetEmail({required String email}) async {
    state = const AsyncLoading();
    final useCase = ref.read(sendPasswordResetEmailProvider);
    final result = await useCase(SendPasswordResetEmailParams(email: email));
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(true),
    );
  }
}
