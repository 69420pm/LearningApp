// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:ui_components/ui_components.dart';

// class UITextButton extends StatefulWidget {
//   const UITextButton({
//     super.key,
//     required this.text,
//     required this.style,
//     required this.onPressed,
//     this.alignment = Alignment.center,
//     this.animateToWhite = false,
//   });

//   /// text next to icon
//   final String text;

//   /// style for [text]
//   final TextStyle style;

//   /// callback when button gets pressed
//   final void Function() onPressed;

//   /// how icon should be aligned in container
//   final Alignment alignment;

//   /// whether the icon should lighten up or darken
//   final bool animateToWhite;

//   @override
//   State<UITextButton> createState() => _UIIconButtonState();
// }

// class _UIIconButtonState extends State<UITextButton> {
//   bool isIconColored = false;

//   @override
//   Widget build(BuildContext context) {
//     final startColor = widget.style.color ?? Colors.white;
//     final animateColor = Color.fromARGB(
//       128,
//       startColor.red,
//       startColor.blue,
//       startColor.green,
//     );
//     return Container(
//       height: 44,
//       alignment: Alignment.center,
//       child: GestureDetector(
//         onTap: widget.onPressed,
//         behavior: HitTestBehavior.opaque,
//         onTapDown: (details) {
//           setState(() {
//             isIconColored = true;
//           });
//         },
//         onTapCancel: () {
//           setState(() {
//             isIconColored = false;
//           });
//         },
//         onTapUp: (details) {
//           setState(() {
//             isIconColored = false;
//           });
//         },
//         // ! this container doesn't get displayed, probably bug of flutter_animate
//         child: Container(
//           height: 44,
//           width: 44,
//           alignment: widget.alignment,
//         )
//             .animate(
//               target: isIconColored ? 1 : 0,
//             )
//             .custom(
//               duration: 50.ms,
//               builder: (context, value, child) {
//                 return Text(
//                   widget.text,
//                   style: widget.style.copyWith(
//                     color: Color.lerp(startColor, animateColor, value),
//                   ),
//                 );
//               },
//             ),
//       ),
//     );
//   }
// }
