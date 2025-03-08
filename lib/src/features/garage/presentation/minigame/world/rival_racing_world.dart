import 'package:drive_safe/src/features/garage/presentation/minigame/minigame.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:flame/components.dart';

class RivalRacingWorld extends World with HasGameRef<RacingGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(RiverPodAwarePlayerStats());
  }
}
