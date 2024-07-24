import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nit_avros/components/booking_box.dart';
import 'package:nit_avros/pages/home_page.dart';
import 'package:nit_avros/pages/venue_data.dart';

class SomePage extends StatefulWidget {
  const SomePage({Key? key}) : super(key: key);

  @override
  _SomePageState createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> {
 final venueT = TextEditingController();
 final timeT  = TextEditingController();
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Welcome To NIT AVROS",
          style: TextStyle(
              color: Color.fromARGB(255, 241, 237, 237), fontSize: 22),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                "NIT AVROS",
                style: TextStyle(
                    color: Color.fromARGB(255, 44, 43, 43), fontSize: 22),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Venue status"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("TimeTable"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VenueData()));
              },
            ),
             ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("BOOK VENUE"),
              onTap: () {
                 showDialog(
      context: context,
      builder: (context) {
        return BookingBox(
        venueCon: venueT,
        timeCon: timeT,
        BookFunc: () async{
          //bookingRef.child(timeT.text).set(venueT);
            DateTime now = DateTime.now();
            String currentDay = DateFormat('EEEE').format(now).toLowerCase();

             try {
     // DatabaseReference mondayRef = databaseRef.child('timetable/monday/0700-0800');

      DatabaseReference bookingRef =
      FirebaseDatabase.instance.ref().child('timetable/$currentDay/');
    // String? newKey = bookingRef.key;
    //  if (newKey != null){
      await bookingRef.update({
        "${timeT.text}" :
   ["${venueT.text}"]}
      );
      print('Item added successfully');
    } catch (e) {
      print('Failed to add item: $e');
    }
        },
        );
      },
    );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          child: Image(
            image: AssetImage("assets/logo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
