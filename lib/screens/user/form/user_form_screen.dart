import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/widgets/dialogs/custom_icon_picker.dart';
import 'package:life_game/widgets/dialogs/select_date_only.dart';
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
    model?.setName(nameController.text);

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

  Future _selectDateBirth(BuildContext context, DateTime currentDate) async {
    var selectedDate = await selectDateOnly(context, currentDate);
    model?.setDateBirth(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = context.select<UserFormModel, String?>(
      (model) => model.newUser?.icon,
    );
    final dateBirth = context.select<UserFormModel, DateTime>(
      (model) => model.newUser?.dateBirth ?? DateTime(2000),
    );
    final setIcon = context.read<UserFormModel>().setIcon;
    final name = context.select<UserFormModel, String>(
      (model) => model.newUser?.name ?? '',
    );
    nameController.text = name;

    var avatarWidget = CustomIconPicker(
      iconPath: iconPath,
      setIcon: setIcon,
      size: 100,
      radius: const BorderRadius.all(Radius.circular(50)),
      borderWidth: 3,
    );

    var nameWidget = TextFormField(
      controller: nameController,
      decoration: InputDecoration(labelText: "Имя"),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Обязательное поле';
        if (value.length < 3) return 'Минимум 3 символа';
        return null; // ошибки нет
      },
    );

    var dateBirthWidget = InkWell(
      onTap: () => _selectDateBirth(context, dateBirth),
      child: InputDecorator(
        decoration: InputDecoration(labelText: 'Дедлайн'),
        child: Text(DateFormat("dd.MM.yyyy").format(dateBirth)),
      ),
    );

    var formWidget = Form(
      key: formKey,
      child: Column(
        children: [
          // Виджет для выбора аватара
          avatarWidget,
          const SizedBox(height: 20),
          // Поле ввода имени
          Padding(padding: const EdgeInsets.all(10.0), child: nameWidget),
          Padding(padding: const EdgeInsets.all(10.0), child: dateBirthWidget),
          const SizedBox(height: 20),
          // Кнопка сохранения
          ElevatedButton(
            onPressed: () => _saveUser(context),
            child: const Text('Сохранить профиль'),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Создание пользователя')),
      body: Padding(padding: const EdgeInsets.all(16.0), child: formWidget),
    );
  }
}
