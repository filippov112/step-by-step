import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  
  AudioPlayer get player => _player;
  
  Future<void> playFile(String path) async {
    await _player.setFilePath(path);
    _player.play();
  }
  
  // Future<void> pause() => _player.pause();
  // Future<void> resume() => _player.play();
  // Future<void> stop() => _player.stop();
  // Future<void> seek(Duration position) => _player.seek(position);
  
  // Future<void> setVolume(double volume) => _player.setVolume(volume);
  // Future<void> setSpeed(double speed) => _player.setSpeed(speed);
  
  void dispose() => _player.dispose();
}