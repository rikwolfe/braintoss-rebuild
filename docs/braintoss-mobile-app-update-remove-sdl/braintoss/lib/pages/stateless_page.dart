import 'package:braintoss/inject/injectstores_extensions.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:flutter/widgets.dart';

abstract class StatelessPage<S extends BaseStore> extends StatelessWidget {
  final S store;
  StatelessPage({super.key})
      : store = ModuleContainer.shared.getStore<S>();
  @protected
  const StatelessPage.withStore({super.key, required this.store});
}
