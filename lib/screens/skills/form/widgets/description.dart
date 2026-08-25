import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/skill_rang.dart';
import 'package:chaos_control/screens/skills/form/skill_form_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class SkillFormDescriptions extends StatelessWidget {
  final Map<SkillRang, TextEditingController> descControllers;
  const SkillFormDescriptions({super.key, required this.descControllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomText(
          'Описания для рангов',
          size: 18,
          weight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ListView(
            children: [
              ...SkillRang.values.map(
                (rang) => SkillFormRangDesc(
                  rang: rang,
                  controller: descControllers[rang],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SkillFormRangDesc extends StatelessWidget {
  final SkillRang rang;
  final TextEditingController? controller;
  const SkillFormRangDesc({
    super.key,
    required this.rang,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final setDescription = context.read<SkillFormModel>().setDescription;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'Описание для ранга ${rang.name}',
          border: const OutlineInputBorder(),
          prefixIcon: Container(
            width: 40,
            margin: const EdgeInsets.fromLTRB(12, 0, 8, 0),
            decoration: BoxDecoration(
              color: rang.color.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                rang.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rang.color,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        maxLines: 2,
        onChanged: (val) {
          setDescription(rang, val);
        },
      ),
    );
  }
}
