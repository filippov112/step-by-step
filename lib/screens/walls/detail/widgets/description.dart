import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:provider/provider.dart';

class WallDetailDesc extends StatelessWidget {
  const WallDetailDesc({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<WallDetailModel, String>(
      (model) => model.wall.description,
    );

    return Text(description, style: Theme.of(context).textTheme.bodyLarge);
  }
}
