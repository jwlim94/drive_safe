import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_service.g.dart';

// Example service
class ExampleService {
  const ExampleService(this.ref);
  final Ref ref;

  Future<void> createExample() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
ExampleService exampleService(Ref ref) {
  return ExampleService(ref);
}
