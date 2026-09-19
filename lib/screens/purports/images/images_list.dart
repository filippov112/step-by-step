import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/image_add_button.dart';
import 'package:chaos_control/screens/purports/images/image_tile.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagesList extends StatelessWidget {
  const ImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.select<PurportImagesModel, List<PurImage>>(
      (m) => m.images,
    );
    final isSelectionMode = context.select<PurportImagesModel, bool>(
      (m) => m.isSelectionMode,
    );
    final isLoading = context.select<PurportImagesModel, bool>((m) => m.isLoading);

    final listWidget = Container(
      padding: EdgeInsets.all(12),
      child: GridView.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        children: images.map((i) => ImageTile(image: i)).toList(),
      ),
    );

    final addButton = isSelectionMode
        ? null
        : const Positioned(
            bottom: 20,
            right: 20,
            child: ImageAddButton()
          );

    final loadingScreen = const CustomLoadingScreen();

    return Expanded(child: isLoading ? loadingScreen : Stack(children: [listWidget, ?addButton]));
  }
}
