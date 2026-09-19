import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class SoundService extends ChangeNotifier {

  // Звуки
  final Map<SoundType, AudioSource> sounds = {};

  // Инициализация
  Future init() async {
    await SoLoud.instance.init();
    for (final type in SoundType.values) {
      sounds[type] = await SoLoud.instance.loadAsset(type.path);
    }
  }

  // Воспроизведение
  Future play(SoundType type) async {
    final sound = sounds[type];
    if (sound == null) return;
    SoLoud.instance.play(sound);
  }
}

// Типы звуков
enum SoundType {
  recordOrPurport,
  levelUp,
  statsUp,
}

extension SoundTypeExt on SoundType {
  // Пути к аудиофайлам
  String get path {
    switch(this) {
      case SoundType.recordOrPurport:
        return 'assets/sounds/info.wav';
      case SoundType.levelUp:
        return 'assets/sounds/info.wav';
      case SoundType.statsUp:
        return 'assets/sounds/info.wav';
    }
  }
}