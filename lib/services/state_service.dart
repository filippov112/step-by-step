import 'package:life_game/models/user.dart';

class StateService {
  static User? profile;

  static final UserRepository _userProvider = UserRepository();
  
  static Future initState() async {
    profile = await _userProvider.get(); 
    if (profile == null) return;
  }
}