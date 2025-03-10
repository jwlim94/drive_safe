import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_repository.g.dart';

class HiveRepository {
  final box = Hive.box("gameData");

  void addPlayerStats() {
    box.put("playerCarColor", 0);
    box.put("playerOpponents", []);
    //box.put("carStats", 'value');
  }

  int getPlayerCarColor() {
    final playerCarColor = box.get("playerCarColor");
    return playerCarColor;
  }
}

@Riverpod(keepAlive: true)
HiveRepository hiveRepository(Ref ref) {
  return HiveRepository();
}
