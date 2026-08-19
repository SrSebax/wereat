import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifica a GoRouter cuando cambia el estado de auth, para que reevalúe
/// sus redirects (p. ej. login/logout). Usa [Ref.listen] sobre el mismo
/// [StreamProvider] que lee el redirect, en lugar de una suscripción aparte
/// al stream de Firebase, para que el redirect nunca vea un valor
/// desactualizado (evita el race entre dos listeners del mismo stream).
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Ref ref, StreamProvider<User?> provider) {
    _subscription = ref.listen(provider, (_, _) => notifyListeners());
  }

  late final ProviderSubscription<AsyncValue<User?>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
