import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/attempt_form.dart';
import 'package:chaos_control/screens/walls/detail/widgets/attempt_tile.dart';
import 'package:chaos_control/screens/walls/detail/widgets/attempts_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailAttemptTab extends StatelessWidget {
  const WallDetailAttemptTab({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallDetailModel>();
    final attempts = context.select<WallDetailModel, List<Attempt>>(
      (m) => m.attempts,
    );


    final listAttempts = Expanded(
          child: Container(
            padding: EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: attempts.length,
              itemBuilder: (context, index) {
                return WallDetailAttemptTile(attempt: attempts[index]);
              },
            ),
          ),
        );

    return Column(
      children: [
        const WallDetailAttemptsAppbar(),
        listAttempts,
        const WallDetailAttemptForm()
      ],
    );
  }
}
