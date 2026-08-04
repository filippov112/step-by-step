import 'package:flutter/material.dart';
import 'package:life_game/models/user_profile.dart';

class CreateProfileVM extends ChangeNotifier {
  late UserProfileProvider provider = UserProfileProvider();

  CreateProfileVM();

  Future saveProfile(UserProfileModel newProfile) async {
    await provider.insert(newProfile);
  }
}