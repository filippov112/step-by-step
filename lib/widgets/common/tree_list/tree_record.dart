// Древовидная модель
import 'dart:ui';

import 'package:chaos_control/models/other/image.dart';

class TreeRecord<T> {

  final String address;
  final T? object;
  final bool isFolder;
  final String? name;
  final List<TreeRecord<T>>? children;
  final Color? color;
  final CustomImageData? customIconData;


  TreeRecord({
    required this.address,
    this.object,
    this.isFolder = false,
    this.name,
    this.children,
    this.color,
    this.customIconData,
  });
}
