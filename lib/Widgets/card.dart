import 'package:flutter/material.dart';

class CardE extends StatefulWidget {
  final String title;
  final Color? backgroundColor;
  final TextStyle textStyle;
  final String image;
  Color? textColor;
  Color? imageColor;
  Color? borderColor;

  CardE({
    Key? key,
    required this.image,
    required this.title,
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: widget.borderColor??widget.backgroundColor??const Color(0x0ff00000)),
          borderRadius: BorderRadius.circular(16),
        ),
        color: widget.backgroundColor??const Color.fromARGB(255, 250, 213, 213),
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
      ),
    );
  }
}
