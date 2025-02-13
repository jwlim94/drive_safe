import 'package:drive_safe/src/features/home/domain/drive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'last_drive_provider.g.dart';

@riverpod
class LastDriveNotifier extends _$LastDriveNotifier {
  //initial value
  @override
  Drive build() {
    return Drive(
        points: 0,
        timeElapsed: const Duration(minutes: 0, seconds: 0),
        getAchievement: false);
  }

  //methods to alter states
  void addLastDrive(Drive drive) {
    state = drive;
  }
}
