import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  EmptyState(
      {this.icon: Icons.crop_square,
      this.text: '',
      this.child,
      Key key,
      this.isInline: false})
      : super(key: key);

  final IconData icon;
  final String text;
  final Widget child;
  bool isInline = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: this.isInline
            ? <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        icon,
                        color: Colors.black38,
                        size: 50,
                      ),
                      Container(
                        child: Align(
                          child: child != null
                              ? child
                              : Text(
                                  text,
                                  style: TextStyle(color: Colors.black54),
                                ),
                        ),
                      )
                    ])
              ]
            : <Widget>[
                Container(
                  child: Icon(
                    icon,
                    color: Colors.black38,
                    size: 50,
                  ),
                ),
                Container(
                  child: Align(
                    child: child != null
                        ? child
                        : Text(
                            text,
                            style: TextStyle(color: Colors.black54),
                          ),
                  ),
                )
              ],
      ),
    );
  }
}
