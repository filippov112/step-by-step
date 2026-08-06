import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:life_game/models/user_profile.dart';
import 'package:life_game/screens/home.dart';
import 'package:life_game/screens/profile/create/create_profile_vm.dart';
import 'dart:io';

import 'package:life_game/services/file_storage_service.dart';
import 'package:life_game/services/state_service.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  CreateProfileVM? vm;
  _CreateProfileScreenState() {
    vm = CreateProfileVM();
  }
  final formKey = GlobalKey<FormState>();
  bool _saving = false;

  String _name = "";
  File? _selectedImage;
  String? _savedAvatarPath;
  final _fileStorage = FileStorageService();
  DateTime _dateBirth = DateTime(2000);
  

  Future<DateTime> _selectDateBirth() async {
    // 1. Выбор даты
    final date = await showDatePicker(
      context: context,
      initialDate: _dateBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime(2026),
    );
    if (date == null || !mounted) {
      return _dateBirth;
    }
    setState(() {
      _dateBirth = DateTime(
        date.year,
        date.month,
        date.day,
      );
    });
    return _dateBirth;
  }
  
  Future<void> _saveProfile() async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      
      setState(() => _saving = true);
      form.save();

      try {
        String? finalAvatarPath;
      
        if (_selectedImage != null) {
          if (_savedAvatarPath != null) {
            await _fileStorage.deleteOldAvatar(_savedAvatarPath);
          }
          finalAvatarPath = await _fileStorage.saveAvatar(_selectedImage!);
        } else {
          finalAvatarPath = _savedAvatarPath;
        }
        
        final profile = UserProfileModel(
          name: _name,
          icon: finalAvatarPath,
          dateBirth: _dateBirth
        );
        await vm!.saveProfile(profile);
        StateService.initState();
        if (!mounted) return;
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
      } 
      catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _saving = false);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500, // Оптимизация размера
      maxHeight: 500,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новый профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Виджет для выбора аватара
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_savedAvatarPath != null 
                          ? FileImage(File(_savedAvatarPath!))
                          : null),
                  child: (_selectedImage == null && _savedAvatarPath == null)
                      ? const Icon(Icons.add_photo_alternate, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              
              // Поле ввода имени
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onSaved: (val) => _name = val ?? "",
                  decoration: InputDecoration(labelText: "Имя"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Обязательное поле';
                    if (value.length < 3) return 'Минимум 3 символа';
                    return null; // ошибки нет
                  },
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: _selectDateBirth,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Дедлайн'),
                      child: Text(DateFormat("dd.MM.yyyy").format(_dateBirth)),
                    ),
                  )
                ),
              
              const SizedBox(height: 20),
              
              // Кнопка сохранения
              ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                child: _saving
                    ? const CircularProgressIndicator()
                    : const Text('Сохранить профиль'),
              ),
            ],
          ),
        )
      ),
    );
  }
}