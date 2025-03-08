import 'package:drive_safe/src/features/garage/presentation/minigame/constants/constants.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/rival_racing_world.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RacingGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final map = await TiledComponent.load("desert_track.tmx", Vector2.all(16));
    await add(map);
  }

  @override
  Color backgroundColor() {
    return AppColors.customLightBlack;
  }
}
