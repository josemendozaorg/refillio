import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/providers/http_client_provider.dart';

part 'hello_provider.g.dart';

@riverpod
Future<String> helloWorld(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/api/system/hello');
  return response.data['message'] as String;
}
