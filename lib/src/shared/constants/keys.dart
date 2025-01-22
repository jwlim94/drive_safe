import 'package:flutter/material.dart';

class Keys {
  // Routing
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  static final leaderboardNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'leaderboard');
  static final garageNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'garage');
  static final profileNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profile');
}
