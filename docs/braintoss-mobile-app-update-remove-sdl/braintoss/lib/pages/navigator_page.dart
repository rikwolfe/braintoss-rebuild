import 'package:braintoss/services/impl/navigation_service_impl.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/utils/functions/share_intent.dart';
import 'package:flutter/material.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  _NavigatorState createState() => _NavigatorState();
}

class _NavigatorState extends State {
  late ShareIntent shareIntent = ShareIntent(context);
  NavigationService navigationService = NavigationServiceImpl();

  @override
  void initState() {
    super.initState();

    handleNavigation();
  }

  Future<void> handleNavigation() async {
    if (!await shareIntent.isMediaSharedFromClosedApp()) {
      navigationService.goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
