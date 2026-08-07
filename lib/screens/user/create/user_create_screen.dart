import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_game/screens/home/home_model.dart';
import 'package:life_game/screens/home/home_screen.dart';
import 'package:life_game/widgets/select_date.dart';
import 'package:provider/provider.dart';
import 'user_create_model.dart';
import 'dart:io';


class UserCreateScreen extends StatefulWidget {
  const UserCreateScreen({super.key});
  @override
  State<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  
  Future selectImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500, // Оптимизация размера
      maxHeight: 500,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      await context.read<UserCreateModel>().selectAvatar(pickedFile.path);
    }
  }
  

  Future saveUser(BuildContext context) async {
    String? error = await context.read<UserCreateModel>().saveProfile();
    
    if (!mounted) return;

    if (error != null) {
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $error'),
          ),
        );
    }
    else {
      await context.read<HomeModel>().loadUser();
    }
  }
  

  Future _selectDateBirth(BuildContext context) async {
    var model = context.read<UserCreateModel>();
    var selectedDate = await selectDateBirth(context, model.newUser.dateBirth);
    model.selectDateBirth(selectedDate);
  }

  @override
  Widget build(BuildContext context) {

    var formKey = context.select<UserCreateModel,GlobalKey<FormState>>((model) => model.formKey);
    var iconPath = context.select<UserCreateModel,String?>((model) => model.newUser.icon);
    var dateBirth = context.select<UserCreateModel,DateTime>((model) => model.newUser.dateBirth);
 
    var avatarWidget = GestureDetector(
      onTap: () => selectImage(context),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: iconPath != null ? FileImage(File(iconPath)) : null,
        child: iconPath == null ? const Icon(Icons.add_photo_alternate, size: 40) : null,
      ),
    );

    var nameWidget = TextFormField(
      onSaved: (val) => context.read<UserCreateModel>().selectName(val ?? ""),
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