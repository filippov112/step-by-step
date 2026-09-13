import 'package:chaos_control/screens/purports/sounds/sound_appbar.dart';
import 'package:chaos_control/screens/purports/sounds/sound_list.dart';
import 'package:chaos_control/screens/purports/sounds/sound_player.dart';
import 'package:flutter/material.dart';

class PurportDetailTabSounds extends StatelessWidget {
  const PurportDetailTabSounds({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SoundAppbar(),
        const SoundList(),
        const SoundPlayer()
      ],
    );
  }
}
