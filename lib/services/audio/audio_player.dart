import 'package:chaos_control/models/pur_sound.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  final cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];

  AudioPlayer get player => _player;

  List<AudioSource> _playlist = [];
  List<PurSound> _sounds = [];

  int _currentIndex = -1;
  PurSound? get current => _currentIndex < 0 ? null : _sounds[_currentIndex];


  void _setPlaylist(List<PurSound> sounds) {
    _sounds = sounds;
    _playlist = sounds.map((e) => AudioSource.file(e.path)).toList();
  }
  
  Future<void> playFile(PurSound file, List<PurSound> sounds) async {
    _setPlaylist(sounds);
    _currentIndex = sounds.indexWhere((s) => s.id == file.id);
    await _player.setAudioSource(_playlist[_currentIndex]);
    _player.play();
    notifyListeners();
  }
  
  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future changeMode(LoopMode mode) async {
    _player.setLoopMode(cycleModes[
      (cycleModes.indexOf(mode) + 1) %
          cycleModes.length]);
  }
  Future<void> stop() async {

    _player.stop();
  } 
  Future<void> seek(Duration position) => _player.seek(position);
  
  Future seekToNext() async {
    if (_currentIndex + 1 == _sounds.length) return;
    _currentIndex += 1;
    _player.stop();
    await _player.setAudioSource(_playlist[_currentIndex]);
    _player.play();
    notifyListeners();
  }

  Future seekToPrevious() async {
    if (_currentIndex == 0) return;
    _currentIndex -= 1;
    _player.stop();
    await _player.setAudioSource(_playlist[_currentIndex]);
    _player.play();
    notifyListeners();
  }
  
  Future<void> setVolume(double volume) => _player.setVolume(volume);
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  
  @override
  void dispose(){
    _player.dispose();
    super.dispose();
  } 
}