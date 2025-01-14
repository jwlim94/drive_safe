import 'package:drive_safe/src/features/example/domain/example.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'example_controller.g.dart';

// Example controller
@riverpod
class ExampleController extends _$ExampleController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> createExample(Example example) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
