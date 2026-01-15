import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../inventory/data/inventory_repository.dart';
import '../../inventory/domain/inventory_model.dart';
import '../../../shared/app_version.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  final String demoUserId = "3fa85f64-5717-4562-b3fc-2c963f66afa6";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pantryAsync = ref.watch(pantryItemsProvider(demoUserId));
    final lowStockAsync = ref.watch(lowStockItemsProvider(demoUserId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refillio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(pantryItemsProvider(demoUserId).future),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildWelcomeHeader(context),
            const SizedBox(height: 24),
            _buildStatCards(context, pantryAsync, lowStockAsync),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Quick Actions'),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Low Stock Alerts'),
            const SizedBox(height: 16),
            _buildLowStockList(context, lowStockAsync),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Refillio v${AppVersion.displayString}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFILLIO',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: colorScheme.onPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your pantry effortlessly.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(
    BuildContext context,
    AsyncValue<List<InventoryItem>> pantry,
    AsyncValue<List<InventoryItem>> lowStock,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Items',
            value: pantry.when(
              data: (items) => items.length.toString(),
              loading: () => '...',
              error: (_, _) => '!',
            ),
            icon: Icons.inventory_2_outlined,
            color: Theme.of(context).colorScheme.primaryContainer,
            onColor: Theme.of(context).colorScheme.onPrimaryContainer,
            onTap: () => context.push('/inventory'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Low Stock',
            value: lowStock.when(
              data: (items) => items.length.toString(),
              loading: () => '...',
              error: (_, _) => '!',
            ),
            icon: Icons.warning_amber_rounded,
            color: Theme.of(context).colorScheme.errorContainer,
            onColor: Theme.of(context).colorScheme.onErrorContainer,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _QuickActionButton(
          label: 'Add Item',
          icon: Icons.add_box_outlined,
          onTap: () => context.push('/inventory/add'),
        ),
        _QuickActionButton(
          label: 'Scan',
          icon: Icons.qr_code_scanner,
          onTap: () {},
        ),
        _QuickActionButton(
          label: 'Shopping',
          icon: Icons.shopping_cart_outlined,
          onTap: () {},
        ),
        _QuickActionButton(
          label: 'Settings',
          icon: Icons.settings_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLowStockList(BuildContext context, AsyncValue<List<InventoryItem>> lowStock) {
    return lowStock.when(
      data: (items) {
        if (items.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 16),
                  const Text('All items are well-stocked!'),
                ],
              ),
            ),
          );
        }
        return Column(
          children: items
              .take(3)
              .map((item) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                        child: Icon(
                          Icons.priority_high,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                      ),
                      title: Text(item.product?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('Only ${item.currentQty} left'),
                      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                    ),
                  ))
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error loading alerts: $err'),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white, // Use white for clean look, with colored icon/text or border
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 24, color: onColor),
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
