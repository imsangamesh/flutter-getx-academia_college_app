import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/placement/placement_chat_page.dart';

class PlacementTile extends StatelessWidget {
  const PlacementTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.only(top: 5),
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        title: Text('Placement Updates', style: AppTStyles.subHeading),
        children: [
          MyOutlinedBtn(
            'First Year   >',
            () => Get.to(() => PlacementChatPage(CollegeData.years[0])),
            icon: Icons.looks_one,
          ),
          MyOutlinedBtn(
            'Second Year   >',
            () => Get.to(() => PlacementChatPage(CollegeData.years[1])),
            icon: Icons.looks_two,
          ),
          MyOutlinedBtn(
            'Third Year   >',
            () => Get.to(() => PlacementChatPage(CollegeData.years[2])),
            icon: Icons.looks_3,
          ),
          MyOutlinedBtn(
            'Final Year   >',
            () => Get.to(() => PlacementChatPage(CollegeData.years[3])),
            icon: Icons.looks_4,
          ),
        ],
      ),
    );
  }
}
