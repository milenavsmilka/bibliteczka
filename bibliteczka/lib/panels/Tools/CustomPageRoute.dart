import 'package:flutter/cupertino.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final String chooseAnimation;
  // final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    required this.chooseAnimation
    // this.direction = AxisDirection.right,
  }) : super(transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => child);

  static const String SLIDE = 'SLIDE';
  static const String FADE = 'FADE';
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
    if (chooseAnimation == SLIDE) {
      return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child);
    } else if(chooseAnimation == FADE){
      return Align(
        child: FadeTransition(
            opacity: animation,
            child: child),
      );
    } else {
      return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child);
    }
  }
}
