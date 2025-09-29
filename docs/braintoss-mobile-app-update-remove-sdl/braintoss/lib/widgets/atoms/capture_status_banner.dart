import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../models/capture_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CaptureStatusBanner extends StatelessWidget {
  const CaptureStatusBanner({
    required this.capture,
    super.key,
  });

  final Capture capture;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: capture.statusCode != null &&
          capture.statusCode != 0 &&
          capture.captureStatus != CaptureStatus.sent,
      child: Container(
        color: capture.captureStatus == CaptureStatus.queue
            ? ThemeColors.primaryYellowDarker
            : ThemeColors.error,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${capture.statusCode} - ${capture.description ?? getStatusMessage(context, capture.statusCode)}",
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              Text(
                capture.description ??
                    getStatusMessage(context, capture.statusCode),
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getStatusMessage(BuildContext context, int? statusCode) {
    switch (statusCode) {
      case 300:
        return AppLocalizations.of(context)!.noInternetConnection;
      case 118:
        return AppLocalizations.of(context)!.blacklisted;
      default:
        return "";
    }
  }
}
