import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newbie/core/themes/my_colors.dart';

import '../../core/constants/my_constants.dart';
import '../../core/utilities/utils.dart';

class StudentAttendenceView extends StatelessWidget {
  const StudentAttendenceView(this.usn, {super.key});

  final String usn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Attendence')),
      body: StreamBuilder(
        stream: fire
            .collection('students')
            .doc(usn)
            .collection('attendence')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final atdSnap = snapshot.data;

            if (atdSnap == null || atdSnap.docs.isEmpty) {
              return Utils.emptyList('Oops! No chats uploaded yet!');
            }

            final subjects = [];
            for (var eachMap in atdSnap.docs) {
              subjects.add(eachMap.data()['subjects']);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: atdSnap.docs.length,
              itemBuilder: (context, index) {
                final atdData = atdSnap.docs[index].data();

                return Container(
                  color: ThemeColors.shade35,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(atdData['subject'].toString()),
                      Text(trueToPresent(atdData['atd'])),
                      Text(
                        DateFormat('dd/MM  |  hh:mm').format(
                          DateTime.parse(atdData['date'].toString()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('...'));
          }
        },
      ),
    );
  }

  trueToPresent(bool val) => val ? 'P' : 'A';
}
