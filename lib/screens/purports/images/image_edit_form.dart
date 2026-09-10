import 'dart:io';
import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ImageEditForm extends StatefulWidget {
  final PurImage image;

  const ImageEditForm({super.key, required this.image});

  @override
  State<ImageEditForm> createState() => _ImageEditFormState();
}

class _ImageEditFormState extends State<ImageEditForm> {
  final _formKey = GlobalKey<FormState>();
  late PurportImagesModel model;

  String name = '';
  String desc = '';


  @override
  void initState() {
    super.initState();
    model = context.read<PurportImagesModel>();
    name = widget.image.name;
    desc = widget.image.desc;
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
          child: Image.file(File(widget.image.path), height: 200),
        ),
        
        const SizedBox(height: 12),

        // Название
        CustomTextInput(
          header: 'Название',
          initialValue: name,
          icon: Icons.title,
          setText: (v) {name = v ?? '';},
        ),
        const SizedBox(height: 12),

        // Описание
        CustomTextInput(
          header: 'Описание',
          initialValue: desc,
          action: null,
          icon: Icons.description,
          setText: (v) {desc = v ?? '';},
          lines:5
        ),
      ],
    );
  }

  Future _save() async {
    widget.image.name = name;
    widget.image.desc = desc;
    await model.updateImage(widget.image);
    if (mounted) {
      Navigator.pop(context, widget.image);
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _delete() async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await model.deleteImage(widget.image.id);
      _close();
    }
  }
}
