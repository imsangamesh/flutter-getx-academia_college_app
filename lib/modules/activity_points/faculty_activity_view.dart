import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_dropdown_wrapper.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/activity_model.dart';
import 'package:newbie/modules/activity_points/verified_activity_tile.dart';

class FacultyActivityView extends StatefulWidget {
  const FacultyActivityView({super.key});

  @override
  State<FacultyActivityView> createState() => _FacultyActivityViewState();
}

class _FacultyActivityViewState extends State<FacultyActivityView> {
  //
  final RxList<String> studentUSNList = RxList([]);
  final selectedUsn = ''.obs;

  final statuses = ['Approved', 'Pending', 'Rejected'];
  final selected = 0.obs;

  final areStudentsFetched = false.obs;
  final totalPoints = 0.0.obs;

  fetchStudentData() async {
    try {
      // -------------------------- Fetching Students
      final stdSnaps = await fire.collection(FireKeys.students).get();
      final stdUSNList = stdSnaps.docs
          .map((each) => each.data())
          .where((eachMap) =>
              eachMap['facultyEmail'] == AppData.fetchData()['email'])
          .map((each) => each['usn'].toString())
          .toSet()
          .toList();

      if (stdUSNList.isEmpty) {
        Get.back();
        Popup.alert(
          'Oops!',
          'There are no students registered under you right now! Kindly contact the administration dept.',
        );
        return;
      }

      studentUSNList(stdUSNList);
      selectedUsn(stdUSNList.first);
      await calculateTotalPoints();

      areStudentsFetched(true);
    } catch (e) {
      Popup.general();
    }
  }

  /// ----------------- `Calculating TOTAL POINTS`
  Future<void> calculateTotalPoints() async {
    try {
      final actSnap = await fire
          .collection(FireKeys.students)
          .doc(selectedUsn())
          .collection(FireKeys.activities)
          .get();

      final activityList = actSnap.docs
          .map((e) => e.data())
          .where((each) => each['status'] == ActivityStatus.approved.str)
          .map((e) => Activity.fromMap(e))
          .toList();

      // updating points
      totalPoints(0);
      for (var each in activityList) {
        totalPoints.value += each.points;
      }
    } catch (e) {
      Popup.general();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Students\' Activities'),
            bottom: TabBar(
              onTap: (value) => selected(value),
              tabs: const [
                Text('Approved'),
                Text('Pending'),
                Text('Rejected'),
              ],
            ),
          ),
          body: !areStudentsFetched()
              ? Popup.circleLoader()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (areStudentsFetched())
                        Row(
                          children: [
                            Expanded(
                              /// ----------------------------- `USN Selector`
                              child: MyDropDownWrapper(
                                DropdownButton(
                                  dropdownColor: AppColors.listTile,
                                  underline:
                                      MyDropDownWrapper.transparentDivider,
                                  iconSize: 30,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  value: selectedUsn(),
                                  items: studentUSNList
                                      .map((String each) => DropdownMenuItem(
                                            value: each,
                                            child: Text(
                                              '  $each',
                                              style: selectedUsn() == each
                                                  ? AppTStyles.subHeading
                                                  : null,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (String? newValue) {
                                    selectedUsn(newValue!);
                                    calculateTotalPoints();
                                  },
                                ),
                              ),
                            ),

                            /// ----------------------------- `Total Points`
                            Container(
                              height: 47,
                              width: 80,
                              margin: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.listTile,
                              ),
                              child: Center(
                                child: Text(
                                  '${totalPoints.toStringAsFixed(0)} pts',
                                  style: AppTStyles.subHeading,
                                ),
                              ),
                            ),
                          ],
                        ),

                      /// ------------------------------- `ACTIVITIES`
                      StreamBuilder(
                        stream: fire
                            .collection(FireKeys.students)
                            .doc(selectedUsn())
                            .collection(FireKeys.activities)
                            .where('status', isEqualTo: statuses[selected()])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Popup.circleLoader();
                          } else if (snapshot.hasData) {
                            final activitySnap = snapshot.data;

                            if (activitySnap == null ||
                                activitySnap.docs.isEmpty) {
                              return Popup.nill(
                                'Oops! No activities found!',
                              );
                            }

                            return Expanded(
                              child: ListView.builder(
                                itemCount: activitySnap.docs.length,
                                itemBuilder: (context, index) {
                                  final activity = Activity.fromMap(
                                    activitySnap.docs[index].data(),
                                  );

                                  // return Padding(
                                  //   padding: const EdgeInsets.only(bottom: 12),
                                  //   child: Container(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         15, 12, 15, 12),
                                  //     decoration: BoxDecoration(
                                  //       color: AppColors.listTile,
                                  //       borderRadius: BorderRadius.circular(16),
                                  //     ),
                                  //     child: Text(
                                  //       activity.description,
                                  //       style: AppTStyles.body,
                                  //     ),
                                  //   ),
                                  // );

                                  return VerifiedActivityTile(
                                    activity,
                                    selectedUsn(),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Center(child: Text('...'));
                          }
                        },
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
