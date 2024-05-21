import 'package:flutter/material.dart';


class SomePage extends StatelessWidget {
  const SomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
width: double.infinity,
height: double.infinity,
child: InteractiveViewer(
  constrained: false,
  scaleEnabled: true,
 
  maxScale: 5.0,
  minScale: 2.0,
 
  
   boundaryMargin:const  EdgeInsets.all(double.infinity),
   //constrained: false,
  child:   Container(
                //color: Colors.white,
                width: 1000,
                height:1000,
                //height: double.infinity,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                     
                      image: AssetImage("assets/shit.jpg"),
                      
                       fit: BoxFit.cover,
                    ),
                   ),
                /* add child content here */
              )),


    );
  }
}