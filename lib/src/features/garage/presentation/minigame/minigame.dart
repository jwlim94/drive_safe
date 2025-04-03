import 'package:drive_safe/src/features/garage/presentation/minigame/players/player_stats.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/gameplay.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/main_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/pause_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/retry_menu.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame/routes/settings.dart';
import 'package:flame/game.dart' as flame;
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';

class RacingGame extends flame.FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, DragCallbacks {
  final musicValueNotifier = ValueNotifier(false);
  final sfxValueNotifier = ValueNotifier(false);
  bool isMusicEnabled = false;

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
        onMusicValueChanged: (value) {
          musicValueNotifier.value = value;
          toggleMusic(value);
        },
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
    await FlameAudio.audioCache.load('background_music.mp3');
    isMusicEnabled = musicValueNotifier.value;
    if (isMusicEnabled) {
      FlameAudio.bgm.play('background_music.mp3');
    }

    await add(_router);
  }

  void toggleMusic(bool enabled) {
    isMusicEnabled = enabled;
    if (enabled) {
      FlameAudio.bgm.play('background_music.mp3');
    } else {
      FlameAudio.bgm.stop();
    }
  }

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  void _popRoute() {
    _router.pop();
  }

  void _startGame() {
    if (_router.currentRoute.name == RetryMenu.id) {
      _router.pop();
    }
    resumeEngine();

    _router.pushReplacement(
      flame.Route(
        () => Gameplay(
          onPausePressed: _pauseGame,
          onGameOver: _showRetryMenu,
          sfxEnabled: sfxValueNotifier.value,
        ),
      ),
      name: Gameplay.id,
    );
  }

  void _pauseGame() {
    if (isMusicEnabled) {
      FlameAudio.bgm.pause();
    }

    _router.pushNamed(PauseMenu.id);
    pauseEngine();
  }

  void _resumeGame() {
    if (isMusicEnabled) {
      FlameAudio.bgm.resume();
    }

    _router.pop();
    resumeEngine();
  }

  void _exitToMainMenu() {
    resumeEngine();

    if (children.query<PlayerStats>().isNotEmpty) {
      children.query<PlayerStats>().first.reset();
    }

    if (_router.currentRoute.name == RetryMenu.id) {
      _router.pop();
    }

    _router.pushReplacementNamed(MainMenu.id);
  }

  void _showRetryMenu() {
    _router.pushNamed(RetryMenu.id);
    pauseEngine();
  }
}

class TouchController extends JoystickComponent with HasGameRef {
  TouchController()
      : super(
          knob: CircleComponent(
            radius: 10,
            paint: Paint()..color = Colors.white.withAlpha(200),
          ),
          background: CircleComponent(
            radius: 20,
            paint: Paint()..color = Colors.grey.withAlpha(200),
          ),
          priority: 100,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = Vector2(
      (gameRef.size.x / 4) * 3,
      gameRef.size.y - 75,
    );
  }
}
