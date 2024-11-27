import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
 final Widget child;
 final AxisDirection direction;

  CustomPageRoute({
     this.direction =AxisDirection.right, 
    required this.child,
  }) : super(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => child);

 @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
   return SlideTransition(
    position: Tween<Offset>(
   begin: getBegainOffset(),
   end: Offset.zero
    ).animate(animation),
    child: child);
  }
  
 Offset getBegainOffset() {
    switch(direction){
      case AxisDirection.left :
       return const Offset(0, -1);
      case AxisDirection.right :
       return const Offset(-1, 0);
      case AxisDirection.up  :
       return const Offset(0, 1);
      case AxisDirection.down :
       return const Offset(1, 0);
    }
  }
}

