// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
final controller;
final String myText;
final bool obscu;


  const MyTextField({super.key,
  required this.controller,
   required this.myText, 
   required this.obscu});

  @override
  Widget build(BuildContext context) {

    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                controller: controller,
                obscureText: obscu,
                  decoration: InputDecoration(
                     enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                      focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),fillColor:const Color.fromARGB(255, 243, 238, 238),
                  filled: true,
                  hintText: myText,
                  ),
                  
                ),
              );

              
  }

  
}