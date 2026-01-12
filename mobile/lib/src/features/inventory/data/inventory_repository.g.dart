// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider = InventoryRepositoryProvider._();

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'875627324751bac9e2d1a789acb29bd0785a1f41';

@ProviderFor(pantryItems)
final pantryItemsProvider = PantryItemsFamily._();

final class PantryItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItem>>,
          List<InventoryItem>,
          FutureOr<List<InventoryItem>>
        >
    with
        $FutureModifier<List<InventoryItem>>,
        $FutureProvider<List<InventoryItem>> {
  PantryItemsProvider._({
    required PantryItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pantryItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pantryItemsHash();

  @override
  String toString() {
    return r'pantryItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItem>> create(Ref ref) {
    final argument = this.argument as String;
    return pantryItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PantryItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pantryItemsHash() => r'3cc4a361520024aa156614f4d56719a7a286b443';

final class PantryItemsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<InventoryItem>>, String> {
  PantryItemsFamily._()
    : super(
        retry: null,
        name: r'pantryItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PantryItemsProvider call(String userId) =>
      PantryItemsProvider._(argument: userId, from: this);

  @override
  String toString() => r'pantryItemsProvider';
}
