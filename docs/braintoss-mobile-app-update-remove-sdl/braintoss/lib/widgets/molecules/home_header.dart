import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_app_badger/flutter_app_badger.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({
    super.key,
    this.onHistory,
    this.onSettings,
    required this.errorCaptured,
    required this.getFailedCaptures,
  });

  final void Function()? onHistory;
  final void Function()? onSettings;
  final Future<List<Capture>> Function() getFailedCaptures;
  final bool errorCaptured;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Capture>>(
      future: getFailedCaptures(),
      builder: (context, AsyncSnapshot<List<Capture>> snapshot) {
        errorCaptured
            ? FlutterAppBadger.updateBadgeCount(snapshot.data!.length)
            : FlutterAppBadger.removeBadge();
        return AppBar(
          centerTitle: true,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              AppLocalizations.of(context)!.appName,
              style: const TextStyle(
                fontSize: 37,
                color: ThemeColors.primaryYellowDarker,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: GestureDetector(
            onTap: onHistory,
            child: errorCaptured
                ? badges.Badge(
                    badgeAnimation: const badges.BadgeAnimation.scale(),
                    position: badges.BadgePosition.custom(bottom: 0, end: 0),
                    badgeContent: Text(
                      snapshot.data!.length.toString(),
                      style: const TextStyle(color: ThemeColors.white),
                    ),
                    child: Image.asset('assets/images/Menu_Archive_Icon.png'),
                  )
                : Image.asset('assets/images/Menu_Archive_Icon.png'),
          ),
          actions: [
            GestureDetector(
              onTap: onSettings,
              child: Image.asset('assets/images/Menu_Settings_Icon.png'),
            )
          ],
          elevation: 0,
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
