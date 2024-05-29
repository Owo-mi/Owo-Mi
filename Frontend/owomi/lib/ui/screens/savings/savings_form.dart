import 'package:flutter/material.dart';
import 'package:owomi/common_libs.dart';

class SavingsFormScreen extends StatefulWidget {
  String? savingType;
  String? savingName;

  SavingsFormScreen({super.key, this.savingType, this.savingName});

  @override
  State<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends State<SavingsFormScreen> {
  final formKey = GlobalKey<FormState>();

  Widget form() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Name Required";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
            validator: (value) {
              if (value!.trim().isEmpty) {
                return "Name Required";
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                print("The form is valid");
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.savingName ?? ""),
      ),
      body: form(),
    );
  }
}
