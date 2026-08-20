import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/theme/app_colors.dart';
import 'package:wereat/core/theme/app_radius.dart';
import 'package:wereat/core/theme/app_spacing.dart';
import 'package:wereat/features/groups/domain/entities/group.dart';
import 'package:wereat/features/groups/presentation/providers/groups_provider.dart';
import 'package:wereat/features/groups/presentation/widgets/create_group_dialog.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final activeGroupId = ref.watch(activeGroupProvider).value;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Grupos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 22),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => showCreateGroupDialog(context, ref),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coral400,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Crear grupo'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: groupsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    const Center(child: Text('No pudimos cargar tus grupos')),
                data: (groups) {
                  if (groups.isEmpty) {
                    return _EmptyGroups(
                      onCreate: () => showCreateGroupDialog(context, ref),
                    );
                  }

                  return ListView.separated(
                    itemCount: groups.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return _GroupTile(
                        group: group,
                        isActive: group.id == activeGroupId,
                        onTap: () => ref
                            .read(activeGroupProvider.notifier)
                            .selectGroup(group.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGroups extends StatelessWidget {
  const _EmptyGroups({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups_outlined, size: 40, color: AppColors.gray200),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Aún no tienes ningún grupo',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Crea uno para empezar a guardar lugares con tu gente.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray400),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onCreate,
            style: FilledButton.styleFrom(backgroundColor: AppColors.coral400),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Crear tu primer grupo'),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.isActive,
    required this.onTap,
  });

  final Group group;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isActive ? AppColors.teal400 : AppColors.gray100,
              width: isActive ? 1.5 : 0.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.teal400 : AppColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.groups,
                  size: 18,
                  color: isActive ? Colors.white : AppColors.gray600,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isActive)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.teal400,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
