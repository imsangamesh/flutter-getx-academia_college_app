import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/my_colors.dart';
import '../../../core/themes/my_textstyles.dart';
import '../../../core/utilities/utils.dart';
import '../../../core/widgets/my_buttons.dart';
import '../../../core/widgets/my_document_viewers.dart';
import '../../../models/placement_msg_model.dart';

class PlacementChatTile extends StatelessWidget {
  const PlacementChatTile({
    super.key,
    required this.msgModel,
  });

  final PlacementMsgModel msgModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
      margin: const EdgeInsets.only(bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColors.shade15,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(msgModel.title, style: MyTStyles.title),
          ),
          const SizedBox(height: 5),
          Text(msgModel.description, style: MyTStyles.body),
          const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Divider(),
          ),
          if (msgModel.fileUrls.isNotEmpty || msgModel.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AttachmentsRow(msgModel),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.fromLTRB(7, 6, 8, 5),
              decoration: BoxDecoration(
                color: ThemeColors.shade100,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(7),
                ),
              ),
              child: Text(
                DateFormat('dd/MM  HH:mm')
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
  const AttachmentsRow(this.msgModel, {super.key});

  final PlacementMsgModel msgModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
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
          ...msgModel.fileUrls
              .map(
                (eachFile) => Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: FittedBox(
                    child: MyOutlinedBtn(
                      eachFile['name'],
                      () => Get.to(
                        () => MyNetPDFViewer(eachFile['url'], eachFile['name']),
                      ),
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
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Utils.imageLoader(
              images[index]['url'],
              fit: BoxFit.contain,
              width: double.infinity,
            );
          },
        ),
      ),
    );
  }
}
