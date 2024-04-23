import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/api/fcm_api.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/custom_textfield.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/core/widgets/my_dropdown_wrapper.dart';
import 'package:newbie/data/college_data.dart';

class SendResultNotifications extends StatelessWidget {
  SendResultNotifications({super.key});

  final msgCntr = TextEditingController(
      text:
          "Hello there! 7 sem student's result has been updated! Kindly view the same on our college application! Thank you!");
  final selectedSem = '7'.obs;

  void handleSemSelect(String? val) {
    selectedSem(val ?? '1');
    msgCntr.text =
        "Hello there! ${selectedSem()} sem student's result has been updated! Kindly view the same on our college application! Thank you!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Result Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// -------------------------------------- `semester`
            Obx(
              () => MyDropDownWrapper(
                DropdownButton(
                  dropdownColor: AppColors.listTile,
                  underline: MyDropDownWrapper.transparentDivider,
                  isExpanded: true,
                  iconSize: 30,
                  icon: const Icon(Icons.arrow_drop_down),
                  value: selectedSem(),
                  items: CollegeData.semesters
                      .map((String each) => DropdownMenuItem(
                            value: each,
                            child: Text(
                              '  $each semester',
                              style: selectedSem() == each
                                  ? AppTStyles.subHeading
                                  : null,
                            ),
                          ))
                      .toList(),
                  onChanged: handleSemSelect,
                ),
              ),
            ),
            const SizedBox(height: 5),

            CustomTextField(msgCntr, 'Message body', maxLines: 5),

            SizedBox(
              width: double.infinity,
              child: MyOutlinedBtn(
                'Send',
                () => Popup.confirm(
                  'Confirm?',
                  'Are you sure that you want to send notifications about result to parents and students?',
                  yesFun: () => FCMApi.sendResultUpdates(
                    selectedSem(),
                    msgCntr.text.trim(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerLeft,
              child: Popup.caution(),
            ),
          ],
        ),
      ),
    );
  }
}
