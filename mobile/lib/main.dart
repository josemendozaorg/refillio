import 'package:flutter/material.dart';

void main() {
  runApp(const RefillioApp());
}

class RefillioApp extends StatelessWidget {
  const RefillioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refillio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refillio'),
        centerTitle: true,
      ),
      body: Center(
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
            const Text('Your Home Mini-ERP is ready.'),
          ],
        ),
      ),
    );
  }
}
