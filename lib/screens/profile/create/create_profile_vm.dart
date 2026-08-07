import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';

class CreateProfileVM extends ChangeNotifier {
  late UserRepository provider = UserRepository();

  CreateProfileVM();

  Future saveProfile(User newProfile) async {
    await provider.insert(newProfile);
  }
}