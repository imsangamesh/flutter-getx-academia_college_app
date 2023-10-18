import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/placement/placement_chat_page_view.dart';

import '../../core/helpers/my_helper.dart';
import '../../core/themes/my_colors.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';
import '../auth/auth_controller.dart';
import '../dept_sem_adder/add_dept_and_sem.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final authController = Get.put(AuthController());
  final List<String> years = ['1', '2', '3', '4'];
  final selectedYear = '1'.obs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MyElevatedBtn(
            'Subject Allocation',
            () => Get.to(() => const AddDeptAndSemester()),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MyHelper.scrSize(context).width,
            height: 63,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: MyDropDownWrapper(
                    DropdownButton(
                      dropdownColor: ThemeColors.listTile,
                      underline: MyDropDownWrapper.transDivider,
                      isExpanded: true,
                      iconSize: 30,
                      icon: const Icon(Icons.arrow_drop_down),
                      value: selectedYear(),
                      items: years
                          .map((String each) => DropdownMenuItem(
                                value: each,
                                child: Text(
                                  '  $each Year Placement Updates',
                                  style: selectedYear() == each
                                      ? TextStyle(color: ThemeColors.darkPrim)
                                      : null,
                                ),
                              ))
                          .toList(),
                      onChanged: (String? newValue) => selectedYear(newValue!),
                    ),
                  ),
                ),
                const SizedBox(width: 5),

                /// -------------------------------------- `credits`
                MyIconBtn(
                  Icons.double_arrow_rounded,
                  () => Get.to(
                    () => PlacementChatPageView(selectedYear()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
