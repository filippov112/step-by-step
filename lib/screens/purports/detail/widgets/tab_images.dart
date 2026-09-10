import 'package:chaos_control/screens/purports/images/images_appbar.dart';
import 'package:chaos_control/screens/purports/images/images_list.dart';
import 'package:flutter/material.dart';

class PurportDetailTabImages extends StatelessWidget {
  const PurportDetailTabImages({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const ImagesAppbar(),
        const ImagesList(),
      ],
    );
  }
}
