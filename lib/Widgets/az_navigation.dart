// import 'package:flutter/material.dart';

// class AZNavigation extends StatefulWidget {
//   final Function(String) onLetterSelected;
//   final Color backgroundColor;
//   final Color selectedColor;
//   final Color textColor;
//   final Color selectedTextColor;
//   final double itemSize;
//   final double itemPadding;

//   const AZNavigation({
//     Key? key,
//     required this.onLetterSelected,
//     this.backgroundColor = Colors.grey,
//     this.selectedColor = Colors.blue,
//     this.textColor = Colors.white,
//     this.selectedTextColor = Colors.white,
//     this.itemSize = 20,
//     this.itemPadding = 2,
//   }) : super(key: key);

//   @override
//   State<AZNavigation> createState() => _AZNavigationState();
// }

// class _AZNavigationState extends State<AZNavigation> {
//   String? selectedLetter;

//   final List<String> letters = [
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//     'F',
//     'G',
//     'H',
//     'I',
//     'J',
//     'K',
//     'L',
//     'M',
//     'N',
//     'O',
//     'P',
//     'Q',
//     'R',
//     'S',
//     'T',
//     'U',
//     'V',
//     'W',
//     'X',
//     'Y',
//     'Z'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.itemSize + widget.itemPadding * 2,
//       constraints: BoxConstraints(
//         maxHeight: MediaQuery.of(context).size.height *
//             0.6, // Limit height to 60% of screen
//         minHeight: widget.itemSize * 8, // Minimum height for visibility
//       ),
//       decoration: BoxDecoration(
//         color: widget.backgroundColor.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(
//             (widget.itemSize + widget.itemPadding * 2) / 2),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: letters.map((letter) {
//             final isSelected = selectedLetter == letter;
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: widget.itemPadding),
//               child: GestureDetector(
//                 onTapDown: (_) {
//                   setState(() {
//                     selectedLetter = letter;
//                   });
//                   widget.onLetterSelected(letter);
//                 },
//                 onTapUp: (_) {
//                   setState(() {
//                     selectedLetter = null;
//                   });
//                 },
//                 onTapCancel: () {
//                   setState(() {
//                     selectedLetter = null;
//                   });
//                 },
//                 child: Container(
//                   width: widget.itemSize,
//                   height: widget.itemSize,
//                   decoration: BoxDecoration(
//                     color:
//                         isSelected ? widget.selectedColor : Colors.transparent,
//                     borderRadius: BorderRadius.circular(widget.itemSize / 2),
//                   ),
//                   child: Center(
//                     child: Text(
//                       letter,
//                       style: TextStyle(
//                         color: isSelected
//                             ? widget.selectedTextColor
//                             : widget.textColor,
//                         fontSize: widget.itemSize * 0.6,
//                         fontWeight:
//                             isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AZNavigation extends StatelessWidget {
  final void Function(String) onLetterSelected;
  final Set<String> availableLetters;
  final Color activeColor;
  final Color inactiveColor;
  final double itemSize;

  const AZNavigation({
    super.key,
    required this.onLetterSelected,
    required this.availableLetters,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.itemSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final letters =
        List.generate(26, (index) => String.fromCharCode(65 + index));

    return Container(
      width: itemSize + 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(itemSize / 2),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: letters.length,
        itemBuilder: (context, index) {
          final letter = letters[index];
          final isAvailable = availableLetters.contains(letter);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isAvailable ? () => onLetterSelected(letter) : null,
            child: Container(
              height: itemSize,
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  fontSize: itemSize * 0.7,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? activeColor : inactiveColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
