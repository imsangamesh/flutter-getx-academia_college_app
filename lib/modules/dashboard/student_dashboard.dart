import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/images.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/modules/activity_points/activity_analytics.dart';
import 'package:newbie/modules/attendence/student_attendence_analytics.dart';
import 'package:newbie/modules/auth/auth_controller.dart';
import 'package:newbie/modules/dashboard/widgets/home_helpers.dart';
import 'package:newbie/modules/placement/placement_chat_page.dart';
import 'package:newbie/modules/result/result_analytics.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  final Map<String, dynamic> studentData = AppData.fetchData();
  final authController = Get.put(AuthController());

  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;
  get currentYear => MyHelper.semToYear(studentData['sem']);

  @override
  Widget build(BuildContext context) {
    final data = AppData.fetchData();

    return GetX<ThemeController>(
      builder: (cntr) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              /// --------------------------------- `AVATAR`
              HomeAvatar(cntr.isDark()),

              /// --------------------------------- `LOTOUT & THEME`
              ThemeAndLogoutButton(cntr, authController),
            ],
          ),

          /// --------------------------------- `ABOUT ME CHIPS`
          const Divider(),

          Text(
            data['name'],
            textAlign: TextAlign.center,
            style: AppTStyles.heading.copyWith(color: AppColors.prim),
          ),
          Text(
            data['email'],
            textAlign: TextAlign.center,
            style: AppTStyles.subHeading.copyWith(),
          ),
          const SizedBox(height: 10),

          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Chip(label: Text('${data['dept']} dept')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['usn']}')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['sem']} sem')),
              const SizedBox(width: 7),
              Chip(label: Text('${data['div']} div')),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          /// --------------------------------- `BUTTONS`

          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            children: [
              HomeButton(
                AppImages.attendance,
                () => Get.to(() => const StudentAttendanceAnalytics()),
              ),
              HomeButton(
                AppImages.result,
                () => Get.to(() => const ResultAnalytics()),
              ),
              HomeButton(
                AppImages.activities,
                () => Get.to(() => const ActivityAnalytics()),
              ),
              HomeButton(
                AppImages.placement,
                () => Get.to(() => PlacementChatPage(currentYear)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton(this.image, this.onTap, {super.key});

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.prim.withAlpha(25),
      borderRadius: BorderRadius.circular(15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.prim.withAlpha(50),
        borderRadius: BorderRadius.circular(15),
        child: Ink.image(
          image: AssetImage(image),
        ),
      ),
    );
  }
}
