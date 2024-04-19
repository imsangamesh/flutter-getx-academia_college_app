import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/auth/signin_screen.dart';

class AppData {
  AppData._();
  static final _box = GetStorage();

  /// -------------------------------------------- `GETTERS`

  static String get token => _box.read(PrefKeys.token);
  static Role get role => Role.fromStr(_box.read(PrefKeys.role));

  /// -------------------------------------------- `METHODS`

  static Map<String, dynamic> fetchData() {
    final userData = _box.read<Map<String, dynamic>>(PrefKeys.userData);
    if (userData == null) Get.offAll(() => SigninScreen());
    return userData ?? {};
  }

  static Future<void> storeRole(Role role) async {
    _box.write(PrefKeys.role, role.str);
  }

  /// -------------------------------------------- `USER DATA`
  static Future<void> storeUserData(Role role) async {
    Map<String, dynamic> userData = {};

    if (role == Role.student) {
      userData = await MyHelper.fetchStudentMap();
    } else if (role == Role.faculty) {
      userData = await MyHelper.fetchFacultyMap();
    } else if (role == Role.admin) {
      userData = await MyHelper.fetchAdminMap();
    }

    await _box.write(PrefKeys.userData, userData);
    log(' - - - - - - USER DATA set-up Complete | $role - - - - - - ');
  }
}
