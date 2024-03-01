import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';

class AttendanceAnalysisTile extends StatelessWidget {
  const AttendanceAnalysisTile(this.usn, this.subMap, {super.key});

  final String usn;
  final Map<String, dynamic> subMap;

  double perc() =>
      (subMap['attendance'] as List<Map<String, dynamic>>)
          .where((each) => each['isPresent'])
          .length /
      subMap['attendance'].length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),

        /// ---------------------------------------- `EXPANSION TILE`
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 0, 30),
            child: Column(
              children: [
                Text(subMap['subject'], style: AppTStyles.subHeading),
                const SizedBox(height: 20),

                /// ---------------------------------------- `PERCENTAGE GRAPH`
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            value: perc(),
                            strokeWidth: 15,
                            color: AppColors.success,
                            backgroundColor: AppColors.danger,
                          ),
                        ),
                        Text('${(perc() * 100).toInt()}%',
                            style: AppTStyles.heading),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        graphLegend('Present'),
                        graphLegend('Absent'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ---------------------------------------- `EACH DAY CHIP`
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 7,
                  children: (subMap['attendance'] as List<Map<String, dynamic>>)
                      .map(
                        (each) => Chip(
                          backgroundColor: each['isPresent']
                              ? AppColors.success.withOpacity(0.5)
                              : AppColors.danger.withOpacity(0.5),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(
                            DateFormat('dd MMM').format(
                              DateTime.parse(each['date']),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Widget graphLegend(String label) {
    final color = label == 'Present' ? AppColors.success : AppColors.danger;

    return Row(
      children: [
        Icon(Icons.circle, size: 15, color: color),
        Text(
          ' $label',
          style: AppTStyles.subHeading.copyWith(color: color),
        ),
      ],
    );
  }
}
