import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wereat/core/router/app_routes.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/utils/validators.dart';
import 'package:wereat/features/auth/presentation/providers/login_controller.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:wereat/features/auth/presentation/widgets/button_spinner.dart';
import 'package:wereat/features/auth/presentation/widgets/error_banner.dart';
import 'package:wereat/features/auth/presentation/widgets/google_logo.dart';
import 'package:wereat/features/auth/presentation/widgets/login_header.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitEmailAndPassword() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(loginControllerProvider.notifier)
        .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _submitGoogle() {
    ref.read(loginControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final errorMessage = loginState.hasError
        ? loginState.error.toString()
        : null;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -32),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppRadius.card * 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gray900.withValues(alpha: 0.10),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Iniciar sesión',
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: AppSpacing.lg),
                              if (errorMessage != null) ...[
                                ErrorBanner(message: errorMessage),
                                const SizedBox(height: AppSpacing.lg),
                              ],
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
                                autofillHints: const [AutofillHints.password],
                                enabled: !isLoading,
                                validator: Validators.password,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.push(
                                          AppRoutes.forgotPassword,
                                        ),
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : _submitEmailAndPassword,
                                child: isLoading
                                    ? const ButtonSpinner(
                                        color: AppColors.coral50,
                                      )
                                    : const Text('Iniciar sesión'),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(color: AppColors.gray100),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'o',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.gray400,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: Divider(color: AppColors.gray100),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              OutlinedButton(
                                onPressed: isLoading ? null : _submitGoogle,
                                child: isLoading
                                    ? const ButtonSpinner(
                                        color: AppColors.gray600,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const GoogleLogo(),
                                          const SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              'Continuar con Google',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Center(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.push(AppRoutes.register),
                        child: const Text('¿No tienes cuenta? Registrate'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
