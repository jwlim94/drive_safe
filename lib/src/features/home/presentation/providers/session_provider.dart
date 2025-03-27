import 'package:drive_safe/src/features/home/domain/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

@riverpod
class SessionNotifier extends _$SessionNotifier {
  //initial value
  @override
  Session build() {
    return Session(
        points: 0,
        userGoal: 0,
        timeElapsed: const Duration(minutes: 0, seconds: 0),
        getAchievement: false,
        goalCompleteByTime: 0,
        sessionBadges: []);
  }

  //methods to alter states
  void updateSession(Session session) {
    state = session;
  }

  void addSessionBadges(String badge) {
    state.sessionBadges.add(badge);
  }

  void addNewUserGoal(int newUserGoal) {
    state = Session(
      points: state.points,
      userGoal: newUserGoal,
      timeElapsed: state.timeElapsed,
      getAchievement: state.getAchievement,
      goalCompleteByTime: state.goalCompleteByTime,
      sessionBadges: state.sessionBadges,
    );
  }
}
