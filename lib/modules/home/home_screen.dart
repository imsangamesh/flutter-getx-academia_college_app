import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/dashboard/admin_dashboard.dart';
import 'package:newbie/modules/dashboard/faculty_dashboard.dart';
import 'package:newbie/modules/dashboard/student_dashboard.dart';
import 'package:newbie/modules/profile/profile_screen_view.dart';

import '../../core/helpers/my_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;

  @override
  Widget build(BuildContext context) {
    final Role role = AppData.fetchRole();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Welcome Home!')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0x13000000),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: FloatingActionButton(
                      heroTag: 'profile',
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Get.to(() => ProfileScreenView());
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 3, color: AppColors.prim),
                        ),
                        child: Ink.image(image: NetworkImage(imageUrl)),
                      ),
                    ),
                  ),
                ),

                // MyOutlinedBtn('testing', () {}),

                const Divider(),

                /// --------------------------------- `STUDENT`
                if (role == Role.student) StudentDashboard(),

                const Divider(),

                /// --------------------------------- `FACULTY`
                // if (role == Role.faculty)
                FacultyDashboard(),

                const Divider(),

                /// --------------------------------- `ADMIN`
                // if (role == Role.admin)
                AdminDashboard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
