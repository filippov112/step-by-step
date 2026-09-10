import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/image_add_button.dart';
import 'package:chaos_control/screens/purports/images/image_tile.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagesList extends StatelessWidget {
  const ImagesList({super.key});

  void add() {
    // todo
  }

  @override
  Widget build(BuildContext context) {
    final images = context.select<PurportImagesModel, List<PurImage>>(
      (m) => m.images,
    );
    // final images = [
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    //   "C:\\Users\\ilya\\Documents/icons/icon_01a08b8c-a92f-790c-bf8f-74cdfae4d6fa.jpg",
    // ];
    final isSelectionMode = context.select<PurportImagesModel, bool>(
      (m) => m.isSelectionMode,
    );

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

    return Expanded(child: Stack(children: [listWidget, ?addButton]));
  }
}
