import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/strings.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(noServerConnection),
      content: const Text(connectToInternetOrAdmin),
      actions: [
        TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text(ok)),
      ],
    );
  }
}
