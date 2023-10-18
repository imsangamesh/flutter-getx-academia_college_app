import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/themes/my_colors.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';

class FacultyFetcherDropdown extends StatelessWidget {
  const FacultyFetcherDropdown(
    this.facultyList,
    this.selectedFaculty, {
    super.key,
  });

  final RxString selectedFaculty;
  final List<String> facultyList;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MyDropDownWrapper(
        DropdownButton(
            dropdownColor: ThemeColors.listTile,
            underline: MyDropDownWrapper.transDivider,
            isExpanded: true,
            iconSize: 30,
            icon: const Icon(Icons.arrow_drop_down),
            value: selectedFaculty(),
            items: facultyList
                .map((String each) => DropdownMenuItem(
                      value: each,
                      child: Text(
                        '  $each',
                        style: selectedFaculty() == each
                            ? TextStyle(color: ThemeColors.darkPrim)
                            : null,
                      ),
                    ))
                .toList(),
            onChanged: (String? newValue) => selectedFaculty(newValue!)),
      ),
    );
  }
}
