import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/services/audio/audio_player.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class SoundPlayer extends StatelessWidget {
  const SoundPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = context.read<AudioPlayerService>();
    final currentSound = context.select<AudioPlayerService,PurSound?>((m) => m.current);
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final disabledColor = Theme.of(context).disabledColor;

    // Прогресс-бар
    final progressBar = StreamBuilder<Duration>(
      stream: playerService.player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final total = playerService.player.duration ?? Duration.zero;

        return Slider(
          value: total.inSeconds > 0
              ? position.inSeconds.clamp(0, total.inSeconds).toDouble()
              : 0,
          max: total.inSeconds.toDouble(),
          onChanged: (value) {
            playerService.seek(Duration(seconds: value.toInt()));
          },
        );
      },
    );

    // Предыдущий трек
    final leftButton = IconButton(
      icon: Icon(Icons.skip_previous),
      onPressed: () => playerService.seekToPrevious(),
    );

    // Играть трек / Пауза
    final playButton = StreamBuilder<PlayerState>(
      stream: playerService.player.playerStateStream,
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
          padding: const EdgeInsets.all(0),
          icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          onPressed: playing ? playerService.pause : playerService.resume,
        );
      },
    );

    // Следующий трек
    final rightButton = IconButton(
      icon: Icon(Icons.skip_next),
      onPressed: () => playerService.seekToNext(),
    );

    // Режим повтора
    final repeatButton = StreamBuilder<LoopMode>(
      stream: playerService.player.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        final icons = [
          Icon(Icons.repeat, color: disabledColor),
          Icon(Icons.repeat),
          Icon(Icons.repeat_one),
        ];
        final index = playerService.cycleModes.indexOf(loopMode);
        return IconButton(
          icon: icons[index],
          onPressed: () {
            playerService.changeMode(loopMode);
          },
        );
      },
    );

    return Container(
      decoration: BoxDecoration(color: cardColor),
      padding: const EdgeInsetsGeometry.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(color: dividerColor),
            padding: const EdgeInsetsGeometry.all(4),
            child: CustomText(
              currentSound == null
                  ? ''
                  : currentSound!.artist == null ||
                        currentSound!.artist!.isEmpty
                  ? (currentSound?.title ?? '')
                  : '${currentSound!.artist} - ${currentSound!.title}',
              size: 12,
            ),
          ),

          progressBar,

          // Кнопки управления
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [leftButton, playButton, rightButton, repeatButton],
          ),
        ],
      ),
    );
  }
}
