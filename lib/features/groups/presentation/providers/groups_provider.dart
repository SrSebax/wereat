import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/groups/data/groups_local_storage.dart';
import 'package:wereat/features/groups/domain/entities/group.dart';

const defaultGroupId = 'default';

final _groupsLocalStorageProvider = Provider((ref) => GroupsLocalStorage());

/// Grupos del usuario. Si no hay ninguno guardado (primer uso de la app),
/// siembra "Mi grupo" para que el home nunca quede sin nada que mostrar.
class GroupsNotifier extends AsyncNotifier<List<Group>> {
  @override
  Future<List<Group>> build() async {
    final storage = ref.read(_groupsLocalStorageProvider);
    final groups = await storage.loadGroups();
    if (groups.isNotEmpty) return groups;

    final seeded = [
      Group(id: defaultGroupId, name: 'Mi grupo', createdAt: DateTime.now()),
    ];
    await storage.saveGroups(seeded);
    return seeded;
  }

  Future<Group> createGroup(String name) async {
    final storage = ref.read(_groupsLocalStorageProvider);
    final group = Group(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
    );

    final groups = [...await future, group];
    await storage.saveGroups(groups);
    state = AsyncData(groups);

    await ref.read(activeGroupProvider.notifier).selectGroup(group.id);
    return group;
  }
}

final groupsProvider = AsyncNotifierProvider<GroupsNotifier, List<Group>>(
  GroupsNotifier.new,
);

/// Id del grupo activo: cuyo contenido se ve en el mapa/lista del home.
class ActiveGroupNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    final groups = await ref.watch(groupsProvider.future);
    final storage = ref.read(_groupsLocalStorageProvider);
    final storedId = await storage.loadActiveGroupId();

    if (storedId != null && groups.any((g) => g.id == storedId)) {
      return storedId;
    }

    final fallbackId = groups.first.id;
    await storage.saveActiveGroupId(fallbackId);
    return fallbackId;
  }

  Future<void> selectGroup(String groupId) async {
    await ref.read(_groupsLocalStorageProvider).saveActiveGroupId(groupId);
    state = AsyncData(groupId);
  }
}

final activeGroupProvider = AsyncNotifierProvider<ActiveGroupNotifier, String>(
  ActiveGroupNotifier.new,
);
