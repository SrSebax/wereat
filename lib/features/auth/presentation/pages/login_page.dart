import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/core/utils/validators.dart';
import 'package:wereat/core/widgets/wereat_logo.dart';
import 'package:wereat/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:wereat/features/auth/presentation/pages/register_page.dart';
import 'package:wereat/features/auth/presentation/providers/login_controller.dart';
import 'package:wereat/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:wereat/features/map/presentation/pages/map_page.dart';

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
    ref.read(loginControllerProvider.notifier).signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _submitGoogle() {
    ref.read(loginControllerProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user == null) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MapPage()),
          );
        },
      );
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final errorMessage = loginState.hasError ? loginState.error.toString() : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Center(child: WereatLogo()),
                const SizedBox(height: 8),
                Text(
                  'Todos tus lugares favoritos, en un solo mapa.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.gray600),
                ),
                const SizedBox(height: 40),
                if (errorMessage != null) ...[
                  _ErrorBanner(message: errorMessage),
                  const SizedBox(height: AppSpacing.lg),
                ],
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  enabled: !isLoading,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
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
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordPage(),
                              ),
                            ),
                    child: const Text('Olvidé mi contraseña'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton(
                  onPressed: isLoading ? null : _submitEmailAndPassword,
                  child: isLoading
                      ? const _ButtonSpinner(color: AppColors.coral50)
                      : const Text('Iniciar sesión'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: isLoading ? null : _submitGoogle,
                  child: isLoading
                      ? const _ButtonSpinner(color: AppColors.gray600)
                      : const Text('Continuar con Google'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterPage(),
                              ),
                            ),
                    child: const Text('¿No tenés cuenta? Registrate'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.coral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.coral600),
      ),
    );
  }
}

class _ButtonSpinner extends StatelessWidget {
  const _ButtonSpinner({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: color),
    );
  }
}
