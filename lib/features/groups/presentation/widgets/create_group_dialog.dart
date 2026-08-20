import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/features/groups/presentation/providers/groups_provider.dart';

/// Diálogo para crear un grupo nuevo (y activarlo). Lo usan tanto la
/// pestaña de Grupos como el selector de grupo al agregar un lugar.
Future<void> showCreateGroupDialog(BuildContext context, WidgetRef ref) async {
  final controller = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Crear grupo'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ej. Amigos'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral400),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              await ref.read(groupsProvider.notifier).createGroup(name);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            },
            child: const Text('Crear'),
          ),
        ],
      );
    },
  );

  controller.dispose();
}
