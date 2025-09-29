import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class SwitchCell extends StatefulWidget {
  const SwitchCell(
      {super.key,
      required this.switchText,
      required this.handleSwitchToggle,
      required this.isSwitched});

  final String switchText;
  final bool isSwitched;
  final Function(String switchText, bool value) handleSwitchToggle;

  @override
  State<SwitchCell> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ThemeColors.gray, width: 0.5))),
        child: ListTile(
          title: Text(widget.switchText,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          trailing: Switch(
            value: widget.isSwitched,
            onChanged: (value) {
              widget.handleSwitchToggle(widget.switchText, value);
            },
            activeColor: Theme.of(context).colorScheme.secondary,
            inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
          ),
        ));
  }
}
