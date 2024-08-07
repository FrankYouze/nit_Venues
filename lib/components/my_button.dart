import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
final Function()? onTap;
final String string;

  const MyButton({super.key, required this.onTap, required this.string});

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
    onTap: onTap,child: 
     Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
      child:  Center(
        child: Text(string,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
        
      ),
      ),
    ));
  }
}
