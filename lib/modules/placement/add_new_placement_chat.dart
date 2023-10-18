import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newbie/core/constants/my_constants.dart';
import 'package:newbie/core/themes/my_colors.dart';
import 'package:newbie/core/utilities/utils.dart';

import '../../controllers/upload_controller.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../core/widgets/my_dropdown_wrapper.dart';
import '../../models/placement_msg_model.dart';

class AddNewPlacementChat extends StatefulWidget {
  const AddNewPlacementChat(this.year, {Key? key}) : super(key: key);

  final String year;

  @override
  State<AddNewPlacementChat> createState() => _AddNewPlacementChatState();
}

class _AddNewPlacementChatState extends State<AddNewPlacementChat> {
  //
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _currentYear = '1'.obs;

  final _years = ['1', '2', '3', '4'];

  final _attachImages = false.obs;
  RxList<XFile> images = RxList([]);
  RxList<Map> imageUrls = RxList([]);

  final _attachFiles = false.obs;
  RxList<PlatformFile> files = RxList([]);
  RxList<Map> fileUrls = RxList([]);

  // - - - - - - - - - - - - - - - - - - - - - - - - - SUBMIT
  uploadAndUpdateMessage() async {
    if (_attachFiles() && files.isEmpty) {
      Utils.showAlert(
        'Oops',
        'please upload files, or untick the "Add Files"',
      );
      return;
    }
    if (_attachImages() && images.isEmpty) {
      Utils.showAlert(
        'Oops',
        'please upload images, or untick the "Add Images"',
      );
      return;
    }
    if (_bodyController.text.trim() == '') {
      Utils.showAlert(
        'Oops !',
        'hey, please fill out your new message before you submit.',
      );
      return;
    }

    try {
      if (_attachFiles()) {
        if (!await uploadFiles(files)) {
          Utils.normalDialog();
          return;
        }
      }
      if (_attachImages()) {
        if (!await uploadImages(images)) {
          Utils.normalDialog();
          return;
        }
      }

      final messageModel = PlacementMsgModel(
        msgId: uuid.v1(),
        title: _titleController.text,
        description: _bodyController.text,
        date: DateTime.now().toIso8601String(),
        year: _currentYear(),
        links: [],
        imageUrls: imageUrls,
        fileUrls: fileUrls,
        createdAt: Timestamp.now(),
      );

      Utils.progressIndctr(label: 'updating...');

      fire
          .collection('placement')
          .doc(_currentYear())
          .collection('messages')
          .doc(messageModel.msgId)
          .set(messageModel.toMap());

      Get.close(2);
      Utils.showSnackBar('new message added!', status: true);
    } on FirebaseException catch (e) {
      Get.back();
      Utils.showAlert(e.code, e.message.toString());
    } catch (e) {
      Get.back();
      Utils.normalDialog();
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - IMAGES
  pickImages() async {
    final result = await ImagePicker().pickMultiImage();

    if (result.isEmpty) {
      Utils.showSnackBar('you didn\'t pick any images', status: false);
      _attachImages(false);
      return;
    }
    images(result);
  }

  Future<bool> uploadImages(List<XFile> uploadImages) async {
    List<Map>? receivedImgUrls =
        await UploadController.multipleFiles(uploadImages, 'message_images');

    if (receivedImgUrls == null || receivedImgUrls.isEmpty) return false;

    imageUrls(receivedImgUrls);
    return true;
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - FILES
  pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );
    if (result == null) {
      Utils.showSnackBar('you didn\'t pick any files', status: false);
      _attachFiles(false);
      return;
    }
    files(result.files);
  }

  Future<bool> uploadFiles(List<PlatformFile> uploadfiles) async {
    List<Map>? recFileData =
        await UploadController.multipleFiles(uploadfiles, 'message_files');

    if (recFileData == null || recFileData.isEmpty) return false;

    fileUrls(recFileData);
    return true;
  }

  @override
  void initState() {
    _currentYear(widget.year);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Add new message')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Obx(
              () => Column(children: [
                const SizedBox(height: 5),

                /// -------------------------------------- `title`
                CustomTextField(
                  _titleController,
                  'message title',
                  1,
                  icon: Icons.short_text,
                ),

                /// --------------------------------------- `description`
                CustomTextField(
                  _bodyController,
                  'message content',
                  15,
                  icon: Icons.notes_rounded,
                ),

                /// ---------------------------------------  `year dropdown`
                MyDropDownWrapper(
                  DropdownButton(
                    dropdownColor: ThemeColors.listTile,
                    underline: MyDropDownWrapper.transDivider,
                    isExpanded: true,
                    iconSize: 30,
                    icon: const Icon(Icons.arrow_drop_down),
                    value: _currentYear(),
                    items: _years
                        .map((String each) => DropdownMenuItem(
                              value: each,
                              child: Text(
                                '  $each year',
                                style: _currentYear() == each
                                    ? TextStyle(color: ThemeColors.darkPrim)
                                    : null,
                              ),
                            ))
                        .toList(),
                    onChanged: (String? newValue) => _currentYear(newValue!),
                  ),
                ),
                const SizedBox(height: 15),

                /// --------------------------------------- `image check box`
                CheckboxListTile(
                  title: const Text('Attach Images?'),
                  tileColor: ThemeColors.shade20,
                  value: _attachImages(),
                  onChanged: (val) {
                    _attachImages(val ?? false);
                    if (val == false) {
                      images.clear();
                    } else {
                      pickImages();
                    }
                  },
                ),
                if (images.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: images
                          .map((each) => Container(
                                margin: const EdgeInsets.only(right: 5, top: 5),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(File(each.path),
                                      fit: BoxFit.cover),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 15),

                /// --------------------------------------- `file check box`
                CheckboxListTile(
                  title: const Text('Attach Files?'),
                  tileColor: ThemeColors.shade20,
                  value: _attachFiles(),
                  onChanged: (val) {
                    _attachFiles(val ?? false);
                    if (val == false) {
                      files.clear();
                    } else {
                      pickFiles();
                    }
                  },
                ),
                const SizedBox(height: 5),
                if (files.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('  ${files.length} files selected'),
                  ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: uploadAndUpdateMessage,
          label: const Text(' Update '),
        ),
      ),
    );
  }
}
