import 'package:flutter/material.dart';

class EditDialog extends StatelessWidget {
  final String title;
  final String initialValue;
  final String labelText;
  final TextInputType inputType;
  final ValueChanged<String> onSave;

  const EditDialog({
    required this.title,
    required this.initialValue,
    required this.labelText,
    required this.inputType,
    required this.onSave,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);

    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        keyboardType: inputType,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
