import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

Future<void> showApiKeyDialog(BuildContext context) {
  final state = context.read<AppState>();
  final controller = TextEditingController(text: state.apiKey);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Gemini API key'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Get a free key at aistudio.google.com/apikey. '
              'It is stored only on this device.'),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'API key'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            state.setApiKey(controller.text);
            Navigator.pop(ctx);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
