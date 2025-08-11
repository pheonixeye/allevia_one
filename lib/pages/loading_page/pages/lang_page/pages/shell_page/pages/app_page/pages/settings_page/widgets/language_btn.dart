import 'package:flutter/material.dart';
import 'package:allevia_one/extensions/switch_lang.dart';
import 'package:allevia_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class LanguageBtn extends StatelessWidget {
  const LanguageBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: 'language-btn',
      onPressed: () {
        context.switchLanguage();
      },
      child: Consumer<PxLocale>(
        builder: (context, l, _) {
          return Text(l.isEnglish ? 'AR' : 'EN');
        },
      ),
    );
  }
}
