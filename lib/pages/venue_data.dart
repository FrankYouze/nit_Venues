import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class VenueData extends StatefulWidget {
  const VenueData({super.key});

  @override
  State<VenueData> createState() => _VenueDataState();
}

class _VenueDataState extends State<VenueData> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('timetable');
  Map<String, dynamic> timetableData = {};

  @override
  void initState() {
    super.initState();
    _database.onValue.listen((event) {
      setState(() {
        timetableData = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
      });
    });
  }

  Color getColorForSession(String day, String sessionTime) {
    // Get current time
    DateTime now = DateTime.now();
    int currentHour = now.hour * 100 + now.minute;

    // Check if the session is active based on current time
    if (DateFormat('EEEE').format(now).toLowerCase() == day) {
      List<String> sessionParts = sessionTime.split("-");
      int sessionStart = int.parse(sessionParts[0]); //.replaceAll(':', ''));
      int sessionEnd = int.parse(sessionParts[1]); //.replaceAll(':', ''));

      if (currentHour >= sessionStart && currentHour <= sessionEnd) {
        return Colors.red; // Active
      }
    }

    return Colors.green; // Inactive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "NIT VENUE TIMETABLE",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timetableData.length,
        itemBuilder: (context, index) {
          String day = timetableData.keys.elementAt(index);
          Map<dynamic, dynamic> sessions = timetableData[day];

          return SingleChildScrollView(
          //  height: 2500,
            child: Column(
                children: [
                  Text(
                    day.toUpperCase(),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                   height: 2000,
                    child: ListView.builder(
                      shrinkWrap: true,
                    //  physics: const NeverScrollableScrollPhysics(),
                      itemCount: sessions.length,
                      itemBuilder: (context, sessionIndex) {
                        String sessionTime = sessions.keys.elementAt(sessionIndex);
                        List<dynamic> tileNames = sessions[sessionTime];
                        Color sessionColor = getColorForSession(day, sessionTime);
                                
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                              title: Column(
                                children: tileNames
                                    .map((tileName) => Text(
                                          tileName,
                                          style: const TextStyle(color: Colors.white),
                                        ))
                                    .toList(),
                              ),
                              subtitle: Text(
                                sessionTime,
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                              tileColor: sessionColor),
                        );
                      },
                    ),
                  ),
                ],
              ),
          )
          ;
        },
      ),
    );
  }
}
