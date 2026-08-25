import 'package:flutter/material.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/screens/home/home_model.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:chaos_control/widgets/form/singleline_input.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';
import 'user_form_model.dart';

class UserFormScreen extends StatefulWidget {
  final bool isEdit;
  const UserFormScreen({super.key, this.isEdit = false});
  @override
  State<StatefulWidget> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  UserFormModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read<UserFormModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model?.loadData(widget.isEdit);
      nameController.text = model?.newUser?.name ?? '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future _saveUser(BuildContext context) async {
    final form = formKey.currentState;
    if (form == null || !form.validate()) return;

    String? error = await model?.saveUser();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    } else {
      if (context.mounted) {
        if (widget.isEdit) {
          Navigator.pop(context);
        } else {
          await context.read<HomeModel>().loadUser();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = context.select<UserFormModel, CustomImageData?>(
      (model) => model.newUser?.icon,
    );
    final dateBirth = context.select<UserFormModel, DateTime>(
      (model) => model.newUser?.dateBirth ?? DateTime(2000),
    );
    final setIcon = context.read<UserFormModel>().setIcon;
    final setName = context.read<UserFormModel>().setName;

    return EntityScreen(
      title: 'Пользователь',
      formKey: formKey,
      saveCallback: () => _saveUser(context),
      children: [
        // Аватар
        Center(
          child: CustomIconPicker(
            selectedIcon: iconPath,
            setIcon: setIcon,
            size: 100,
            radius: const BorderRadius.all(Radius.circular(50)),
            borderWidth: 3,
          ),
        ),
        const SizedBox(height: 12),

        // Имя
        SinglelineInput(
          header: 'Имя',
          controller: nameController,
          requiredErrorText: 'Введите имя',
          setText: setName,
        ),
        const SizedBox(height: 12),

        // Дата рождения
        CustomDateTime(
          callback: (v) => model?.setDateBirth(v),
          value: dateBirth,
          dateOnly: true,
          title: 'Дата рождения',
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
