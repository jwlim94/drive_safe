import 'package:drive_safe/src/features/garage/presentation/minigame/constants/constants.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/world/rival_racing_world.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RacingGame extends FlameGame with RiverpodGameMixin, KeyboardEvents {
  RacingGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
          world: RivalRacingWorld(),
        );

  late Sprite playerCarSprite;

  @override
  Color backgroundColor() {
    return AppColors.customLightBlack;
  }
}
