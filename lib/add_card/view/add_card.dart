import "package:flutter/material.dart";

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            /// File location
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
            ),
            /// Front
            TextFormField(),
            /// Back
            TextFormField(),
            ElevatedButton(onPressed: (() {
              if(formKey.currentState!.validate()){
                
              }
            }), child: Text("Save"))
          ],
        ),
      )),
    );
  }
}
