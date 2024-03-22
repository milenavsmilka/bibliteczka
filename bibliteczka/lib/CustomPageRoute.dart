import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  // final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    // this.direction = AxisDirection.right,
  }) : super(transitionDuration: const Duration(seconds: 1),
      reverseTransitionDuration: Duration(seconds: 1),
      pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
          position:Tween<Offset>(
            begin: const Offset(1,0),
            end: Offset.zero,
      ).animate(animation),
      child: child);
}
