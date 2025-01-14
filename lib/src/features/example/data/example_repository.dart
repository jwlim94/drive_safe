import 'package:drive_safe/src/features/example/domain/example.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_repository.g.dart';

// Example repository
class ExampleRepository {
  const ExampleRepository();

  Future<void> createExample(Example example) async {
    // Replace with Firestore logic
    await Future.delayed(const Duration(seconds: 1));
  }
}

@Riverpod(keepAlive: true)
ExampleRepository exampleRepository(Ref ref) {
  return const ExampleRepository();
}
