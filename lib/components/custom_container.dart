
import 'package:flutter/material.dart';

class CustomVenue extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final BorderRadius borderRadius;
  final double leftp;
  final double topP;
  final String name;
   final Function? onLongPress;
final Function? onTripleTap;
final Function? onTap;

  const CustomVenue(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.borderRadius,
      required this.leftp,
      required this.topP,
      required this.name,
      this.onLongPress,
      this.onTripleTap,
      this.onTap
     
      });

  @override
  State<CustomVenue> createState() => _CustomVenueState();
}

class _CustomVenueState extends State<CustomVenue> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.leftp,
      top: widget.topP,
    
        child: GestureDetector(
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: widget.borderRadius,
              
            ),
            child: Text(widget.name,style: const TextStyle(color: Colors.white,fontSize: 8),),
          ),
          onLongPress: widget.onLongPress as void Function()?,
          onTap: widget.onTripleTap as void Function()?
        ),
        
      
    );
  }
}
