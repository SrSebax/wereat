import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/usecases/usecase.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';

/// Placeholder de la pantalla principal (mapa compartido de lugares).
class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(signOutProvider)(const NoParams());
    if (!context.mounted) return;
    result.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _signOut(context, ref),
          ),
        ],
      ),
      body: const Center(child: Text('Mapa próximamente')),
    );
  }
}
