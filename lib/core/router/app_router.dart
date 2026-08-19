import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wereat/core/navigation/main_shell.dart';
import 'package:wereat/core/router/app_routes.dart';
import 'package:wereat/core/router/go_router_refresh_stream.dart';
import 'package:wereat/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:wereat/features/auth/presentation/pages/login_page.dart';
import 'package:wereat/features/auth/presentation/pages/register_page.dart';
import 'package:wereat/features/auth/presentation/providers/auth_providers.dart';
import 'package:wereat/features/groups/presentation/pages/groups_page.dart';
import 'package:wereat/features/map/presentation/pages/map_page.dart';
import 'package:wereat/features/places/presentation/pages/places_list_page.dart';
import 'package:wereat/features/profile/presentation/pages/profile_page.dart';

const _authRoutes = {
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshNotifier(ref, authStateChangesProvider),
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final isResolving = authState.isLoading && !authState.hasValue;
      if (isResolving) return null;

      final isLoggedIn = authState.value != null;
      final onAuthRoute = _authRoutes.contains(state.matchedLocation);

      if (!isLoggedIn) return onAuthRoute ? null : AppRoutes.login;
      if (onAuthRoute) return AppRoutes.map;
      return null;
    },
    routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.groups,
                builder: (context, state) => const GroupsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.list,
                builder: (context, state) => const PlacesListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
