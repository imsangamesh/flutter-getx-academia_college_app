import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/widgets/app_file_viewers.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/activity_model.dart';

import '../../core/widgets/my_buttons.dart';

class VerifiedActivityTile extends StatelessWidget {
  VerifiedActivityTile(this.activity, {super.key});

  final String usn = AppData.fetchData()['usn'];
  final Activity activity;

  get bottomStripColor => activity.status == ActivityStatus.approved.str
      ? AppColors.success
      : activity.status == ActivityStatus.rejected.str
          ? AppColors.danger
          : AppColors.neutral;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.listTile,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                /// ---------------- `Description`
                Text(activity.description, style: AppTStyles.body),
                const NoIndentDivider(),

                /// ---------------- `details ROW`
                SizedBox(
                  height: 40,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MyChip('${activity.hours} hours'),
                        const SizedBox(width: 10),
                        MyChip('${activity.points} pts'),
                        const SizedBox(width: 10),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ---------------- `Status Strip`
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: bottomStripColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
