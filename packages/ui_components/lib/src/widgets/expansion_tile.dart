// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material/material.dart';
import 'package:ui_components/ui_components.dart';

class UIExpansionTile extends StatefulWidget {
  List<Widget> children;
  Text title;
  double titleSpacing;
  double iconSpacing;
  Widget trailing;
  Color backgroundColor;
  Border border;

  UIExpansionTile({
    super.key,
    required this.children,
    required this.title,
    required this.titleSpacing,
    required this.iconSpacing,
    required this.trailing,
    required this.backgroundColor,
    required this.border,
  });

  @override
  State<UIExpansionTile> createState() => _UIExpansionTileState();
}

class _UIExpansionTileState extends State<UIExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isOpened = false;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: _key,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(UIConstants.cornerRadius),
        ),
        color: widget.backgroundColor,
        border: widget.border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: update,
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Row(
                children: [
                  SizedBox(width: widget.iconSpacing),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) {
                      return Transform.rotate(
                          angle: pi * _animation.value,
                          child: Icon(Icons.expand_more));
                    },
                  ),
                  SizedBox(width: widget.titleSpacing),
                  widget.title,
                  const Spacer(),
                  widget.trailing,
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.only(
                right: UIConstants.defaultSize,
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => widget.children[index],
                itemCount: widget.children.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void update() {
    setState(() {
      _isOpened = !_isOpened;
    });
    if (_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
