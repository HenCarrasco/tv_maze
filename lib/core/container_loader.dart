import 'package:flutter/material.dart';

class ContainerLoader extends StatelessWidget {
  ContainerLoader(
      {@required this.loading,
      @required this.child,
      this.opacity: 0.54,
      this.backgroundColor: Colors.white});

  final bool loading;
  final Widget child;
  final double opacity;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (!loading) return child;
    return Stack(
      children: <Widget>[
        Container(child: child),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(opacity),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
          ),
        )
      ],
    );
  }
}
