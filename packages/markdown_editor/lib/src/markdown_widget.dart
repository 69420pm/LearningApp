import 'package:flutter/material.dart';

class MarkdownWidget extends StatefulWidget {
  const MarkdownWidget({super.key});

  @override
  State<MarkdownWidget> createState() => _MarkdownWidgetState();
}

class _MarkdownWidgetState extends State<MarkdownWidget> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: []),
    );
  }
}

/// # heading 1
/// ## heading 2
/// ### heading 3
/// #### heading 4
/// ##### heading 5
/// ###### heading 6
/// - / + / * unordered list
/// > quotes
/// [link] (href) links
/// ''' code '''
/// | tables | column 2
/// --- hr
/// 1. ordered list
/// $ latex
/// \** bold **
/// \* italic *
/// text color
