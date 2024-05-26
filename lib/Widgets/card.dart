import 'package:flutter/material.dart';

class CardE extends StatefulWidget {
  String title;
  Color backgroundColor;
  TextStyle textStyle;
  String image;

  CardE({
    Key? key,
    required this.image,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(widget.title),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
            child: Image.asset(
              widget.image,
            ),
          )
        ],
      ),
    );
  }
}
