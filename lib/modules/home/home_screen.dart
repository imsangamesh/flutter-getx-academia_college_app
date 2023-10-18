import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/themes/my_colors.dart';
import 'package:newbie/core/themes/theme_controller.dart';
import 'package:newbie/modules/analytics/student_attendence.dart';
import 'package:newbie/modules/dashboard/admin_dashboard.dart';
import 'package:newbie/modules/home/widgets/home_profile_header.dart';
import 'package:newbie/modules/home/widgets/home_search_bar.dart';

import '../../core/constants/my_pref_keys.dart';
import '../../core/helpers/my_helper.dart';
import '../../core/widgets/my_buttons.dart';
import '../../models/user_model.dart';
import '../activity_points/approve_student_activity.dart';
import '../activity_points/upload_student_activity.dart';
import '../analytics/student_marks_analytics.dart';
import '../faculty_student/student_result_update_page.dart';
import '../faculty_student/widgets/attendence_selector.dart';
import '../placement/placement_chat_page_view.dart';
import 'widgets/home_interests_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  String get imageUrl => auth.currentUser!.photoURL ?? MyHelper.profilePic;
  final studentData = {}.obs;
  final dataFetched = false.obs;

  fetchStudentYear() async {
    final studentMap = await MyHelper.fetchStudentMap();
    studentData(studentMap);
    dataFetched(true);
  }

  @override
  void initState() {
    fetchStudentYear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final Role role = MyPrefKeys.fetchRole();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onVerticalDragUpdate: (details) {
        FocusScope.of(context).unfocus();
      },
      child: GetX<ThemeController>(
        builder: (cntrlr) => Scaffold(
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              /// --------------------------------- `appBar`
              SliverAppBar(
                expandedHeight: context.height * 0.2,

                /// --------------------------------- `appBar body`
                flexibleSpace: FlexibleSpaceBar(
                  // ---------- outer box for bg color
                  background: Container(
                    color: cntrlr.isDark()
                        ? MyColors.darkScaffoldBG
                        : MyColors.lightScaffoldBG,
                    // ---------- inner box for it's contents
                    child: Container(
                      padding: EdgeInsets.only(
                          top: topPad, right: 20, left: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: cntrlr.primary(),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// -------------------------------------------------- `appBar components`
                          HomeProfileHeader(imageUrl: imageUrl),
                          const Spacer(),
                          const HomeSearchBar(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// --------------------------------- `your interests`
              SliverToBoxAdapter(
                child: HomeInterestsTile(cntrlr.primary()),
              ),

              /// --------------------------------- `STUDENT`
              if (role == Role.student)
                SliverToBoxAdapter(
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: MyElevatedBtn(
                              'Activity Points',
                              () => Get.to(() => UploadStudentActivity()),
                            ),
                          ),
                          const SizedBox(height: 15),
                          MyElevatedBtn(
                            'Graph',
                            () => Get.to(() => const StudentMarksAnalytics()),
                          ),
                          const SizedBox(height: 15),
                          if (dataFetched())
                            MyElevatedBtn(
                              'My Attendence',
                              () => Get.to(
                                () => StudentAttendenceView(studentData['usn']),
                              ),
                            ),
                          const SizedBox(height: 15),
                          if (dataFetched())
                            MyElevatedBtn(
                              '${MyHelper.semToYear(studentData['sem'])} Year Placement Updates',
                              () => Get.to(
                                () => PlacementChatPageView(
                                  MyHelper.semToYear(studentData['sem']),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

              /// --------------------------------- `FACULTY`
              if (role == Role.faculty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MyElevatedBtn(
                          'Marks Entry',
                          () => Get.to(() => StudentResultUpdatePage()),
                        ),
                        const SizedBox(height: 15),
                        MyElevatedBtn(
                          'Approve Activity',
                          () => Get.to(() => const ApproveStudentActivity()),
                        ),
                        const SizedBox(height: 15),
                        MyElevatedBtn(
                          'Attendence',
                          () => Get.to(() => AttendenceSelector()),
                        ),
                      ],
                    ),
                  ),
                ),

              /// --------------------------------- `ADMIN`
              if (role == Role.admin)
                SliverToBoxAdapter(child: AdminDashboard()),
            ],
          ),
        ),
      ),
    );
  }
}
