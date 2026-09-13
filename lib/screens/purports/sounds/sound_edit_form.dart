import 'dart:io';
import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class SoundEditForm extends StatefulWidget {
  final PurSound sound;

  const SoundEditForm({super.key, required this.sound});

  @override
  State<SoundEditForm> createState() => _SoundEditFormState();
}

class _SoundEditFormState extends State<SoundEditForm> {
  final _formKey = GlobalKey<FormState>();
  late PurportSoundsModel model;

  String title = '';
  String artist = '';


  @override
  void initState() {
    super.initState();
    model = context.read<PurportSoundsModel>();
    title = widget.sound.title;
    artist = widget.sound.artist ?? '';
  }

  @override
  Widget build(BuildContext context) {

    return EntityScreen(
      title: '',
      saveCallback: () => _save(),
      deleteCallback: () => _delete(),
      formKey: _formKey,
      children: [
        // Иконка
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).dividerColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(12))
          ),
          child: Image.file(File(widget.sound.path), height: 200),
        ),
        
        const SizedBox(height: 12),

        // Название
        CustomTextInput(
          header: 'Название',
          initialValue: title,
          icon: Icons.title,
          setText: (v) {title = v ?? '';},
        ),
        const SizedBox(height: 12),

        // Артист
        CustomTextInput(
          header: 'Артист',
          initialValue: artist,
          action: null,
          icon: Icons.person,
          setText: (v) {artist = v ?? '';},
          lines:5
        ),
      ],
    );
  }

  Future _save() async {
    widget.sound.title = title;
    widget.sound.artist = artist;
    await model.update(widget.sound);
    if (mounted) {
      Navigator.pop(context, widget.sound);
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _delete() async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await model.delete(widget.sound.id);
      _close();
    }
  }
}
