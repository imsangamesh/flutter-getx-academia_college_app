import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/activity_model.dart';
import 'package:newbie/modules/activity_points/verified_activity_tile.dart';

class ActivityAnalytics extends StatefulWidget {
  const ActivityAnalytics({super.key});

  @override
  State<ActivityAnalytics> createState() => _ActivityAnalyticsState();
}

class _ActivityAnalyticsState extends State<ActivityAnalytics> {
  //
  final String usn = AppData.fetchData()['usn'];
  final statuses = ['Approved', 'Pending', 'Rejected'];
  final selected = 'Approved'.obs;

  final totalPoints = 0.0.obs;
  final areTotalPoints = false.obs;

  /// ----------------- `Calculating TOTAL POINTS`
  Future<void> calculateTotalPoints() async {
    try {
      final actSnap = await fire
          .collection(FireKeys.students)
          .doc(usn)
          .collection(FireKeys.activities)
          .get();

      final activityList = actSnap.docs
          .map((e) => e.data())
          .where((each) => each['status'] == ActivityStatus.approved.str)
          .map((e) => Activity.fromMap(e))
          .toList();

      // updating points
      for (var each in activityList) {
        totalPoints.value += each.points;
      }

      areTotalPoints(true);
    } catch (e) {
      Popup.general();
    }
  }

  @override
  void initState() {
    super.initState();
    calculateTotalPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Analytics')),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// ------------------------------- `ACTIVITY Tracker`
              if (areTotalPoints())
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.prim.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: MyHelper.scrSize(context).width,
                  child: Row(
                    children: [
                      Text(
                        '${totalPoints.toStringAsFixed(0)} pts   ',
                        style: AppTStyles.smallCaption.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: totalPoints / 100,
                          minHeight: 15,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 15),

              /// ------------------------------- `ACTIVITY STATUS Selector`
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.prim.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: statuses
                      .map((e) => e == selected()
                          ? MyElevatedBtn(e, () {})
                          : MyOutlinedBtn(e, () => selected(e)))
                      .toList(),
                ),
              ),
              const SizedBox(height: 15),

              /// ------------------------------- `ACTIVITIES`
              StreamBuilder(
                stream: fire
                    .collection(FireKeys.students)
                    .doc(usn)
                    .collection(FireKeys.activities)
                    .where('status', isEqualTo: selected())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final activitySnap = snapshot.data;

                    if (activitySnap == null || activitySnap.docs.isEmpty) {
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

                          return VerifiedActivityTile(activity);
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
    );
  }
}
