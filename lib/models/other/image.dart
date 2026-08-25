import 'dart:convert';
import 'package:flutter/material.dart';

class CustomImageData {

  static const cIconCode = "code";
  static const cImagePath = "path";
  static const cColor = "color";
  static const cIconFamily = "family";

  int? iconCode; // Код иконки
  String? imagePath; // Путь к изображению
  Color? color; // Цвет
  String? iconFamily; // Семейство иконок

  bool get isIcon => iconCode != null && iconFamily != null;
  bool get isImage => imagePath != null && imagePath!.isNotEmpty;
  // ignore: non_const_argument_for_const_parameter
  IconData? icon() => isIcon ? IconData(iconCode!, fontFamily: iconFamily) : null;

  CustomImageData({
    this.iconCode,
    this.iconFamily,
    this.imagePath,
    this.color,
  });

  factory CustomImageData.fromIcon(
    IconData icon,
  ) {
    return CustomImageData(
      iconCode: icon.codePoint,
      iconFamily: icon.fontFamily
    );
  }

  factory CustomImageData.fromImage(
    String path,
  ) {
    return CustomImageData(
      imagePath: path,
    );
  }


  Map<String, Object?> toMap() {
    return {
      cIconCode: iconCode,
      cIconFamily: iconFamily,
      cImagePath: imagePath,
      cColor: color?.toARGB32(),
    };
  }

  CustomImageData.fromMap(Map map) {
    iconCode = map[cIconCode];
    iconFamily = map[cIconFamily];
    imagePath = map[cImagePath];
    color = map[cColor] != null ? Color(map[cColor]) : null;
  }

  String toJson() => jsonEncode(toMap());
  factory CustomImageData.fromJson(String json) => CustomImageData.fromMap(jsonDecode(json));
}