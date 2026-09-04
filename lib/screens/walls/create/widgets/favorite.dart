import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallCreateFavorite extends StatelessWidget {

  const WallCreateFavorite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final favorite = context.select<WallEditModel,bool>((m) => m.favorite);
    final setFavorite = context.read<WallEditModel>().setFavorite;

    return CustomCheckbox(
      label: 'Добавить в избранное',
      initValue: favorite,
      setValue: setFavorite,
    );
  }
}