import 'package:flutter/material.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/images.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/auth/auth_controller.dart';

class ThemeAndLogoutButton extends StatelessWidget {
  const ThemeAndLogoutButton(this.cntr, this.authController, {super.key});

  final ThemeController cntr;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Column(
        children: [
          MyIconBtn(
            Icons.power_settings_new,
            color: AppColors.danger,
            () => Popup.confirm(
              'Logout?',
              'Are you sure that you want to logout from the app?',
              yesFun: authController.logout,
            ),
          ),
          Switch(
            value: cntr.isDark(),
            onChanged: (val) => cntr.toggleTheme(),
            activeThumbImage: const AssetImage(AppImages.darkMode),
            activeColor: AppColors.prim,
            inactiveThumbImage: const AssetImage(AppImages.lightMode),
          ),
        ],
      ),
    );
  }
}

class HomeAvatar extends StatelessWidget {
  const HomeAvatar(this.isDark, {super.key});
  final bool isDark;

  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.lListTile.withAlpha(50)
            : AppColors.lListTile.withAlpha(120),
      ),
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.prim, width: 3),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
