import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newbie/api/fcm_noti_controller.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/auth/signin_screen.dart';
import 'package:newbie/modules/home/home_screen.dart';

import '../../core/constants/constants.dart';
import '../../core/themes/theme_controller.dart';

class AuthController extends GetxController {
  //
  final _box = GetStorage();

  bool get isUserPresent => _box.read<bool>(PrefKeys.isUser) ?? false;

  signInWithGoogle(Role role) async {
    try {
      /// `Trigger` the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      /// get the `Google Auth` details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      /// Check user's `ROLE` and his `VALIDITY`
      if (!await checkForUserValidity(role, googleUser.email)) return;

      /// create a new `credential` with above googleAuth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Popup.circleLoader(label: 'loading...');

      /// once signed-in extract `UserCredentials`
      final userCredential = await auth.signInWithCredential(credential);

      /// if user `couldn't` login
      if (userCredential.user == null) {
        Popup.general();
        return;
      }

      // --------------------------- SETTING UP USER ---------------------------

      /// `USER`
      await _box.write(PrefKeys.isUser, true); // set user
      await AppData.storeRole(role); // set role
      await AppData.storeUserData(role); // set user data

      /// `THEME`
      final themeController = Get.put(ThemeController());
      themeController.configureTheme();

      /// `NOTIFICATIONS`
      final fcmController = Get.put(FCMNotiController());
      await fcmController.init();

      // -----------------------------------------------------------------------

      Get.offAll(() => HomeScreen());
      Popup.snackbar('Login Successful!', status: true);
      //
    } on FirebaseAuthException catch (e) {
      Get.back();
      Popup.alert('Firebase Error', e.message.toString());
    } catch (e) {
      Get.back();
      if (e.toString() == 'Null check operator used on a null value') {
        Popup.snackbar('Please select your email to proceed!');
      } else {
        Popup.alert('Login Error', e.toString());
      }
      await logout();
    }
  }

  Future<bool> checkForUserValidity(Role role, String userEmail) async {
    if (role == Role.student) {
      /// ----------------------------------------- `STUDENT`
      //
      final validStudentsData = await fire.collection(FireKeys.students).get();
      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Popup.alert(
          'Oops!',
          'Selected email is not authorised for "Student" role. please check your email & try again.',
        );
        return false;
      }
    } else if (role == Role.faculty) {
      /// ----------------------------------------- `FACULTY`
      //
      final validStudentsData = await fire.collection(FireKeys.faculties).get();

      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Popup.alert(
          'Oops!',
          'Selected email is not authorised for "Faculty" role. please check your email & try again.',
        );
        return false;
      }
    } else if (role == Role.admin) {
      /// ----------------------------------------- `ADMIN`
      //
      final validStudentsData = await fire.collection(FireKeys.admins).get();

      final validUsersList =
          validStudentsData.docs.map((e) => e.data()['email']).toList();

      if (!validUsersList.contains(userEmail)) {
        GoogleSignIn().signOut();
        Popup.alert(
          'Oops!',
          'Selected email is not authorised for "Admin" role. please check your email & try again.',
        );
        return false;
      }
    }
    return true; // if email is valid, we'll come out of IF_Block
  }

  logout() async {
    try {
      //
      await GoogleSignIn().signOut();
      await auth.signOut();
      await _box.erase();
      log(' - - - - - - ERASED DATA & LOGGED OUT - - - - - - ');
      Get.offAll(() => SigninScreen());
      //
    } catch (e) {
      log(' - - - - - - LOGOUT ERROR - - - - - - ');
      log('LOGOUT ERROR: $e');
    }
  }
}
