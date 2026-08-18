import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/utils/validators.dart';
import 'package:wereat/features/auth/presentation/providers/forgot_password_controller.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_card_scaffold.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:wereat/features/auth/presentation/widgets/button_spinner.dart';
import 'package:wereat/features/auth/presentation/widgets/error_banner.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetEmail(email: _emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final isLoading = state.isLoading;
    final wasSent = state.value ?? false;
    final errorMessage = state.hasError ? state.error.toString() : null;
    final textTheme = Theme.of(context).textTheme;

    return AuthCardScaffold(
      title: '¿Olvidaste tu contraseña?',
      subtitle: 'Ingresá tu email y te mandamos un enlace para restablecerla.',
      children: wasSent
          ? [
              Row(
                children: [
                  const Icon(
                    Icons.mark_email_read_outlined,
                    color: AppColors.teal600,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Si el email existe en wereat, te llegó un enlace para '
                      'restablecer tu contraseña.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Volver a iniciar sesión'),
              ),
            ]
          : [
              if (errorMessage != null) ...[
                ErrorBanner(message: errorMessage),
                const SizedBox(height: AppSpacing.lg),
              ],
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      enabled: !isLoading,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const ButtonSpinner(color: AppColors.coral50)
                          : const Text('Enviar enlace'),
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}
