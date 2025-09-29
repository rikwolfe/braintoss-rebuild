import 'package:braintoss/inject/injectstores_extensions.dart';
import 'package:flutter/widgets.dart';
import '../stores/base_store.dart';

abstract class StatefulPage<S extends BaseStore> extends StatefulWidget {
  const StatefulPage({super.key});

  @override
  StatefulPageState<S> createState();
}

abstract class StatefulPageState<S extends BaseStore>
    extends State<StatefulPage<S>> {
  final S store;

  StatefulPageState() : store = ModuleContainer.shared.getStore<S>();
}
