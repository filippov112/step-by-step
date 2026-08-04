import 'package:life_game/models/user_profile.dart';

class StateService {
  static UserProfileModel? profile;

  static final UserProfileProvider _userProvider = UserProfileProvider();
  
  static Future initState() async {
    profile = await _userProvider.get(); 
    if (profile == null) return;
  }
}