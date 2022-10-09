import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:indgram/main.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final double width;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({Key? key, 
    required this.text, 
    required this.width, 
    required this.color,
    required this.fontSize,
    required this.fontWeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Container(
        width: width,
        alignment: Alignment.center,
        padding: EdgeInsets.all( screenWidth!*0.015 ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all( 
              Radius.circular( screenWidth!*0.02 )
             ),
          ),
          color: color,
        ),
        child: Text(text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight
          ),
        ),
      );
  }
}