import 'package:flutter/cupertino.dart';

class IconsAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;

  const IconsAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
  });

  @override
  _IconsAnimationState createState() => _IconsAnimationState();
}

class _IconsAnimationState extends State<IconsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: halfDuration));

    scale = Tween<double>(begin: 1,end:1.2).animate(controller);
  }


  @override
  void didUpdateWidget(IconsAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating != oldWidget.isAnimating){
      doAnimation();
    }
  }

  Future doAnimation() async {
    await controller.forward();
    await controller.reverse();

    if(widget.onEnd !=null){
      widget.onEnd!();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: scale,
    child: widget.child,
  );
}
