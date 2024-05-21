import 'package:flutter/rendering.dart';
import 'package:nit_avros/components/custom_container.dart';
import 'package:nit_avros/pages/venue_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _scale = 2.0;
  double _rotation = 0.0;
  double newq = 0.0;
  double oldq = 0.0;
  //Initialization of Firebase datasets
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('timetable');
  DatabaseReference occupiedRef =
      FirebaseDatabase.instance.ref().child('occupiedVenues');
  DatabaseReference releaseddRef =
      FirebaseDatabase.instance.ref().child('releasedVenues');

  Map<String, dynamic> timetableData1 = {};
  // List<String> releasedVenues = [];
  // List<String> occupiedVenue = [];
  Map<String, dynamic> occupiedVenueList = {};
  Map<String, dynamic> releasedVenuesList = {};
  //seting up of the page initatial state and updates

  @override
  void initState() {
    super.initState();
    _database.onValue.listen((event) {
      setState(() {
        timetableData1 = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        //updateVenueStatus();
      });
    });
    updateOccupiedVenue();
    updateReleasedVenenues();

    occupiedRef.onChildRemoved.listen((event) {
      // Handle item deletion
      setState(() {
        updateOccupiedVenue();
      });
    });

    releaseddRef.onChildRemoved.listen((event) {
      setState(() {
        updateReleasedVenenues();
      });
    });
  }

