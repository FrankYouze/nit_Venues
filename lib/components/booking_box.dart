import 'package:flutter/material.dart';
import 'package:nit_avros/components/my_button.dart';
import 'package:nit_avros/components/my_textfield.dart';

class BookingBox extends StatelessWidget {
  final Function ()? BookFunc;
  final TextEditingController venueCon;
  final TextEditingController timeCon;
  const BookingBox({super.key, this.BookFunc, required this.venueCon, required this.timeCon});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 350,
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("VENUE BOOKING"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Enter venue name"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                  controller: venueCon,
                  myText: "Eg. B14LR02",
                  obscu: false),
            ),
            Text("Enter session time"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyTextField(
                  controller: timeCon,
                  myText: "eg 1200-1500",
                  obscu: false),
            ),

                MyButton(onTap: BookFunc,string: "Submit",)
          ],
        ),
      ),
    );
  }
}
