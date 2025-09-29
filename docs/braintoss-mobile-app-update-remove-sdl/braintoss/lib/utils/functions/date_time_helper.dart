import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime captureDate, BuildContext context) {
  final currentDate = DateTime.now();

  Intl.defaultLocale = Localizations.localeOf(context).toString();

  if (captureDate.day == currentDate.day) {
    return AppLocalizations.of(context)!.today;
  } else if (captureDate.day == currentDate.day - 1) {
    return AppLocalizations.of(context)!.yesterday;
  } else {
    return DateFormat("MMM dd").format(captureDate);
  }
}

String getFormattedTime(DateTime captureDate, BuildContext context) {
  return DateFormat("HH:mm").format(captureDate);
}
