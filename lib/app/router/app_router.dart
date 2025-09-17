import 'package:go_router/go_router.dart';

import '../../presentation/screens/home_screen.dart';

GoRouter getRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(id: ''),
    ),
    GoRoute(
      path: '/:id',
      builder: (context, state) => HomeScreen(id: state.pathParameters['id']!),
    ),
  ],
);
