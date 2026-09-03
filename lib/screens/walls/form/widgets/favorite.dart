import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallFormFavorite extends StatelessWidget {

  const WallFormFavorite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final favorite = context.select<WallFormModel,bool>((m) => m.favorite);
    final setFavorite = context.read<WallFormModel>().setFavorite;

    return CustomCheckbox(
      label: 'Добавить в избранное',
      initValue: favorite,
      setValue: setFavorite,
    );
  }
}