import 'package:drive_safe/src/features/leaderboard/data/leagues_repository.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_current_league_controller.g.dart';

@Riverpod(keepAlive: true)
class CacheCurrentLeagueController extends _$CacheCurrentLeagueController {
  @override
  FutureOr<void> build() {
    // no op
  }

  Future<void> cacheCurrentLeague() async {
    final leagueRepository = ref.read(leaguesRepositoryProvider);

    final currentUser = ref.read(currentUserStateProvider);
    if (currentUser == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => leagueRepository.getUserLeague(currentUser.leagueId),
    );

    if (state.hasError) return FirebaseAuth.instance.signOut();
  }
}
