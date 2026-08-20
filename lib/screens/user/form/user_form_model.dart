import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/services/file_storage_service.dart';

class UserFormModel extends ChangeNotifier {
  late UserRepository provider = UserRepository();
  final fileStorage = FileStorageService();
  UserFormModel();

  
  final User newUser = User(dateBirth: DateTime(2000));

  Future selectAvatar(String selectedImagePath) async {
    var file = File(selectedImagePath);
    if (newUser.icon != null) {
      await fileStorage.deleteOldFile(newUser.icon);
    }
    newUser.icon = await fileStorage.saveIcon(file);
    notifyListeners();
  }


  Future saveProfile() async {
    try {
      await provider.insert(newUser);
    } 
    catch (e) {
      return e.toString();
    }
  }


  Future selectDateBirth(DateTime selectedDate) async {
    newUser.dateBirth = selectedDate;
    notifyListeners();
  }

  Future selectName(String name) async {
    newUser.name = name;
    notifyListeners();
  }
}