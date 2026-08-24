import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/screens/skills/form/skill_form_model.dart';
import 'package:provider/provider.dart';

class SkillFormRang extends StatelessWidget {
  const SkillFormRang({super.key});

  @override
  Widget build(BuildContext context) {
    final rang = context.select<SkillFormModel, SkillRang>(
      (model) => model.rang,
    );
    final setRang = context.read<SkillFormModel>().setRang;

    return DropdownButtonFormField<SkillRang>(
      decoration: const InputDecoration(
        labelText: 'Ранг',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.arrow_upward),
      ),
      initialValue: rang,
      items: SkillRang.values.map((rang) {
        return DropdownMenuItem(value: rang, child: Text(rang.name));
      }).toList(),
      onChanged: (value) {
        if (value != null) setRang(value);
      },
    );
  }
}
