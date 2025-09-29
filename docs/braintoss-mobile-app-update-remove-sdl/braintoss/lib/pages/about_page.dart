import 'package:braintoss/pages/stateless_page.dart';
import 'package:braintoss/stores/about_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/molecules/main_header.dart';

class AboutPage extends StatelessPage<AboutStore> {
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
          action: () => store.onGoBack(),
          headingText: AppLocalizations.of(context)!.headerTextAbout),
      body: _buildPageContent(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return FutureBuilder(
      future: store.getContent(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.hasData) {
          return Html(
            data: snapshot.data,
            onLinkTap: store.onLinkTap,
            style: {
              "a": Style(color: Theme.of(context).colorScheme.secondary),
              "strong": Style(color: Theme.of(context).colorScheme.secondary)
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.aboutUnableToLoad),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
