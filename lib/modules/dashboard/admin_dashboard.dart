import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/widgets/my_buttons.dart';
import 'package:newbie/modules/core_data_updation/update_core_data.dart';
import 'package:newbie/modules/placement/placement_tile.dart';

import '../auth/auth_controller.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final authController = Get.put(AuthController());
  final List<String> years = ['1', '2', '3', '4'];
  final selectedYear = '1'.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        MyElevatedBtn(
          'Update Core JSON Data',
          () => Get.to(() => UpdateCoreData()),
        ),
        const SizedBox(height: 20),
        const PlacementTile(),
      ],
    );
  }
}
