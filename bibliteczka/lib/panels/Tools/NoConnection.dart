import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.noServerConnection),
      content: Text(AppLocalizations.of(context)!.connectToInternetOrAdmin),
      actions: [
        TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: Text(AppLocalizations.of(context)!.ok)),
      ],
    );
  }
}
