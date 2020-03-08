import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderCardDot extends StatelessWidget {
  Color dotColor;

  OrderCardDot({
    @required this.dotColor
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: dotColor,
        border: Border.all(
          color: dotColor == Colors.transparent ? Colors.white : Colors.transparent,
          width: 1.0
        )
      ),
    );
  }
}