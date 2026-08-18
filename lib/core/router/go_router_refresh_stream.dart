import 'dart:async';

import 'package:flutter/foundation.dart';

/// Convierte un [Stream] en un [Listenable] para que GoRouter pueda
/// reevaluar sus redirects cuando el stream emite (p. ej. cambios de sesión).
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
