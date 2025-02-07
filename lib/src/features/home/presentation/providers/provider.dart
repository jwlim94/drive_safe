import 'package:drive_safe/src/features/home/domain/drive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PointsTimeNotifier extends Notifier<Set<Drive>> {
  //initial value
  @override
  Set<Drive> build() {
    return {
      Drive(points: 0, timeElapsed: Duration.zero, getAchievement: false)
    };
  }

  //methods to update state
  void updatePoints(Drive drive) {
    state = {drive};
  }
}

final pointsTimeProvider = NotifierProvider<PointsTimeNotifier, Set<Drive>>(() {
  return PointsTimeNotifier();
});
