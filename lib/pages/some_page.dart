import 'package:flutter/material.dart';
import 'package:nit_avros/pages/home_page.dart';
import 'package:nit_avros/pages/venue_data.dart';

class SomePage extends StatefulWidget {
  const SomePage({Key? key}) : super(key: key);

  @override
  _SomePageState createState() => _SomePageState();
}

class _SomePageState extends State<SomePage> {
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
