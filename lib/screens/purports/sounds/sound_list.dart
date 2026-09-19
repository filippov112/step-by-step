import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:chaos_control/screens/purports/sounds/sound_add_button.dart';
import 'package:chaos_control/screens/purports/sounds/sound_tile.dart';
import 'package:chaos_control/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoundList extends StatelessWidget {
  const SoundList({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = context.select<PurportSoundsModel, List<PurSound>>(
      (m) => m.sounds,
    );
    final isSelectionMode = context.select<PurportSoundsModel, bool>(
      (m) => m.isSelectionMode,
    );
    final isLoading = context.select<PurportSoundsModel, bool>((m) => m.isLoading);

    final listWidget = Container(
      padding: EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: sounds.length,
        itemBuilder: (context, index) => SoundTile(sound: sounds[index])
      ),
    );

    final addButton = isSelectionMode
        ? null
        : const Positioned(
            bottom: 20,
            right: 20,
            child: SoundAddButton()
          );
    
    final loadingScreen = const CustomLoadingScreen();

    return Expanded(child: isLoading ? loadingScreen : Stack(children: [listWidget, ?addButton]));
  }
}
