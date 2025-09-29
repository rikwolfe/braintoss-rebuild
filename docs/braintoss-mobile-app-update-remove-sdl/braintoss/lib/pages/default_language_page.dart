import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/default_language_store.dart';

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';

import 'package:braintoss/models/language_checkbox_model.dart';
import 'package:braintoss/widgets/molecules/main_header.dart';

class DefaultLanguagePage extends StatefulPage<DefaultLanguageStore> {
  const DefaultLanguagePage({super.key});

  @override
  _DefaultLanguagePageState createState() => _DefaultLanguagePageState();
}

class _DefaultLanguagePageState
    extends StatefulPageState<DefaultLanguageStore> {
  bool? value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
          action: () => store.onGoBack(),
          headingText: AppLocalizations.of(context)!.languages,
          actionIcon: ButtonImages.back),
      body: _buildPageContent(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Center(child: Observer(builder: (_) {
      return store.languages.isNotEmpty
          ? ListView(
              children: [
                ...store.languages.map(_languageRow),
              ],
            )
          : const CircularProgressIndicator();
    }));
  }

  Widget _languageRow(LanguageCheckBox languageCheckBox) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ThemeColors.gray, width: 0.3))),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Observer(builder: (_) {
                return Expanded(
                    child: RadioListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  value: store.isSelectedLanguage(languageCheckBox.language),
                  onChanged: (value) => setState(() {
                    store.setSelectedLanguage(languageCheckBox.language);
                  }),
                  title: Text(
                      '${languageCheckBox.language.languageName} ${languageCheckBox.language.localCode}',
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              Theme.of(context).textTheme.labelLarge!.color)),
                  groupValue: true,
                ));
              })
            ],
          ),
        ));
  }
}
