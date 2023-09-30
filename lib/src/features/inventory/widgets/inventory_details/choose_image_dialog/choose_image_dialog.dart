import 'package:flutter/material.dart';

class ChooseImageDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();

  ChooseImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Image'),
      insetPadding: const EdgeInsets.all(16),
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: _valueController,
          decoration: const InputDecoration(
            labelText: 'Image URL',
            hintText: 'Choose an image URL for upload.',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            return Uri.tryParse(value ?? '')?.isAbsolute ?? false
                ? null
                : 'Invalid URL';
          },
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _valueController.text);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
