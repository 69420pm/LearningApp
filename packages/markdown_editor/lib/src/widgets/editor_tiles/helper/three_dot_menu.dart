import 'package:flutter/material.dart';

class ThreeDotMenu extends StatelessWidget {
  ThreeDotMenu({super.key, required this.onPressed});
  Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      child: Center(
          child: IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 20,
              ),
              onPressed: ()=>onPressed.call())),
    );
  }
}
