import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Brak połączenia z serwerem'),
      content: const Text('Podłącz się do internetu bądź skontaktuj się z administratorem'),
      actions: [
        TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('OK')),
      ],
    );
  }
}
