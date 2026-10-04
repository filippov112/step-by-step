import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/models/other/image.dart';
import 'package:step_by_step/models/profile.dart';
import 'package:step_by_step/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/screens/home/home_model.dart';
import 'package:step_by_step/widgets/form/custom_icon_picker.dart';
import 'package:step_by_step/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';
import 'profile_form_model.dart';

class ProfileFormScreen extends StatefulWidget {
  final Profile? profile;
  const ProfileFormScreen({super.key, this.profile});
  @override
  State<StatefulWidget> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final formKey = GlobalKey<FormState>();
  ProfileFormModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProfileFormModel>();
    model?.loadData(widget.profile);
  }

  Future _saveUser(BuildContext context) async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;

    String? error = await model?.save();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    } else {
      if (context.mounted) {
        if (widget.profile != null) {
          Navigator.pop(context);
        } else {
          await context.read<HomeModel>().loadData();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.select<ProfileFormModel, Profile?>(
      (model) => model.profile,
    );
    final iconData = context.select<ProfileFormModel, CustomImageData?>((m) => m.profile?.icon);
    final model = context.read<ProfileFormModel>();

    // Аватар
    final avatar = Center(
          child: CustomIconPicker(
            selectedIcon: iconData,
            setIcon: model.setIcon,
            size: 100,
            radius: const BorderRadius.all(Radius.circular(50)),
            borderWidth: 3,
          ),
        );

    // Имя
    final nameField = CustomTextInput(
      icon: Icons.title,
      header: 'Имя',
      initialValue: profile?.name,
      requiredErrorText: 'Введите имя',
      setText: model.setName,
    );

    int getChar(Characteristic ch) {
      return profile?.baseChars.map[ch] ?? 0;
    }

    final charFields = Characteristic.values
        .map(
          (ch) => CustomTextInput(
            header: ch.displayName,
            initialValue: getChar(ch).toString(),
            setText: (v) => model.setBaseChar(ch, int.tryParse(v ?? '0') ?? 0),
            icon: ch.icon,
            type: TextInputType.number
          ),
        )
        .toList();

    return EntityScreen(
      title: 'Игрок',
      formKey: formKey,
      saveCallback: () => _saveUser(context),
      children: [
        avatar,
        const SizedBox(height: 12),

        nameField,

        Padding(
          padding: const EdgeInsetsGeometry.only(top: 12),
          child: Row(children: [
          Expanded(child: charFields[0],),
          const SizedBox(width: 12,),
          Expanded(child: charFields[1],),
        ],),),
        Padding(
          padding: const EdgeInsetsGeometry.only(top: 12),
          child: Row(children: [
          Expanded(child: charFields[2],),
          const SizedBox(width: 12,),
          Expanded(child: charFields[3],),
        ],),),
        Padding(
          padding: const EdgeInsetsGeometry.only(top: 12),
          child: Row(children: [
          Expanded(child: charFields[4],),
          const SizedBox(width: 12,),
          Expanded(child: charFields[5],),
        ],),),
      ],
    );
  }
}
