import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/utils/validators.dart';
import 'package:wereat/features/auth/presentation/providers/register_controller.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_card_scaffold.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:wereat/features/auth/presentation/widgets/button_spinner.dart';
import 'package:wereat/features/auth/presentation/widgets/error_banner.dart';
import 'package:wereat/features/auth/presentation/widgets/google_logo.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if ((value ?? '').trim().isEmpty) return 'Ingresá tu nombre.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) return 'Confirmá tu contraseña.';
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden.';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(registerControllerProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _submitGoogle() {
    ref.read(registerControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerControllerProvider);
    final isLoading = registerState.isLoading;
    final errorMessage = registerState.hasError
        ? registerState.error.toString()
        : null;
    final textTheme = Theme.of(context).textTheme;

    return AuthCardScaffold(
      title: 'Creá tu cuenta',
      subtitle: 'Sumate para guardar y compartir tus lugares favoritos.',
      children: [
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
                controller: _nameController,
                label: 'Nombre',
                icon: Icons.person_outline,
                autofillHints: const [AutofillHints.name],
                enabled: !isLoading,
                validator: _validateName,
              ),
              const SizedBox(height: AppSpacing.md),
              AuthTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                enabled: !isLoading,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.md),
              AuthTextField(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                enabled: !isLoading,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                enabled: !isLoading,
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const ButtonSpinner(color: AppColors.coral50)
                    : const Text('Crear cuenta'),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.gray100)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'o',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.gray100)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: isLoading ? null : _submitGoogle,
                child: isLoading
                    ? const ButtonSpinner(color: AppColors.gray600)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const GoogleLogo(),
                          const SizedBox(width: 10),
                          const Text('Continuar con Google'),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
