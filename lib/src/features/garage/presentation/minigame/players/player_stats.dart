import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

class PlayerStats extends Component with HasGameRef {
  PlayerStats({
    this.maxLives = 3,
    this.initialSpeed = 1.0,
    this.maxSpeed = 5.0,
    this.speedIncreaseRate = 0.1,
    this.speedIncreaseInterval = 5.0,
    this.invincibilityDuration = 2.0,
  })  : _lives = maxLives,
        _speed = initialSpeed,
        super();

  int _score = 0;
  int _lives;
  final int maxLives;
  double _speed;
  final double initialSpeed;
  final double maxSpeed;
  final double speedIncreaseRate;
  final double speedIncreaseInterval;
  final double invincibilityDuration;

  double _gameTime = 0.0;
  double _lastSpeedIncreaseTime = 0.0;
  double _invincibilityTime = 0.0;

  int get score => _score;
  void addScore(int points) => _score += points;

  int get lives => _lives;
  bool get isDead => _lives <= 0;

  double get speed => _speed;
  double getSpeedFactor() => _speed / initialSpeed;

  double get invincibilityTime => _invincibilityTime;
  bool get isInvincible => _invincibilityTime > 0;

  @override
  void onMount() {
    super.onMount();
    _reset();
  }

  void _reset() {
    _score = 0;
    _lives = maxLives;
    _speed = initialSpeed;
    _gameTime = 0.0;
    _lastSpeedIncreaseTime = 0.0;
    _invincibilityTime = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _gameTime += dt;

    if (_gameTime - _lastSpeedIncreaseTime >= speedIncreaseInterval) {
      _increaseSpeed();
      _lastSpeedIncreaseTime = _gameTime;
    }

    if (_invincibilityTime > 0) {
      _invincibilityTime -= dt;
    }
  }

  void _increaseSpeed() {
    if (_speed < maxSpeed) {
      _speed = (_speed + speedIncreaseRate).clamp(initialSpeed, maxSpeed);
    }
  }

  void setInvincibleFor(Duration duration) {
    _invincibilityTime = duration.inSeconds.toDouble();
  }

  void collision() {
    if (!isInvincible) {
      _lives--;
      _invincibilityTime = invincibilityDuration;
    }
  }

  void reset() {
    _reset();
  }
}

class RiverPodAwarePlayerStats extends PlayerStats with RiverpodComponentMixin {
  @override
  void onMount() {
    super.onMount();

    final user = ref.read(currentUserStateProvider);
    if (user != null) {
      // currentColor = user.primaryColor;
      // userOpponents = user.friends;
    }
  }
}
