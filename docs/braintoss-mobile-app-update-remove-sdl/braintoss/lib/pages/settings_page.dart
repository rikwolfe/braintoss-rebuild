import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/pages/stateless_page.dart';
import 'package:braintoss/stores/settings_store.dart';
import 'package:braintoss/widgets/atoms/email_cell.dart';
import 'package:braintoss/widgets/molecules/main_header.dart';
import 'package:braintoss/widgets/atoms/language_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../widgets/atoms/navigation_action_cell.dart';
import '../widgets/atoms/switch_cell.dart';
import '../widgets/atoms/action_cell.dart';
import '../widgets/atoms/add_email_cell.dart';
import '../widgets/atoms/default_email_cell.dart';
import '../constants/colors.dart';
import '../constants/links.dart';

class SettingsPage extends StatelessPage<SettingsStore> {
  SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MainHeader(
          actionIcon: ButtonImages.back,
          action: () => store.onGoBack(),
          headingText: AppLocalizations.of(context)!.headerTextSettings),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    store.getEmail();
    store.getEmailList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Observer(
            builder: (_) => DefaultEmailCell(
              defaultEmail: store.defaultEmail,
              editEmail: (Email newMail, Email oldEmail) =>
                  store.editEmail(newMail),
              duplicateEmail: (String email) => store.duplicateEmail(email),
              duplicateAlias: (String email) => store.duplicateAlias(email),
            ),
          ),
          Observer(
            builder: (_) => store.emails.isEmpty
                ? Container()
                : EmailCell(
                    emails: store.emails,
                    newEmailList: (List<Email> emails) =>
                        store.saveEmailList(emails),
                    editEmail: (Email newMail, Email oldMail) =>
                        store.editCellEmail(newMail, oldMail),
                    duplicateEmail: (String email) =>
                        store.duplicateEmail(email),
                    duplicateAlias: (String alias) =>
                        store.duplicateAlias(alias),
                  ),
          ),
          Observer(
            builder: (_) => store.emails.length == 4
                ? Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ThemeColors.gray, width: 0.5),
                      ),
                    ),
                    child: ListTile(
                      title: Text(AppLocalizations.of(context)!.fiveIsLimit),
                      leading: const Icon(Icons.block),
                    ),
                  )
                : AddEmailCell(
                    duplicateEmail: (String email) =>
                        store.duplicateEmail(email),
                    duplicateAlias: (String alias) =>
                        store.duplicateAlias(alias),
                    emailCallback: (Email newMail, Email oldMail) =>
                        store.addEmail(newMail),
                  ),
          ),
          ActionCell(
            action: () => store.openURL(ThemeLinks.links.notReceivingEmails),
            textStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onTertiary
                  : ThemeColors.white,
            ),
          ),
          const LanguageSelector(
            type: LanguageSelectorType.settings,
          ),
          Observer(
            builder: (_) => SwitchCell(
              isSwitched: store.isSoundSwitched,
              switchText: AppLocalizations.of(context)!.sound,
              handleSwitchToggle: (String switchText, bool value) =>
                  store.handleSwitchToggle(switchText, value),
            ),
          ),
          Observer(
            builder: (_) => SwitchCell(
              isSwitched: store.isVibrationSwitched,
              switchText: AppLocalizations.of(context)!.vibration,
              handleSwitchToggle: (String switchText, bool value) =>
                  store.handleSwitchToggle(switchText, value),
            ),
          ),
          Observer(
            builder: (_) => SwitchCell(
              isSwitched: store.isProximitySwitched,
              switchText: AppLocalizations.of(context)!.proximity,
              handleSwitchToggle: (String switchText, bool value) =>
                  store.handleSwitchToggle(switchText, value),
            ),
          ),
          NavigationActionCell(
              displayName: AppLocalizations.of(context)!.settingsTheme,
              action: store.onGoToTheme),
          NavigationActionCell(
              displayName: AppLocalizations.of(context)!.quickStart,
              action: store.onGoToQuickstart),
          NavigationActionCell(
              displayName: AppLocalizations.of(context)!.history,
              action: store.onGoToHistory),
          NavigationActionCell(
              displayName: AppLocalizations.of(context)!.tutorial,
              action: store.onGoToTutorial),
          NavigationActionCell(
              displayName: AppLocalizations.of(context)!.about,
              action: store.onGoToAbout),
          NavigationActionCell(
            displayName: AppLocalizations.of(context)!.share,
            action: () => store.handleShareAction(
                AppLocalizations.of(context)!.shareApplicationText +
                    ThemeLinks.links.braintossWebSite),
          ),
        ],
      ),
    );
  }
}
