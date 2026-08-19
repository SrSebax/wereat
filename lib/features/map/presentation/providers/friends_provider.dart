import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/features/map/domain/entities/friend.dart';

/// Mock temporal: amigos del grupo explorando el mapa en tiempo real.
final groupFriendsProvider = Provider<List<Friend>>((ref) {
  return const [
    Friend(
      id: 'f1',
      name: 'Ana',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      latitude: 6.2515,
      longitude: -75.5720,
    ),
    Friend(
      id: 'f2',
      name: 'Juli',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
      latitude: 6.2320,
      longitude: -75.5620,
    ),
    Friend(
      id: 'f3',
      name: 'Sebas',
      avatarUrl: 'https://i.pravatar.cc/150?img=33',
      latitude: 6.2210,
      longitude: -75.5810,
    ),
  ];
});
