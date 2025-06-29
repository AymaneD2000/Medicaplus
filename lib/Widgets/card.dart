// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CardE extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final TextStyle textStyle;
  final String image;
  double? topEndTadius;
  double? topStartTadius;
  double? bottomStartRadius;
  double? bottomEndRadius;
  Color? textColor;
  Color? imageColor;
  Color? borderColor;

  CardE({
    Key? key,
    required this.image,
    required this.title,
    this.topEndTadius,
    this.topStartTadius,
    this.bottomEndRadius,
    this.bottomStartRadius,
    this.imageColor,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.textStyle = const TextStyle(
      fontFamily: 'TimesNewRoman',
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  }) : super(key: key);

  @override
  State<CardE> createState() => _CardEState();
}

class _CardEState extends State<CardE> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: widget.borderColor ??
                widget.backgroundColor ??
                const Color(0x0ff00000)),
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(widget.topStartTadius ?? 0),
            topEnd: Radius.circular(widget.topEndTadius ?? 0),
            bottomEnd: Radius.circular(widget.bottomEndRadius ?? 0),
            bottomStart: Radius.circular(widget.bottomStartRadius ?? 0)),
      ),
      color: widget.backgroundColor ?? const Color.fromARGB(255, 250, 213, 213),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: widget.textStyle,
              textAlign: TextAlign.center,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              height: MediaQuery.of(context).size.height * 0.1,
              widget.image,
              color: widget.imageColor,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
