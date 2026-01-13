import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/inventory/data/inventory_repository.dart';
import 'package:mobile/src/shared/providers/http_client_provider.dart';

@GenerateMocks([Dio])
import 'inventory_repository_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late ProviderContainer container;

  setUp(() {
    mockDio = MockDio();
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(mockDio),
      ],
    );
  });

  test('getPantry returns list of items', () async {
    // Arrange
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: 'inventory'),
              data: [
                {
                  'id': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
                  'userId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
                  'currentQty': 2.0,
                  'reorderPoint': 1.0, 
                  'autoReorder': false
                }
              ],
              statusCode: 200,
            ));

    // Act
    final repo = container.read(inventoryRepositoryProvider);
    final result = await repo.getPantry('3fa85f64-5717-4562-b3fc-2c963f66afa6');

    // Assert
    expect(result, isNotEmpty);
    expect(result.first.currentQty, 2.0);
    verify(mockDio.get('inventory', queryParameters: {'userId': '3fa85f64-5717-4562-b3fc-2c963f66afa6'})).called(1);
  });
}
