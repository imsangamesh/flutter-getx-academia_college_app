import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newbie/core/constants/my_pref_keys.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/models/user_model.dart';
import 'package:newbie/modules/auth/signin_screen.dart';
import 'package:newbie/modules/home/home_screen.dart';

import '../../core/constants/my_constants.dart';
import '../../core/themes/theme_controller.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';

class AuthController extends GetxController {
  //
  final _box = GetStorage();

  bool get isUserPresent => _box.read<bool>(MyPrefKeys.userStatus) ?? false;

  signInWithGoogle(String roleStr) async {
    try {
      /// `Trigger` the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /// get the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      log('----------------------------------------------- 1');

      if (!await checkForUsersValidity(roleStr, googleUser.email)) return;

      /// create a new `credential`
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Utils.progressIndctr(label: 'loading...');
      log('----------------------------------------------- 2');

      /// once signed-in extract `UserCredentials`
      final userCredential = await auth.signInWithCredential(credential);

      /// if user `couldn't` login
      if (userCredential.user == null) {
        Utils.normalDialog();
        return;
      }

      log('----------------------------------------------- 3');
      _box.write(MyPrefKeys.userStatus, true);

      MyPrefKeys.storeRole(roleStr);

      final themeController = Get.put(ThemeController());
      final homeController = Get.put(HomeController(), permanent: true);
      final profileCntrlr = Get.put(ProfileController());

      themeController.configureTheme();
      homeController.resetInterests();
      profileCntrlr.setUpProfilePage();
      profileCntrlr.configureGreetingText();

      Get.offAll(() => const HomeScreen());
      Utils.showSnackBar('Login Successful!', status: true);
      //
      log('----------------------------------------------- 4');
    } on FirebaseAuthException catch (e) {
      Get.back();
      Utils.showAlert('Firebase Err', e.message.toString());
    } catch (e) {
      Get.back();
      if (e.toString() == 'Null check operator used on a null value') {
        Utils.showSnackBar('Please select your email to proceed');
      } else {
        Utils.showAlert('Oops', e.toString());
      }
    }
  }

  Future<bool> checkForUsersValidity(String roleStr, String userEmail) async {
    Role role = MyHelper.stringToRole(roleStr);

    if (role == Role.student) {
      final validStudentsData = await fire.collection('students').get();

      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Utils.showAlert(
          'Oops!',
          'selected email is not authorised for "Student" role... please check your email & try again.',
        );
        return false;
      }
    } else if (role == Role.faculty) {
      final validStudentsData = await fire.collection('faculties').get();

      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Utils.showAlert(
          'Oops!',
          'selected email is not authorised for "Faculty" role... please check your email & try again.',
        );
        return false;
      }
    } else if (role == Role.admin) {
      final validStudentsData = await fire.collection('admins').get();

      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Utils.showAlert(
          'Oops!',
          'selected email is not authorised for "Admin" role... please check your email & try again.',
        );
        return false;
      }
    }
    return true;
  }

  logout() async {
    try {
      //
      log('=================== ERASED DATA & Logged out ==================');
      await GoogleSignIn().signOut();
      _box.erase();
      _box.write(MyPrefKeys.userStatus, false);
      Get.offAll(() => SigninScreen());
      //
    } catch (e) {
      log('=================== couldn\'t logout ==================');
    }
  }
}
