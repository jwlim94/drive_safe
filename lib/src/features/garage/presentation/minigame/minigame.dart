import 'package:drive_safe/src/features/garage/presentation/minigame/routes/gameplay.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/main_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/pause_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/retry_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/settings.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart' as flame;
import 'package:flutter/material.dart';

class RacingGame extends flame.FlameGame with HasKeyboardHandlerComponents {
  final musicValueNotifier = ValueNotifier(true);
  final sfxValueNotifier = ValueNotifier(true);

  late final _routes = <String, flame.Route>{
    MainMenu.id: flame.OverlayRoute(
      (context, game) => MainMenu(
        onPlayPressed: _startGame,
        onSettingsPressed: () => _routeById(Settings.id),
      ),
    ),
    Settings.id: flame.OverlayRoute(
      (context, game) => Settings(
        onBackPressed: _popRoute,
        musicValueListenable: musicValueNotifier,
        sfxValueListenable: sfxValueNotifier,
        onMusicValueChanged: (value) => musicValueNotifier.value = value,
        onSfxValueChanged: (value) => sfxValueNotifier.value = value,
      ),
    ),
    PauseMenu.id: flame.OverlayRoute(
      (context, game) => PauseMenu(
        onResumePressed: _resumeGame,
        onRestartPressed: _startGame,
        onExitPressed: _exitToMainMenu,
      ),
    ),
    RetryMenu.id: flame.OverlayRoute(
      (context, game) => RetryMenu(
        onRetryPressed: _startGame,
        onExitPressed: _exitToMainMenu,
      ),
    ),
  };

  late final _router = flame.RouterComponent(
    initialRoute: MainMenu.id,
    routes: _routes,
  );

  @override
  Future<void> onLoad() async {
    await add(_router);
  }

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  void _popRoute() {
    _router.pop();
  }

  void _startGame() {
    _router.pushReplacement(
      flame.Route(
        () => Gameplay(
          onPausePressed: _pauseGame,
          onGameOver: _showRetryMenu,
        ),
      ),
      name: Gameplay.id,
    );
  }

  void _pauseGame() {
    _router.pushNamed(PauseMenu.id);
    pauseEngine();
  }

  void _resumeGame() {
    _router.pop();
    resumeEngine();
  }

  void _exitToMainMenu() {
    _resumeGame();
    _router.pushReplacementNamed(MainMenu.id);
  }

  void _showRetryMenu() {
    _router.pushNamed(RetryMenu.id);
  }
}
