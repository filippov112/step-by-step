import 'package:chaos_control/services/audio/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class SoundPlayer extends StatelessWidget {

  const SoundPlayer({ super.key });

  @override
  Widget build(BuildContext context) {
    final player = context.read()<AudioPlayerService>();

    return Column(
      children: [
        
        // Прогресс-бар
        StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final total = player.duration ?? Duration.zero;
            
            return Slider(
              value: total.inSeconds > 0
                  ? position.inSeconds.clamp(0, total.inSeconds).toDouble()
                  : 0,
              max: total.inSeconds.toDouble(),
              onChanged: (value) {
                player.seek(Duration(seconds: value.toInt()));
              },
            );
          },
        ),
        
        // Кнопки управления
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.skip_previous),
              onPressed: () => player.seekToPrevious(),
            ),
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                final processingState = state?.processingState;
                final playing = state?.playing ?? false;
                
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(),
                  );
                }
                
                return IconButton(
                  iconSize: 48,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: playing ? player.pause : player.play,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.skip_next),
              onPressed: () => player.seekToNext(),
            ),
          ],
        ),
      ],
    );
  }
}