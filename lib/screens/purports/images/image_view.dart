import 'dart:io';

import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/image_edit_form.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageView extends StatefulWidget {
  final PurImage image;
  const ImageView({super.key, required this.image});

  @override
  State<StatefulWidget> createState() => ImageViewState();
}

class ImageViewState extends State<ImageView> {
  late PurportImagesModel model;
  late PurImage image;

  bool descVisiblity = true;

  @override
  void initState() {
    super.initState();
    model = context.read<PurportImagesModel>();
    image = widget.image;
  }

  void _edit() async {
    await Navigator.push<PurImage>(
      context,
      MaterialPageRoute(builder: (context) => ImageEditForm(image: image)),
    ).then((img) async {
      if (context.mounted && img != null) {
        setState(() {
          image = img;
        });
      } else {
        _close();
      }
    });
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _deleteThis() async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await model.deleteImage(image.id);
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final descHeader = SizedBox(
      height: 50,
      child: Row(
        children: [
          CustomText(
            image.name,
            size: 18,
            weight: FontWeight.bold,
            expanded: true,
          ),
          IconButton(
            onPressed: () => setState(() {
              descVisiblity = false;
            }),
            icon: Icon(
              Icons.description,
              color: Theme.of(context).focusColor.withAlpha(100),
            ),
          ),
        ],
      ),
    );

    final descBlock = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).cardColor.withAlpha(150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            descHeader,
            Expanded(
              child: ListView(
                children: [
                  CustomText(
                    image.desc,
                    lines: null,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final showDescButton = Positioned(
      bottom: 20,
      right: 20,
      child: IconButton(
        onPressed: () => setState(() {
          descVisiblity = true;
        }),
        icon: Icon(
          Icons.description,
          color: Theme.of(context).focusColor.withAlpha(100),
        ),
      ),
    );

    return EntityScreen(
      editCallback: _edit,
      deleteCallback: _deleteThis,
      title: image.name,
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 4.0,
              child: Image.file(File(image.path)),
            ),
          ),

          if (image.desc.isNotEmpty && descVisiblity) descBlock,
          if (image.desc.isNotEmpty && !descVisiblity) showDescButton,
        ],
      ),
    );
  }
}
