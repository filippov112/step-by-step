import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetEditFavorite extends StatelessWidget {

  const TargetEditFavorite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final favorite = context.select<TargetEditModel,bool>((m) => m.favorite);
    final setFavorite = context.read<TargetEditModel>().setFavorite;

    return CustomCheckbox(
      label: 'Добавить в избранное',
      initValue: favorite,
      setValue: setFavorite,
    );
  }
}