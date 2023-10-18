import 'package:get_storage/get_storage.dart';
import 'package:newbie/core/helpers/my_helper.dart';

import '../../models/user_model.dart';

class MyPrefKeys {
  static final _box = GetStorage();

  static const isDarkMode = 'IS_DARK_MODE';
  static const userStatus = 'IS_USER_PRESENT';
  static const userRole = 'USER_ROLE';
  static const studentKey = 'STUDENT_DATA';

  static const interestsList = 'INTERESTS_SET';
  static const profileUserName = 'PROFILE_USER_NAME';
  static const profileImage = 'PROFILE_IMAGE';
  static const backdropImage = 'BACKGROUND_IMAGE';

  static storeRole(String roleStr) => _box.write(userRole, roleStr);

  static Role fetchRole() => MyHelper.stringToRole(_box.read(userRole));
}
