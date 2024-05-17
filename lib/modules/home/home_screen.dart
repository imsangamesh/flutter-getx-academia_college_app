import 'package:flutter/material.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/modules/dashboard/admin_dashboard.dart';
import 'package:newbie/modules/dashboard/faculty_dashboard.dart';
import 'package:newbie/modules/dashboard/parent_dashboard.dart';
import 'package:newbie/modules/dashboard/student_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  //

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  /// --------------------------------- `STUDENT`
                  if (AppData.role == Role.student) StudentDashboard(),

                  /// --------------------------------- `FACULTY`
                  if (AppData.role == Role.faculty) ...[
                    FacultyDashboard(),
                    const Divider(),
                  ],

                  /// --------------------------------- `ADMIN`
                  if (AppData.role == Role.admin) AdminDashboard(),

                  /// --------------------------------- `PARENT`
                  if (AppData.role == Role.parent) ParentDashboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
