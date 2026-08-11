import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/widgets/dialogs/select_date_only.dart';
import 'package:provider/provider.dart';
import 'user_form_model.dart';
import 'dart:io';


class UserFormScreen extends StatelessWidget {
  const UserFormScreen({super.key});

  Future selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500, // Оптимизация размера
      maxHeight: 500,
      imageQuality: 85,
    );
    
    if (pickedFile != null && context.mounted) {
      await context.read<UserFormModel>().selectAvatar(pickedFile.path);
    }
  }
  

  Future saveUser(BuildContext context) async {
    String? error = await context.read<UserFormModel>().saveProfile();
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $error'),
        ),
      );
    }
    else {
      if (context.mounted) await context.read<HomeModel>().loadUser();
    }
  }
  

  Future _selectDateBirth(BuildContext context) async {
    var model = context.read<UserFormModel>();
    var selectedDate = await selectDateOnly(context, model.newUser.dateBirth);
    model.selectDateBirth(selectedDate);
  }

  @override
  Widget build(BuildContext context) {

    var formKey = context.select<UserFormModel,GlobalKey<FormState>>((model) => model.formKey);
    var iconPath = context.select<UserFormModel,String?>((model) => model.newUser.icon);
    var dateBirth = context.select<UserFormModel,DateTime>((model) => model.newUser.dateBirth);
 
    var avatarWidget = GestureDetector(
      onTap: () => selectImage(context),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: iconPath != null ? FileImage(File(iconPath)) : null,
        child: iconPath == null ? const Icon(Icons.add_photo_alternate, size: 40) : null,
      ),
    );

    var nameWidget = TextFormField(
      onSaved: (val) => context.read<UserFormModel>().selectName(val ?? ""),
      decoration: InputDecoration(labelText: "Имя"),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Обязательное поле';
        if (value.length < 3) return 'Минимум 3 символа';
        return null; // ошибки нет
      },
    );

    var dateBirthWidget = InkWell(
      onTap: () => _selectDateBirth(context),
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: nameWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: dateBirthWidget,
          ),
          const SizedBox(height: 20),
          // Кнопка сохранения
          ElevatedButton(
            onPressed: () => saveUser(context),
            child: const Text('Сохранить профиль'),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание пользователя')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: formWidget,
      ),
    );
  }
}