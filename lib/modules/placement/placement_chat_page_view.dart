import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbie/core/constants/my_pref_keys.dart';
import 'package:newbie/core/utilities/utils.dart';
import 'package:newbie/models/placement_msg_model.dart';
import 'package:newbie/modules/placement/add_new_placement_chat.dart';
import 'package:newbie/modules/placement/widgets/placement_chat_tile.dart';

import '../../core/constants/my_constants.dart';
import '../../models/user_model.dart';

class PlacementChatPageView extends StatelessWidget {
  const PlacementChatPageView(this.year, {super.key});

  final String year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$year Year Placement Updates'),
      ),
      body: StreamBuilder(
        stream: fire
            .collection('placement')
            .doc(year)
            .collection('messages')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final msgSnap = snapshot.data;

            if (msgSnap == null || msgSnap.docs.isEmpty) {
              return Utils.emptyList('Oops! No chats uploaded yet!');
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: msgSnap.docs.length,
              itemBuilder: (context, index) {
                final msgData = msgSnap.docs[index].data();
                final msgModel = PlacementMsgModel.fromMap(msgData);

                return PlacementChatTile(msgModel: msgModel);
              },
            );
          } else {
            return const Center(child: Text('...'));
          }
        },
      ),
      floatingActionButton: MyPrefKeys.fetchRole() == Role.admin
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(() => AddNewPlacementChat(year)),
              label: const Text('new'),
            )
          : null,
    );
  }
}
