import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlutterPlayerStatsComponent extends ConsumerWidget {
  const FlutterPlayerStatsComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context)
        .textTheme
        .headlineSmall
        ?.copyWith(color: Colors.white);

    final user = ref.watch(currentUserStateProvider);

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Text('Flutter Stats', style: textStyle),
          Text(
              user != null
                  ? 'Primary Color: ${user.primaryColor}'
                  : 'Loading...',
              style: textStyle),
        ],
      ),
    );
  }
}

class RiverPodAwarePlayerStats extends PositionComponent
    with RiverpodComponentMixin {
  late TextComponent colorText;
  int currentColor = 0;

  @override
  void onMount() {
    super.onMount();

    // read the current user state on initialization
    final user = ref.read(currentUserStateProvider);
    if (user != null) {
      currentColor = user.primaryColor;
    }

    // initialize text component
    colorText = TextComponent(
      text: 'Color: $currentColor',
      position: Vector2(10, 10),
    );

    add(colorText);
  }
}
