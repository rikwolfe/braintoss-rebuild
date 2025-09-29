import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.confirmationCallback,
    required this.title,
    required this.text,
    required this.confirmationLabel,
    required this.dismissLabel,
  });

  final VoidCallback confirmationCallback;
  final String title;
  final String text;
  final String confirmationLabel;
  final String dismissLabel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Wrap(
        children: [
          Align(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(text),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              dismissLabel,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            )),
        TextButton(
          child: Text(
            confirmationLabel,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () => deleteHistory(context),
        ),
      ],
    );
  }

  void deleteHistory(BuildContext context) {
    confirmationCallback();
    Navigator.pop(context);
  }
}
