class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresá tu email.';
    if (!_emailPattern.hasMatch(email)) return 'Ingresá un email válido.';
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Ingresá tu contraseña.';
    if (password.length < 6) {
      return 'La contraseña necesita al menos 6 caracteres.';
    }
    return null;
  }
}