//function to add venue to occupiedRef

  void _addVenueToOccupied(
      BuildContext context, String VenueId, Color VenueColor) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Are you sure you want to occupie selected venue?'),
        action: SnackBarAction(
            label: 'OCCUPIE',
            onPressed: () {
              if (VenueColor == Colors.green) {
                occupiedRef.push().set(VenueId);

                occupiedRef.onValue.listen((event2) {
                  setState(() {
                    occupiedVenueList = Map<String, dynamic>.from(
                        event2.snapshot.value as Map<dynamic, dynamic>);
                    // occupiedVenueList.forEach((key, value) {
                    //   occupiedVenue.add(value.toString());
                    // });
                  });
                });

                print(occupiedVenueList);
              } else {
                scaffold.showSnackBar(
                  SnackBar(
                    content: const Text("venue already occupied"),
                  ),
                );

                // print("already occupied");
              }
            }),
      ),
    );
  }

  void updateOccupiedVenue() {
    occupiedRef.once().then((event) {
      final datasnapshot = event.snapshot;
      if (datasnapshot.value != null) {
        Map<dynamic, dynamic> data =
            datasnapshot.value as Map<dynamic, dynamic>;
        setState(() {
          occupiedVenueList = Map<String, dynamic>.from(data);
          // occupiedVenueList.forEach((key, value) {
          // //  occupiedVenue.add(value.toString());
          // });
        });
      } else {
        setState(() {
          occupiedVenueList.clear();
        });
      }
    }).catchError((error) {
      print("Error retrieving occupied venues data: $error");
    });
  }

  bool occupied(String VenueNameOccupied, int sessEnd) {
    DateTime now = DateTime.now();
    int currentHour = now.hour * 100 + now.minute;

    Future<void> removeItems() async {
      if (currentHour > sessEnd) {
        // DatabaseReference occupiedRef =
        // FirebaseDatabase.instance.ref().child('occupiedVenues');
        await occupiedRef.child(VenueNameOccupied).remove().then((value) {
          print("Venue $VenueNameOccupied removed from occupied venues");
          occupiedRef.onValue.listen((event4) {
            setState(() {
              occupiedVenueList = Map<String, dynamic>.from(
                  event4.snapshot.value as Map<dynamic, dynamic>);
            });
          });
        });
      }
    }

    return occupiedVenueList.containsValue(VenueNameOccupied);
  }

  void updateReleasedVenenues() {
    releaseddRef.once().then((eventY) {
      final datasnapshot = eventY.snapshot;
      if (datasnapshot.value != null) {
        Map<dynamic, dynamic> data =
            datasnapshot.value as Map<dynamic, dynamic>;
        setState(() {
          releasedVenuesList = Map<String, dynamic>.from(data);
        });
      } else {
        setState(() {
          releasedVenuesList.clear();
        });
      }
    }).catchError((error) {
      print("Error retrieving occupied venues data: $error");
    });
  }

  bool released(String venueNameR) {
    return releasedVenuesList.containsValue(venueNameR);
  }

  void _addVenueToReleased(
      BuildContext context, String VenueId, Color VenueColor) {
    //releaseddRef.push().set(VenueId);
//  releaseddRef.onValue.listen((eventX) {
//       setState(() {
//         releasedVenuesList = Map<String, dynamic>.from(
//             eventX.snapshot.value as Map<dynamic, dynamic>);
//         // occupiedVenueList.forEach((key, value) {
//         //   occupiedVenue.add(value.toString());
//         // });
//       });
//     });
//     print(releasedVenuesList);

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Are you sure you want to Release selected venue?'),
        action: SnackBarAction(
            label: 'RELEASE',
            onPressed: () {
              if (VenueColor == Colors.red) {
                releaseddRef.push().set(VenueId);

                releaseddRef.onValue.listen((eventX) {
                  setState(() {
                    releasedVenuesList = Map<String, dynamic>.from(
                        eventX.snapshot.value as Map<dynamic, dynamic>);
                    // occupiedVenueList.forEach((key, value) {
                    //   occupiedVenue.add(value.toString());
                    // });
                  });
                });

                print(releasedVenuesList);
              } else {
                scaffold.showSnackBar(
                  SnackBar(
                    content: const Text("venue already released"),
                  ),
                );

                // print("already occupied");
              }
            }),
      ),
    );
  }

  // void addVenueToOccupied(String VenueId) {
  //   occupiedRef.push().set(VenueId);

  //   occupiedRef.onValue.listen((event2) {
  //     setState(() {
  //       occupiedVenueList = Map<String, dynamic>.from(
  //           event2.snapshot.value as Map<dynamic, dynamic>);
  //       // occupiedVenueList.forEach((key, value) {
  //       //   occupiedVenue.add(value.toString());
  //       // });
  //     });
  //   });

  //   print(occupiedVenueList);
  // }

  Color checkSessionForName(String Vname) {
    //CHECK CURRENT HOUR AND DAY
    DateTime now = DateTime.now();
    String currentDay = DateFormat('EEEE').format(now).toLowerCase();
    int currentHour = now.hour * 100 + now.minute;

    if (timetableData1.containsKey(currentDay)) {
      Map<dynamic, dynamic> currentDaySessions = timetableData1[currentDay];
      //  print(currentDaySessions.keys);

      for (int i = 0; i < currentDaySessions.length; i++) {
        //print(currentDaySessions.keys.elementAt(i));
        String sessTime = currentDaySessions.keys.elementAt(i);
        List<String> mySessionPrts = sessTime.split('-');
        int mySessionStrt = int.parse(mySessionPrts[0]);
        int mySessionEnd = int.parse(mySessionPrts[1]);

        //print(mySessionPrts[0] +" to "+ mySessionPrts[1] + currentHour.toString());
        // print(mySessionStrt);
        if (currentHour > mySessionStrt && currentHour < mySessionEnd) {
          List<dynamic> venueList = currentDaySessions[sessTime];
          //  print(venueList);

          if (venueList.contains(Vname) && !released(Vname) ||
              occupied(Vname, mySessionEnd)) {
            return Colors.red;
          } else if (released(Vname) && currentHour < mySessionEnd) {
            return Colors.green;
          }
        }

        //  test(currentDaySessions[i]);
      }
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "NIT VENUES STATUS",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 75,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: () {
              //  print(timetableData1.keys);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VenueData(),
                ),
              );
              //   _showToast(context);
            },
            child: const Text("Timetable"),
          ),
        ),
      ),
      body: Container(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(double.infinity),
          // boundaryMargin: EdgeInsets.all(20.0),
          constrained: false,
          minScale: 0.0001,
          //  maxScale: 4.0,
          // scaleEnabled: true,

          // // transformationController: TransformationController(),
          onInteractionStart: (_) {
            // //   // Store the current scale when the interaction starts

            setState(() {
              // //     // _scale = details.scale;
              //    _scale = TransformationController().value.getMaxScaleOnAxis();
              _rotation = oldq;
            });
            print("on start " + _rotation.toString());
          },
          onInteractionUpdate: (ScaleUpdateDetails details) {
            _scale = TransformationController().value.getMaxScaleOnAxis();

            setState(() {
              //  _scale = TransformationController().value.getMaxScaleOnAxis();
              newq = details.rotation;
              _scale = details.scale;
              _rotation = details.rotation;
            });
          },
          onInteractionEnd: (details) {
            // Store the current rotation angle when interaction ends
            setState(() {
              oldq = newq;
              print("on end " + oldq.toString());
            });
          },
          child: Transform.rotate(
            angle: _rotation,
            child: Container(
              child: Stack(
                children: [
                  Container(
                    //color: Colors.white,
                    width: 1200,

                    height: 2000,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/VNS.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    /* add child content here */
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 108,
                    height: 44,
                    leftp: 175,
                    color: checkSessionForName(
                      "B14LR02",
                    ),
                    topP: 1,
                    name: 'B14LR02',
                    onTripleTap: () {
                      //  addNametoOcc(checkSessionForName("B14LR04"), "B14LR04");

                      if (checkSessionForName("B14LR02") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B14LR02",
                          checkSessionForName("B14LR02"),
                        );
                      } else {
                        _addVenueToReleased(
                            context, "B14LR02", checkSessionForName("B14LR02"));
                      }
                    },
                  ),
                  CustomVenue(
                      borderRadius: BorderRadius.circular(1),
                      width: 114,
                      height: 44,
                      leftp: 60,
                      color: checkSessionForName(
                        "B14LR03",
                      ),
                      topP: 1,
                      name: 'B14LR03',
                      onTripleTap: () {
                        if (checkSessionForName("B14LR03") == Colors.green) {
                          _addVenueToOccupied(
                            context,
                            "B14LR02",
                            checkSessionForName("B14LR03"),
                          );
                        } else {
                          _addVenueToReleased(context, "B14LR03",
                              checkSessionForName("B14LR02"));
                        }
                      }),

                  CustomVenue(
                      borderRadius: BorderRadius.circular(1),
                      width: 150,
                      height: 46,
                      leftp: 60,
                      color: checkSessionForName('B13LR02'),
                      topP: 90,
                      name: 'B13LR02',
                      onLongPress: () {
                        if (checkSessionForName("B13LR02") == Colors.green) {
                          _addVenueToOccupied(
                            context,
                            "B13LR02",
                            checkSessionForName("B13LR02"),
                          );
                        } else {
                          _addVenueToReleased(context, "B13LR02",
                              checkSessionForName("B13LR02"));
                        }
                      }),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 170,
                    height: 46,
                    leftp: 198,
                    color: checkSessionForName("B13LR01"),
                    topP: 90,
                    name: 'B13LR01',
                    onTripleTap: () {
                      if (checkSessionForName("B13LR01") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B13LR01",
                          checkSessionForName("B13LR01"),
                        );
                      } else {
                        _addVenueToReleased(
                            context, "B13LR01", checkSessionForName("B14LR02"));
                      }
                    },
                  ),
                  //BLOCK 15 RIGHT WING
                  // CustomVenue(
                  //   borderRadius: BorderRadius.circular(1),
                  //   width: 95,
                  //   height: 34,
                  //   leftp: 230,
                  //   color: Colors.orange,
                  //   topP: 565,
                  //   name: 'Bl 15',
                  //   onLongPress: () {},
                  // ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 44,
                    leftp: 275,
                    color: checkSessionForName("B15RWF04"),
                    topP: 603,
                    name: 'B15RWF04',
                    onTripleTap: () {
                      if (checkSessionForName("B15RWF04") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15RWF04",
                          checkSessionForName("B15RWF04"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15RWF04",
                            checkSessionForName("B15RWF04"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 275,
                    color: checkSessionForName("B15RWF03"),
                    topP: 650,
                    name: 'B15RWF03',
                    onTripleTap: () {
                      if (checkSessionForName("B15RWF03") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15RWF03",
                          checkSessionForName("B15RWF03"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15RWF03",
                            checkSessionForName("B15RWF03"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 275,
                    color: checkSessionForName("B15RWF02"),
                    topP: 695,
                    name: 'B15RWF02',
                    onTripleTap: () {
                      if (checkSessionForName("B15RWF02") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15RWF02",
                          checkSessionForName("B15RWF022"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15RWF02",
                            checkSessionForName("B15RWF02"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 275,
                    color: checkSessionForName("B15LGFB"),
                    topP: 740,
                    name: 'B15LGFB',
                  onTripleTap: () {
                      if (checkSessionForName("B15LGBF") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15LGBF",
                          checkSessionForName("B15LGBF"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15LGBF",
                            checkSessionForName("B15LGBF"));
                      }
                    }
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 275,
                    color: Colors.green,
                    topP: 785,
                    name: 'Bl 15',
                    onTripleTap: () {
                      if (checkSessionForName("B15R") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15R",
                          checkSessionForName("B15R"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15R",
                            checkSessionForName("B15"));
                      }
                    },
                  ),
                  //BLOCK 15 LEFT WING FROM BOTTOM
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 185,
                    color: Colors.green,
                    topP: 785,
                    name: 'B15',
                    onTripleTap: () {
                      if (checkSessionForName("B1") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15R",
                          checkSessionForName("B15"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15R",
                            checkSessionForName("B1"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 185,
                    color: checkSessionForName("B15LGF"),
                    topP: 740,
                    name: 'B15LGF',
                    onTripleTap: () {
                      if (checkSessionForName("B15LGF") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15LGF",
                          checkSessionForName("B15LGF"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15LGF",
                            checkSessionForName("B15LGF"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 185,
                    color: checkSessionForName("B15LWF02"),
                    topP: 695,
                    name: 'B15LWF02',
                    onTripleTap: () {
                      if (checkSessionForName("B15LWF02") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15LWF02",
                          checkSessionForName("B15LWF02"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15LWF02",
                            checkSessionForName("B15LWF02"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 185,
                    color: checkSessionForName("B15LWF03"),
                    topP: 650,
                    name: 'B15LWF03',
                   onTripleTap: () {
                      if (checkSessionForName("B15LWF03") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15LWF03",
                          checkSessionForName("B15LWF03"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15LWF03",
                            checkSessionForName("B15LWF03"));
                      }
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 82,
                    height: 42,
                    leftp: 185,
                    color: checkSessionForName("B15LWF4"),
                    topP: 605,
                    name: 'B15LWF04',
                    onTripleTap: () {
                      if (checkSessionForName("B15LWF04") == Colors.green) {
                        _addVenueToOccupied(
                          context,
                          "B15LWF04",
                          checkSessionForName("B15LWF04"),
                        );
                      } else {
                        _addVenueToReleased(context, "B15LWF04",
                            checkSessionForName("B15LWF04"));
                      }
                    }
                    //MWISHO WA BLCK WA BLCK 5 LEFT WING
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 95,
                    height: 43,
                    leftp: 284,
                    color: checkSessionForName(
                      "B14LR02",
                    ),
                    topP: 1,
                    name: 'B14LR02',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 112,
                    height: 45,
                    leftp: 687,
                    color: checkSessionForName(
                      "B18LR01",
                    ),
                    topP: 1,
                    name: 'B18LR01',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 113,
                    height: 44,
                    leftp: 805,
                    color: checkSessionForName(
                      "B19LR01",
                    ),
                    topP: 1,
                    name: 'B19LR01',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 120,
                    height: 46,
                    leftp: 920,
                    color: checkSessionForName('CLASSIV'),
                    topP: 270,
                    name: 'CLASSIV',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 106,
                    leftp: 1055,
                    color: checkSessionForName(
                      "CLASSV",
                    ),
                    topP: 1,
                    name: 'CLASSV',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 112,
                    height: 46,
                    leftp: 923,
                    color: checkSessionForName(
                      "B20LR01",
                    ),
                    topP: 1,
                    name: 'B20LR01',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 100,
                    leftp: 1055,
                    color: checkSessionForName(
                      "CLASSVI",
                    ),
                    topP: 110,
                    name: 'CLASSVI',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 100,
                    leftp: 1057,
                    color: checkSessionForName(
                      "CLASSVII",
                    ),
                    topP: 210,
                    name: 'CLASSVII',
                    onLongPress: () {
                      // print("WHEHEEW");
                    },
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 110,
                    height: 50,
                    leftp: 805,
                    color: checkSessionForName('CLASSIII'),
                    topP: 270,
                    name: 'CLASSIII',
                    onLongPress: () {
                      _addVenueToReleased(
                          context, "CLASSIII", checkSessionForName("CLASSIII"));
                    },
                  ),

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 112,
                    height: 50,
                    leftp: 687,
                    color: checkSessionForName('CLASSII'),
                    topP: 270,
                    name: 'CLASSII',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 113,
                    height: 50,
                    leftp: 571,
                    color: checkSessionForName('CLASSI'),
                    topP: 270,
                    name: 'CLASSI',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 60,
                    height: 150,
                    leftp: 1060,
                    color: checkSessionForName('B16LR01'),
                    topP: 1090,
                    name: 'B16LR01',
                    onLongPress: () {},
                  ),

                  //LEFT SIDE WORKSHOPS
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 120,
                    leftp: 90,
                    color: Colors.blue,
                    topP: 855,
                    name: 'Bl 15',
                    onLongPress: () {},
                  ),

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 129,
                    leftp: 89,
                    color: Colors.red,
                    topP: 975,
                    name: 'Bl 15',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 150,
                    leftp: 90,
                    color: Colors.green,
                    topP: 1105,
                    name: 'Bl 15',
                    onLongPress: () {},
                  ),

                  //MIDDLE CLASSES

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 80,
                    leftp: 361,
                    color: Colors.green,
                    topP: 880,
                    name: 'Bl 15',
                    onLongPress: () {},
                  ),

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 80,
                    leftp: 361,
                    color: Colors.greenAccent,
                    topP: 961,
                    name: 'Bl 15',

                    // onLongPress: () {},
                  ),
                  //BLOCK 06

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 220,
                    height: 50,
                    leftp: 270,
                    color: checkSessionForName('B06'),
                    topP: 1305,
                    name: 'B06',
                    // onLongPress: () {
                    //   // addNameToList('B06');
                    // },
                    onTripleTap: () {
                      _addVenueToOccupied(
                          context, "B06", checkSessionForName('B06'));
                      occupiedVenueList.forEach((key, value) {
                        print(value);
                        print('double');
                      });
                    },
                  ),

                  //B12 AND CLASS VIII
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 49,
                    height: 110,
                    leftp: 34,
                    color: Colors.green,
                    topP: 1382,
                    name: 'B12',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 52,
                    height: 110,
                    leftp: 34,
                    color: Colors.blue,
                    topP: 1495,
                    name: 'CLASSVIII',
                    onLongPress: () {},
                  ),

                  //BLOCK 2 LECTURE ROOMS
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 90,
                    leftp: 410,
                    color: Colors.pink,
                    topP: 1415,
                    name: 'B02LR02',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 90,
                    leftp: 460,
                    color: Colors.red,
                    topP: 1415,
                    name: 'B02LR04',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 90,
                    leftp: 410,
                    color: Colors.blue,
                    topP: 1515,
                    name: 'B02LR06',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 90,
                    leftp: 465,
                    color: Colors.greenAccent,
                    topP: 1515,
                    name: 'B02LR08',
                    onLongPress: () {},
                  ),

                  //LEFT SIDE
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 85,
                    leftp: 465,
                    color: Colors.green,
                    topP: 1700,
                    name: 'B02LR01',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 85,
                    leftp: 415,
                    color: Colors.orange,
                    topP: 1700,
                    name: 'B02LR03',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 85,
                    leftp: 465,
                    color: Colors.purple,
                    topP: 1607,
                    name: 'B02LR05',
                    onLongPress: () {},
                  ),
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 50,
                    height: 90,
                    leftp: 415,
                    color: Colors.yellow,
                    topP: 1607,
                    name: 'B02LR07',
                    onLongPress: () {},
                  ),

                  //BLOCK 03
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 100,
                    height: 45,
                    leftp: 395,
                    color: Colors.green,
                    topP: 1798,
                    name: 'B03LR01',
                    onLongPress: () {},
                  ),

                  //BLOCK 04
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 110,
                    height: 45,
                    leftp: 225,
                    color: Colors.red,
                    topP: 1818,
                    name: 'B04LR01',
                    onLongPress: () {},
                  ),

                  //BLOCK 05
                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 110,
                    height: 53,
                    leftp: 59,
                    color: Colors.yellow,
                    topP: 1780,
                    name: 'B05LR01',
                    onLongPress: () {},
                  ),

                  CustomVenue(
                    borderRadius: BorderRadius.circular(1),
                    width: 250,
                    height: 70,
                    leftp: 45,
                    color: checkSessionForName("MPH01B22"),
                    topP: 1918,
                    name: 'MPH01B22',
                    onTripleTap: () {
                      //   addVenueToOccupied('Bsmth');
                      //occupiedVenueList.forEach((key, value) {});
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
