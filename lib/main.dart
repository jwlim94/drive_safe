import 'package:drive_safe/firebase_options.dart';
import 'package:drive_safe/src/app.dart';
import 'package:drive_safe/src/features/garage/presentation/minigame_presentation/minigame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final game = RacingGame();
  // Initialize the app with ProviderScope for Riverpod state management
  runApp(ProviderScope(child: App(game: game)));
}
