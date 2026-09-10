import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/image_view.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageTile extends StatelessWidget {
  final PurImage image;
  const ImageTile({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportImagesModel>();
    final isSelectionMode = context.select<PurportImagesModel, bool>(
      (m) => m.isSelectionMode,
    );
    final selectedImages = context.select<PurportImagesModel, Set<String>>(
      (m) => m.selectedIds,
    );

    final dividerColor = Theme.of(context).dividerColor;

    final selectCheckbox = isSelectionMode
        ? Checkbox(
            value: selectedImages.contains(image.id),
            onChanged: (_) => model.toggleSelect(image.id),
          )
        : null;

    final imageWidget = CustomImageIcon(
      CustomImageData.fromImage(image.path),
      radius: const BorderRadius.all(Radius.circular(0)),
      width: double.infinity,
      height: double.infinity,
    );

    final cardWidget = Stack(
      children: [
        imageWidget,
        if (selectCheckbox != null)
          Positioned(top: 8, right: 8, child: selectCheckbox),
      ],
    );

    void select() {
      model.toggleSelect(image.id);
    }

    void open() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageView(image: image)),
      );
    }

    return CustomTile(
      padding: 8,
      borderColor: dividerColor,
      longPressCallback: select,
      callback: isSelectionMode ? select : open,
      child: cardWidget,
    );
  }
}
