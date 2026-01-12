import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/system/hello_provider.dart';
import 'package:mobile/src/shared/app_version.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helloAsync = ref.watch(helloWorldProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refillio Smoke Test'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.blueGrey),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Refillio',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text('Backend Connection Status:'),
                const SizedBox(height: 10),
                helloAsync.when(
                  data: (message) => Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Text(
                        'Error: $err',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => ref.refresh(helloWorldProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              'Build: ${AppVersion.displayString}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
