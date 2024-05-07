import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/activity_model.dart';
import 'package:newbie/modules/activity_points/pending_activity_tile.dart';

import '../../core/widgets/my_dropdown_wrapper.dart';

class ApproveActivity extends StatefulWidget {
  const ApproveActivity({super.key});

  @override
  State<ApproveActivity> createState() => _ApproveActivityState();
}

class _ApproveActivityState extends State<ApproveActivity> {
  //
  final RxList<String> studentUSNList = RxList([]);
  final selectedUsn = ''.obs;
  final studentActivities = [].obs;
  final areStudentsFetched = false.obs;

  fetchStudentData() async {
    try {
      final stdSnaps = await fire.collection(FireKeys.students).get();
      final stdUSNList = stdSnaps.docs
          .map((each) => each.data())
          .where((eachMap) =>
              eachMap['pendingActivities'] > 0 &&
              eachMap['facultyEmail'] == 'snbenkikeri@gmail.com')
          .map((each) => each['usn'].toString())
          .toSet()
          .toList();

      log(stdUSNList.toString());
      studentUSNList(stdUSNList);
      selectedUsn(stdUSNList.first);

      areStudentsFetched(true);
    } catch (e) {
      Popup.general();
    }
  }

  @override
  void initState() {
    fetchStudentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('Approve Activity')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ----------------------------- `USN Selector`
              if (areStudentsFetched())
                Row(
                  children: [
                    Expanded(
                      child: MyDropDownWrapper(
                        DropdownButton(
                          dropdownColor: AppColors.listTile,
                          underline: MyDropDownWrapper.transparentDivider,
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
                          onChanged: (String? newValue) =>
                              selectedUsn(newValue!),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 10),
                      child: MyIconBtn(
                        Icons.refresh,
                        fetchStudentData,
                        size: 50,
                      ),
                    ),
                  ],
                ),

              /// ----------------------------- `PENDING ACTIVITIES`
              if (selectedUsn() != '')
                Expanded(
                  child: StreamBuilder(
                    stream: fire
                        .collection(FireKeys.students)
                        .doc(selectedUsn.value)
                        .collection(FireKeys.activities)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final activitySnap = snapshot.data;

                        if (activitySnap == null || activitySnap.docs.isEmpty) {
                          return Popup.nill(
                            'Oops! No pending activities found!',
                          );
                        }

                        final pendingActivityMaps = activitySnap.docs
                            .map((e) => e.data())
                            .where((each) =>
                                each['status'] == ActivityStatus.pending.str)
                            .toList();

                        if (pendingActivityMaps.isEmpty) {
                          return Popup.nill(
                            'Oops! No pending activities found!',
                          );
                        }

                        return ListView.builder(
                          itemCount: pendingActivityMaps.length,
                          itemBuilder: (context, index) {
                            final activity = Activity.fromMap(
                              pendingActivityMaps[index],
                            );

                            return PendingActivityTile(
                                selectedUsn.value, activity);
                          },
                        );
                      } else {
                        return const Center(child: Text('...'));
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
