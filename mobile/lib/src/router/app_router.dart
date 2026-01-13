import 'package:go_router/go_router.dart';
import '../features/inventory/presentation/pantry_screen.dart';
import '../features/inventory/presentation/add_item_screen.dart';
import '../features/system/presentation/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
      routes: [
        GoRoute(
          path: 'inventory',
          builder: (context, state) => const PantryScreen(),
        ),
        GoRoute(
          path: 'inventory/add',
          builder: (context, state) => const AddItemScreen(),
        ),
      ],
    ),
  ],
);
