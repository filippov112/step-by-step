import 'dart:async';
import 'package:chaos_control/models/pur_sound.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends ChangeNotifier {
  StreamSubscription<int?>? _indexStream;
  final AudioPlayer _player = AudioPlayer();

  final cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
  List<AudioSource> _playlist = [];
  List<PurSound> _sounds = [];
  int _currentIndex = -1;
  
  AudioPlayerService() {
    _indexStream = _player.currentIndexStream.listen((id) {
      if (id != null) {
        _currentIndex = id;
        notifyListeners();
      }
    });
  }

  // =========================

  // Плеер
  AudioPlayer get player => _player;
  // Текущий трек
  PurSound? get current => _currentIndex < 0 ? null : _sounds[_currentIndex];

  
  // Переключить плейлист
  Future<void> playFile(PurSound file, List<PurSound> sounds) async {
    _sounds = sounds;
    _playlist = sounds.map((e) => AudioSource.file(e.path)).toList();
    await _player.setAudioSources(_playlist, initialIndex: sounds.indexWhere((s) => s.id == file.id));
    _player.play();
    notifyListeners();
  }
  
  // Пауза
  Future<void> pause() => _player.pause();

  // Играть
  Future<void> resume() => _player.play();

  // Режим переключения треков
  Future changeMode(LoopMode mode) async {
    _player.setLoopMode(cycleModes[
      (cycleModes.indexOf(mode) + 1) %
          cycleModes.length]);
  }

  // Остановка
  Future<void> stop() async {
    _player.stop();
  } 

  // Перемотать
  Future<void> seek(Duration position) => _player.seek(position);
  
  // Следующий трек
  Future seekToNext() async {
    _player.seekToNext();
  }

  // Предыдущий трек
  Future seekToPrevious() async {
    _player.seekToPrevious();
  }
  
  // Изменить громкость
  Future<void> setVolume(double volume) => _player.setVolume(volume);

  // Изменить скорость
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  
  @override
  void dispose(){
    _indexStream?.cancel();
    _indexStream = null;
    _player.dispose();
    super.dispose();
  } 
}