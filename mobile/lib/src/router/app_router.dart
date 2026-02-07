import 'package:go_router/go_router.dart';
import '../features/catalog/presentation/product_list_screen.dart';
import '../features/catalog/presentation/add_edit_product_screen.dart';

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
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddEditProductScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.params['id'];
                return AddEditProductScreen(productId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
