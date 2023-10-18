import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/helpers/my_helper.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/modules/activity_points/upload_student_activity.dart';

import '../../core/themes/my_colors.dart';
import '../../core/themes/my_textstyles.dart';
import '../../core/widgets/my_buttons.dart';
import '../../core/widgets/my_document_viewers.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';
import '../dept_sem_adder/add_student_json.dart';

class ApproveStudentActivity extends StatefulWidget {
  const ApproveStudentActivity({super.key});

  @override
  State<ApproveStudentActivity> createState() => _ApproveStudentActivityState();
}

class _ApproveStudentActivityState extends State<ApproveStudentActivity> {
  final RxList<String> studentList = RxList([]);

  final selectedUsn = ''.obs;
  final studentActivities = [].obs;

  fetchStudentData() async {
    try {
      final stdSnaps = await fire.collection('students').get();
      final stdDataList = stdSnaps.docs.map((e) => e.data()).toList();
      final facMap = await MyHelper.fetchFacultyMap();

      stdDataList.where((element) => element['faculty'] == facMap['email']);

      final stdList = stdDataList.map((e) => e['usn'].toString()).toList();

      studentList(stdList);
      selectedUsn(stdList.first.toString());

      log(studentList.toString());
    } catch (e) {
      Utils.normalDialog();
    }
  }

  fetchStudentActivityUploads() async {
    try {
      final activitySnap = await fire
          .collection('students')
          .doc(selectedUsn())
          .collection('activity_points')
          .get();

      final activityData = activitySnap.docs.map((e) => e.data()).toList();
      studentActivities(activityData);
    } catch (e) {
      Utils.normalDialog();
    }
  }

  approveOrReject(Map mapData, bool status) async {
    try {
      await fire
          .collection('students')
          .doc(selectedUsn())
          .collection('activity_points')
          .doc(mapData['id'])
          .set({
        ...mapData,
        'status': status,
      });
    } catch (e) {
      Utils.normalDialog();
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
        appBar: AppBar(
          title: const Text('Approve Activity'),
          actions: [
            IconButton(
              onPressed: fetchStudentData,
              icon: const Icon(Icons.circle),
            ),
            IconButton(
              onPressed: () => Get.to(() => AddStudentJson()),
              icon: const Icon(Icons.send),
            ),
            IconButton(
              onPressed: () => Get.to(() => UploadStudentActivity()),
              icon: const Icon(Icons.abc),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              MyDropDownWrapper(
                DropdownButton(
                  dropdownColor: ThemeColors.listTile,
                  underline: MyDropDownWrapper.transDivider,
                  isExpanded: true,
                  iconSize: 30,
                  icon: const Icon(Icons.arrow_drop_down),
                  value: selectedUsn(),
                  items: studentList
                      .map((String each) => DropdownMenuItem(
                            value: each,
                            child: Text(
                              '  $each',
                              style: selectedUsn() == each
                                  ? TextStyle(color: ThemeColors.darkPrim)
                                  : null,
                            ),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    selectedUsn(newValue!);
                    fetchStudentActivityUploads();
                  },
                ),
              ),

              ///
              const SizedBox(height: 15),
              // ...studentActivities
              //     .map((eachMap) => ActivityTile(eachMap, approveOrReject))
              //     .toList()
              if (selectedUsn() != '')
                Expanded(
                  child: StreamBuilder(
                    stream: fire
                        .collection('students')
                        .doc(selectedUsn())
                        .collection('activity_points')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final actSnap = snapshot.data;

                        if (actSnap == null || actSnap.docs.isEmpty) {
                          return Utils.emptyList(
                            'Oops! No activity uploaded yet!',
                          );
                        }

                        final finalDataList = actSnap.docs
                            .map((e) => e.data())
                            .where((each) => each['status'] == false)
                            .toList();

                        if (finalDataList.isEmpty) {
                          return Utils.emptyList(
                            'Oops! No activity uploaded yet!',
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: finalDataList.length,
                          itemBuilder: (context, index) {
                            final eachMap = finalDataList[index];

                            return ActivityTile(eachMap, approveOrReject);
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

class ActivityTile extends StatelessWidget {
  const ActivityTile(this.mapData, this.approveOrReject, {super.key});

  final Map<String, dynamic> mapData;
  final dynamic approveOrReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColors.shade15,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mapData['description'], style: MyTStyles.body),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Divider(),
          ),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                FittedBox(
                  child: MyOutlinedBtn(
                    mapData['pdfUrl']['name'],
                    () => Get.to(
                      () => MyNetPDFViewer(
                        mapData['pdfUrl']['url'],
                        mapData['pdfUrl']['name'],
                      ),
                    ),
                    icon: Icons.file_open_rounded,
                  ),
                ),
                const SizedBox(width: 5),
                FittedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                    decoration: BoxDecoration(
                      color: ThemeColors.shade35,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${mapData['hours']} hours',
                      style: MyTStyles.medBody,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                  decoration: BoxDecoration(
                    color: ThemeColors.shade35,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${mapData['points']}  pts',
                    style: MyTStyles.medBody,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          ///
          Row(
            children: [
              Expanded(
                child: MyElevatedBtn(
                  'Reject',
                  () => approveOrReject(mapData, false),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: MyElevatedBtn(
                  'Approve',
                  () => Utils.confirmDialogBox(
                    'Confirm?',
                    'Do you want to approve this activity?',
                    yesFun: () => approveOrReject(mapData, true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class AttachmentsRow extends StatelessWidget {
//   const AttachmentsRow(this.msgModel, {super.key});

//   final PlacementMsgModel msgModel;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 35,
//       child: Row(
//         children: [
//           if (msgModel.imageUrls.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(right: 7),
//               child: FittedBox(
//                 child: MyOutlinedBtn(
//                   'Images',
//                   () => Get.to(() => MessageImagesPage(msgModel.imageUrls)),
//                   icon: Icons.image,
//                 ),
//               ),
//             ),
//           ...msgModel.fileUrls
//               .map(
//                 (eachFile) => Padding(
//                   padding: const EdgeInsets.only(right: 7),
//                   child: FittedBox(
//                     child: MyOutlinedBtn(
//                       eachFile['name'],
//                       () => Get.to(
//                         () => MyNetPDFViewer(eachFile['url'], eachFile['name']),
//                       ),
//                       icon: Icons.file_open_rounded,
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }
// }
