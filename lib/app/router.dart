import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/analytics/crashlytics_service.dart';
import '../core/storage/app_controller.dart';
import '../features/daily_prayer/daily_prayer_screen.dart';
import '../features/festivals/festival_detail_screen.dart';
import '../features/festivals/festivals_screen.dart';
import '../features/mandir/mandir_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/prayers/prayer_detail_screen.dart';
import '../features/prayers/prayers_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/today/today_screen.dart';
import 'theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/launch',
    routes: [
      GoRoute(
        path: '/launch',
        builder: (context, state) => const _LaunchScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/daily-prayer',
        builder: (context, state) => const DailyPrayerScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => _AppShell(child: child),
        routes: [
          GoRoute(
            path: '/today',
            builder: (context, state) => const TodayScreen(),
          ),
          GoRoute(
            path: '/prayers',
            builder: (context, state) => const PrayersScreen(),
          ),
          GoRoute(
            path: '/mandir',
            builder: (context, state) => const MandirScreen(),
          ),
          GoRoute(
            path: '/festivals',
            builder: (context, state) => const FestivalsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/prayers/:id',
        builder: (context, state) => PrayerDetailScreen(
          prayerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/festivals/:id',
        builder: (context, state) => FestivalDetailScreen(
          festivalId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});

class ShanataniApp extends ConsumerWidget {
  const ShanataniApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shanatani',
      theme: buildShanataniTheme(),
      routerConfig: router,
      builder: (context, child) {
        ErrorWidget.builder = (details) {
          ref.read(crashlyticsServiceProvider).recordError(
                details.exception,
                StackTrace.current,
              );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child:
                  Text('Something went wrong.\n${details.exceptionAsString()}'),
            ),
          );
        };
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

class _LaunchScreen extends ConsumerStatefulWidget {
  const _LaunchScreen();

  @override
  ConsumerState<_LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends ConsumerState<_LaunchScreen> {
  bool _redirected = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(appControllerProvider, (_, next) {
      next.whenData((value) {
        if (_redirected) {
          return;
        }
        _redirected = true;
        if (!value.onboardingComplete) {
          context.go('/onboarding');
        } else if (!value.hasCompletedPrayerToday) {
          context.go('/daily-prayer');
        } else {
          context.go('/today');
        }
      });
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final destinations = <String>[
      '/today',
      '/prayers',
      '/mandir',
      '/festivals',
      '/profile',
    ];
    final index = destinations.indexWhere((path) => location.startsWith(path));
    final currentIndex = index < 0 ? 0 : index;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) => context.go(destinations[value]),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined), label: 'Today'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_rounded), label: 'Prayers'),
          NavigationDestination(
              icon: Icon(Icons.temple_hindu_rounded), label: 'Mandir'),
          NavigationDestination(
              icon: Icon(Icons.celebration_rounded), label: 'Festivals'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
