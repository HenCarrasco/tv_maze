import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  SearchTextField({Key key, @required this.hintText, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
        height: 30,
        child: TextFormField(
          key: Key("search"),
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(-15, 0, 0, 0),
            filled: true,
            hintText: hintText,
            //fillColor: primaryColor,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
              size: 25,
            ),
            hintStyle: TextStyle(color: Colors.white, fontSize: 14),
          ),
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ));
  }
}
