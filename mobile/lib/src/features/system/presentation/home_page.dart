import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(pantryItemsProvider(demoUserId).future),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildSummaryCard(context, pantryAsync, lowStockAsync),
                  const SizedBox(height: 40),
                  _buildSectionHeader(context, 'Low Stock Alerts'),
                  const SizedBox(height: 16),
                  _buildLowStockCarousel(context, lowStockAsync),
                  const SizedBox(height: 40),
                  _buildSectionHeader(context, 'Quick Actions'),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 60),
                  Center(
                    child: Text(
                      'Refillio v${AppVersion.displayString}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.withValues(alpha: 0.5),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Refillio',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Your smart pantry manager',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
        _GlassIcon(
          icon: Icons.person_outline_rounded,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AsyncValue<List<InventoryItem>> pantry,
    AsyncValue<List<InventoryItem>> lowStock,
  ) {
    return _GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'Items',
                value: pantry.when(
                  data: (items) => items.length.toString(),
                  loading: () => '...',
                  error: (_, _) => '!',
                ),
              ),
              _StatItem(
                label: 'Categories',
                value: '12', // Static for now
              ),
              _StatItem(
                label: 'Value',
                value: '\$450', // Static for now
                isCurrency: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPantryStatus(context, pantry),
        ],
      ),
    );
  }

  Widget _buildPantryStatus(BuildContext context, AsyncValue<List<InventoryItem>> pantry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '85% Stocked',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.85,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(Icons.chevron_right, size: 20, color: Colors.white.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildLowStockCarousel(BuildContext context, AsyncValue<List<InventoryItem>> lowStock) {
    return SizedBox(
      height: 160,
      child: lowStock.when(
        data: (items) {
          if (items.isEmpty) {
            return const _GlassContainer(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(child: Text('All items are well-stocked!')),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              final isCritical = item.currentQty <= item.reorderPoint * 0.5;
              return _AlertCard(
                name: item.product?.name ?? 'Unknown',
                status: isCritical ? 'Critical, Gold' : 'Low, Emerald',
                color: isCritical 
                  ? const Color(0xFFF59E0B).withValues(alpha: 0.2)
                  : const Color(0xFF10B981).withValues(alpha: 0.2),
                icon: isCritical ? Icons.warning_amber_rounded : Icons.eco_outlined,
                onReorder: () {},
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickAction(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Scan Item',
          onTap: () {},
        ),
        _QuickAction(
          icon: Icons.add_rounded,
          label: 'Add Item',
          onTap: () => context.push('/inventory/add'),
        ),
        _QuickAction(
          icon: Icons.list_alt_rounded,
          label: 'Shopping List',
          onTap: () {},
        ),
      ],
    );
  }
}

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const _GlassContainer({
    required this.child,
    this.padding,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isCurrency;

  const _StatItem({
    required this.label,
    required this.value,
    this.isCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isCurrency ? Colors.white : Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String name;
  final String status;
  final Color color;
  final IconData icon;
  final VoidCallback onReorder;

  const _AlertCard({
    required this.name,
    required this.status,
    required this.color,
    required this.icon,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 28),
          const Spacer(),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReorder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.zero,
            ),
            child: const Text('Reorder', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _GlassContainer(
      borderRadius: 12,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GlassContainer(
          borderRadius: 100,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
