import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/app_file_viewers.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/activity_model.dart';

import '../../core/widgets/my_buttons.dart';

class PendingActivityTile extends StatelessWidget {
  const PendingActivityTile(this.usn, this.activity, {super.key});

  final String usn;
  final Activity activity;

  approveOrReject(ActivityStatus status) async {
    try {
      await fire
          .collection(FireKeys.students)
          .doc(usn)
          .collection(FireKeys.activities)
          .doc(activity.id)
          .set({...activity.toMap(), 'status': status.str});

      Popup.snackbar('Activity ${status.str}!', status: true);
    } catch (e) {
      Popup.general();
    }
  }

  void confirmAction(ActivityStatus status) {
    final label = status == ActivityStatus.approved ? 'approve' : 'reject';

    Popup.confirm(
      'Confirm?',
      'Are you sure that you want to $label this activity?',
      yesFun: () => approveOrReject(status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.listTile,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activity.description, style: AppTStyles.body),
          const NoIndentDivider(),
          SizedBox(
            width: size.width,
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FittedBox(
                    child: MyOutlinedBtn(
                      activity.fileDetails['name'],
                      () => Get.to(
                        () => OnlinePDFViewer(
                          activity.fileDetails['url'],
                          activity.fileDetails['name'],
                        ),
                      ),
                      icon: Icons.file_open_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  MyChip('${activity.hours} hours'),
                  const SizedBox(width: 10),
                  MyChip('${activity.points} pts')
                ],
              ),
            ),
          ),

          /// ------------------------- `APPROVE or REJECT Buttons`
          const NoIndentDivider(),
          Row(
            children: [
              Expanded(
                child: MyOutlinedBtn(
                  'Reject',
                  () => confirmAction(ActivityStatus.rejected),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: MyElevatedBtn(
                  'Approve',
                  () => confirmAction(ActivityStatus.approved),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
