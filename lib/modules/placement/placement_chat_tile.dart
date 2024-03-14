import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/themes/app_colors.dart';
import 'package:newbie/core/themes/app_text_styles.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/core/widgets/app_file_viewers.dart';
import 'package:newbie/data/college_data.dart';

import '../../../core/widgets/my_buttons.dart';
import '../../../models/placement_msg_model.dart';

class PlacementChatTile extends StatelessWidget {
  const PlacementChatTile(this.msgModel, this.year, {super.key});

  final PlacementMsgModel msgModel;
  final String year;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.listTile,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.listTile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------- title
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(msgModel.title, style: AppTStyles.button),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Divider(),
          ),
          // ---------------------- description
          Text(msgModel.description, style: AppTStyles.body),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Divider(),
          ),
          // ---------------------- images & files row
          if (msgModel.fileUrls.isNotEmpty || msgModel.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AttachmentsRow(msgModel, year),
              ),
            ),
          // ---------------------- date and time
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.fromLTRB(7, 6, 8, 5),
              decoration: BoxDecoration(
                color: AppColors.scaffold,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(7),
                ),
              ),
              child: Text(
                DateFormat('MMM dd | HH:mm')
                    .format(DateTime.parse(msgModel.date)),
                style: const TextStyle(fontSize: 11),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AttachmentsRow extends StatelessWidget {
  const AttachmentsRow(this.msgModel, this.year, {super.key});

  final PlacementMsgModel msgModel;
  final String year;

  deleteMessage(String docId) async {
    try {
      await fire
          .collection(FireKeys.placementMsgs)
          .doc(year)
          .collection(FireKeys.messages)
          .doc(docId)
          .delete();

      Popup.snackbar('Message deleted!', status: true);
    } on FirebaseException catch (e) {
      Popup.alert(e.code, e.message.toString());
    } catch (e) {
      Popup.general();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          // ------------------------------ DELETE Button
          if (role == Role.admin)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: MyIconBtn(
                Icons.delete,
                () => Popup.confirm(
                  'Alert!',
                  'Are you sure that you want to delete this message?',
                  yesFun: () => deleteMessage(msgModel.id),
                ),
                color: AppColors.danger,
                size: 31,
              ),
            ),

          // ------------------------------ IMAGES
          if (msgModel.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: FittedBox(
                child: MyOutlinedBtn(
                  'Images',
                  () => Get.to(() => MessageImagesPage(msgModel.imageUrls)),
                  icon: Icons.image,
                ),
              ),
            ),

          // ------------------------------ PDFs
          ...msgModel.fileUrls
              .map(
                (eachFile) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: FittedBox(
                    child: MyOutlinedBtn(
                      eachFile['name'],
                      () => Get.to(() => OnlinePDFViewer(
                            eachFile['url'],
                            eachFile['name'],
                          )),
                      icon: Icons.file_open_rounded,
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class MessageImagesPage extends StatelessWidget {
  const MessageImagesPage(this.images, {super.key});

  final List<dynamic> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Images')),
      body: SizedBox(
        width: double.infinity,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Popup.imageLoader(
                  images[index]['url'],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
