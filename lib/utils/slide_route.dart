import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final Offset beginOffset;

  SlideRoute({required this.page, required this.beginOffset})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          opaque: false, // Enable transparency
          barrierColor: null, // Managed by the screen itself or set here
          barrierDismissible: false, // We handle taps manually if needed, or leave false
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = beginOffset;
            var end = Offset.zero;
            var curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
