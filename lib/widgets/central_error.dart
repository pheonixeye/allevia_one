import 'package:flutter/material.dart';
import 'package:allevia_one/assets/assets.dart';
import 'package:allevia_one/errors/code_to_error.dart';
import 'package:allevia_one/extensions/loc_ext.dart';
import 'package:allevia_one/functions/shell_function.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CentralError extends StatelessWidget {
  const CentralError({
    super.key,
    required this.code,
    required this.toExecute,
  });
  final int? code;
  final Future<void> Function() toExecute;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.outlined(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Image.asset(
                AppAssets.errorIcon,
                width: 75,
                height: 75,
              ),
              Consumer<PxLocale>(
                builder: (context, l, _) {
                  return Text(
                    CodeToError(code).errorMessage(l.isEnglish),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await toExecute();
                    },
                  );
                },
                label: Text(context.loc.retry),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.green.shade100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
