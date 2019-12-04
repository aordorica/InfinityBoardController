import 'package:flutter/material.dart';

class CustomCardBox extends StatelessWidget {
  const CustomCardBox({@required this.child, @required this.cardRadius});
  final Widget child;
  final double cardRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21),
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10.0, color: Colors.black12, offset: Offset(0.0, 10.0)),
        ],
        borderRadius: BorderRadius.circular(cardRadius),
        color: Color.fromRGBO(37, 50, 68, 5),
      ),
      child: child,
    );
  }
}
