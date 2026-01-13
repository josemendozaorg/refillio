import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

void main() {
  // Add ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(
      child: RefillioApp(),
    ),
  );
}
