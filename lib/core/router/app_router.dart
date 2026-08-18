import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wereat/core/router/app_routes.dart';
import 'package:wereat/core/router/go_router_refresh_stream.dart';
import 'package:wereat/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:wereat/features/auth/presentation/pages/login_page.dart';
import 'package:wereat/features/auth/presentation/pages/register_page.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/map/presentation/pages/map_page.dart';

const _authRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(firebaseAuthProvider).authStateChanges(),
    ),
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final isResolving = authState.isLoading && !authState.hasValue;
      if (isResolving) return AppRoutes.splash;

      final isLoggedIn = authState.value != null;
      final onAuthRoute = _authRoutes.contains(state.matchedLocation);

      if (!isLoggedIn) return onAuthRoute ? null : AppRoutes.login;
      if (onAuthRoute || state.matchedLocation == AppRoutes.splash) {
        return AppRoutes.map;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => const MapPage(),
      ),
    ],
  );
});

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
