import 'package:flutter/material.dart';

/// Placeholder de la pantalla de recuperación de contraseña.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olvidé mi contraseña')),
      body: const Center(child: Text('Recuperación próximamente')),
    );
  }
}
