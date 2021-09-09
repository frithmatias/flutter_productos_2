import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {

  final Widget child;
  const CardContainer(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: _cardShape(),
        child: this.child
      ),
    );
  }

  BoxDecoration _cardShape() => BoxDecoration(  
    color: Colors.white,
    borderRadius: BorderRadius.circular(10), 
    boxShadow: [  
      BoxShadow(  
        color: Colors.black26, 
        blurRadius: 10, 
        offset: Offset(0,3)
      ) 
    ]
  );
}