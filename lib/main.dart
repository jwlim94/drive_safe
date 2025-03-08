import 'package:drive_safe/firebase_options.dart';
import 'package:drive_safe/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive (local noSQL data storage for minigame)
  await Hive.initFlutter();
  await Hive.openBox("gameData");

  // Initialize the app with ProviderScope for Riverpod state management
  runApp(const ProviderScope(child: App()));
}
