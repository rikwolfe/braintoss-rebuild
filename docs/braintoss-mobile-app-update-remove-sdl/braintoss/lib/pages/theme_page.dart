import 'package:braintoss/stores/theme_page_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/widgets/molecules/main_header.dart';
import '../models/theme_checkbox_model.dart';

class ThemePage extends StatefulPage<ThemePageStore> {
  const ThemePage({super.key});

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends StatefulPageState<ThemePageStore> {
  bool? value = false;

  @override
  Widget build(BuildContext context) {
    store.setContext(context);
    return Scaffold(
      appBar: MainHeader(
          action: () => store.onGoBack(),
          headingText: AppLocalizations.of(context)!.themeHeader,
          actionIcon: ButtonImages.back),
      body: _buildPageContent(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Center(
      child: Observer(
        builder: (_) {
          return ListView(
            children: [
              ...store.themes.map(_themeOptionRow),
            ],
          );
        },
      ),
    );
  }

  Widget _themeOptionRow(ThemeCheckBox quickstartCheckBox) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ThemeColors.gray, width: 0.3))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Observer(
              builder: (_) {
                return Expanded(
                  child: RadioListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    value:
                        store.isSelectedOption(quickstartCheckBox.optionValue),
                    onChanged: (value) => setState(
                      () {
                        store.setSelectedOption(quickstartCheckBox.optionValue);
                      },
                    ),
                    title: Text(quickstartCheckBox.optionName,
                        style: const TextStyle(fontSize: 16)),
                    groupValue: true,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
