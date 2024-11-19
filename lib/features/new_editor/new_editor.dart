import 'package:flutter/material.dart';

class NewEditor extends StatelessWidget {
  NewEditor({super.key});
  TextEditingController controller = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  // keyboardType: TextInputType.multiline,
                  // maxLines: null,
                  focusNode: focusNode1,
                  onSubmitted: (value) {
                    focusNode2.requestFocus();
                  },
                ),
              ),
              Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  focusNode: focusNode2,
                ),
              ),
            ],
          ),
          EditableText(
              maxLines: null,
              controller: controller,
              focusNode: FocusNode(),
              style: TextStyle(),
              cursorColor: Colors.blue,
              backgroundCursorColor: Colors.green),
        ],
      )),
    );
  }
}
