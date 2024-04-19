import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/constants.dart';
import 'package:newbie/core/constants/pref_keys.dart';
import 'package:newbie/core/helpers/app_data.dart';
import 'package:newbie/core/utils/popup.dart';
import 'package:newbie/data/college_data.dart';
import 'package:newbie/models/placement_msg_model.dart';
import 'package:newbie/modules/placement/add_placement_message.dart';
import 'package:newbie/modules/placement/placement_chat_tile.dart';

class PlacementChatPage extends StatelessWidget {
  const PlacementChatPage(this.year, {super.key});

  final String year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$year Placement Updates')),
      body: StreamBuilder(
        stream: fire
            .collection(FireKeys.placementMsgs)
            .doc(year)
            .collection(FireKeys.messages)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final msgSnap = snapshot.data;

            if (msgSnap == null || msgSnap.docs.isEmpty) {
              return Popup.nill('Oops! No placement updates yet!');
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: msgSnap.docs.length,
              itemBuilder: (context, index) {
                final msgData = msgSnap.docs[index].data();
                final msgModel = PlacementMsgModel.fromMap(msgData);

                return PlacementChatTile(msgModel, year);
              },
            );
          } else {
            return const Center(child: Text('...'));
          }
        },
      ),
      floatingActionButton: AppData.role != Role.admin
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Get.to(() => AddPlacementMessage()),
              label: const Text('new'),
            ),
    );
  }
}
