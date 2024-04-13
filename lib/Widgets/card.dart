import 'package:flutter/material.dart';

class CardE extends StatefulWidget {
  String title;
  Color backgroundColor;
  TextStyle textStyle;

  CardE({
    Key? key,
    required this.title,
    this.backgroundColor = const Color.fromARGB(255, 250, 213, 213),
    this.textStyle = const TextStyle(color: Colors.black),
  }) : super(key: key);

  @override
  State<CardE> createState() => _CardEState();
}

class _CardEState extends State<CardE> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.backgroundColor,
      child: Center(
        child: Text(
          widget.title,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
