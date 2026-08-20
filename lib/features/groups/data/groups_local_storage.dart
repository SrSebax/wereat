import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wereat/features/groups/domain/entities/group.dart';

const _groupsKey = 'groups';
const _activeGroupIdKey = 'active_group_id';

/// Guarda y carga los grupos del usuario, y cuál está activo, en el
/// dispositivo.
class GroupsLocalStorage {
  Future<List<Group>> loadGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_groupsKey);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Group.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveGroups(List<Group> groups) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(groups.map((g) => g.toJson()).toList());
    await prefs.setString(_groupsKey, encoded);
  }

  Future<String?> loadActiveGroupId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeGroupIdKey);
  }

  Future<void> saveActiveGroupId(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeGroupIdKey, groupId);
  }
}
