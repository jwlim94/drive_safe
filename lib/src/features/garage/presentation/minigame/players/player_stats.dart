import 'dart:async';
import 'dart:ui';

import 'package:drive_safe/src/features/garage/presentation/minigame/constants/constants.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/local_data/hive_repository.dart';
import 'package:drive_safe/src/features/user/domain/user.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

class RiverPodAwarePlayerStats extends TextComponent
    with RiverpodComponentMixin {
  late TextComponent colorText;
  int currentColor = 0;
  int currentPoints = 0;
  List<String> userOpponents = [];

  @override
  void onMount() {
    super.onMount();

    // read the current user state on initialization
    final user = ref.read(currentUserStateProvider);
    //final hiveRepo = ref.read(hiveRepositoryProvider);
    if (user != null) {
      //TODO: create state for current user league to access it here.
      currentColor = user.primaryColor;
      //hiveRepo.getPlayerCarColor(currentColor);
      for (String opponent in user.friends) {
        userOpponents.add(opponent);
      }
    }

    //initialize text component
    colorText = TextComponent(
      text: 'Color: $currentColor',
      size: Vector2.all(300),
    );

    add(colorText);
  }
}
