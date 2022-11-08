import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_group/cubit/add_group_cubit.dart';

class AddGroupPage extends StatelessWidget {
  const AddGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var title = '';
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Column(
          children: [
            Text("Add Group"),
            /// Title
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter something';
                } else {
                  return null;
                }
              },
              onChanged: (value) => title = value,
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AddGroupCubit>().addGroup(title);
                  }
                },
                child: Text("Save"))
          ],
        ),
      )),
    );
  }
}
