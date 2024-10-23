import 'package:flutter/material.dart';
import 'package:learning_app/features/editor/presentation/text_field_controller.dart';

class Editor extends StatelessWidget {
  Editor({super.key});
  TextFieldController controller = TextFieldController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            // keyboardType: TextInputType.multiline,
            // maxLines: null,
            controller: controller,
          )
        ],
      ),
    );
  }
}
