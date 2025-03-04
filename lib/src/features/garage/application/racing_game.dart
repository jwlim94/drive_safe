import 'dart:ui';

import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/home_page.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/map_selector_page.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class RacingGame extends FlameGame {
  late final RouterComponent router;
  final carImages = Images(prefix: 'assets/mini_game/cars/');

  @override
  Future<void> onLoad() async {
    // Load some images
    Image car = await carImages.load('npc_cars.png');
    final carSprite = Sprite(car);
    // In-game routing
    router = RouterComponent(
      routes: {
        'home-page': Route(HomePage.new),
        'map-selector': Route(MapSelector.new),
        //'race': Route(RacePage.new),
      },
      initialRoute: 'home-page',
    );

    add(router);
  }
}
