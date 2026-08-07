import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository userRepository = UserRepository();

  User? user;

  Future loadUser() async {
    user = await userRepository.get();
    notifyListeners();
  }
}