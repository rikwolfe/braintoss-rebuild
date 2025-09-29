import 'package:braintoss/config/theme.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class TextualMultipleChoiceItem {
  TextualMultipleChoiceItem({
    required this.labelText,
    required this.value,
  });
  final String labelText;
  final dynamic value;
}

class TextualMultipleChoice<T> extends StatefulWidget {
  const TextualMultipleChoice({
    super.key,
    required this.items,
    required this.initialSelectionValue,
    required this.onValueChanged,
    this.divider,
    this.labelSelectedStyle,
    this.labelUnselectedStyle,
    this.labelPadding,
  });

  final List<TextualMultipleChoiceItem>? items;
  final void Function(dynamic) onValueChanged;
  final Divider? divider;
  final TextStyle? labelUnselectedStyle;
  final TextStyle? labelSelectedStyle;
  final EdgeInsets? labelPadding;
  final T initialSelectionValue;

  @override
  State<TextualMultipleChoice> createState() => _TextualMultipleChoiceState();
}

class _TextualMultipleChoiceState extends State<TextualMultipleChoice> {
  int selectedIndex = 0;

  @override
  initState() {
    super.initState();
    selectedIndex = widget.items?.indexWhere(
            (element) => element.labelText == widget.initialSelectionValue) ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    Color unselected = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.onSecondaryContainer;
    Color selected = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.onSecondary
        : ThemeColors.primaryYellowSelection;

    return Column(
      children: widget.items
              ?.mapIndexed(
                (index, item) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            selectedIndex = index;
                            widget.onValueChanged(item.value);
                          },
                        );
                      },
                      child: Padding(
                        padding:
                            widget.labelPadding ?? const EdgeInsets.all(2.0),
                        child: Text(
                          item.labelText,
                          style: TextStyles.emailsLabel
                              .merge(
                                TextStyle(
                                    color: index == selectedIndex
                                        ? selected
                                        : unselected),
                              )
                              .merge(index == selectedIndex
                                  ? widget.labelSelectedStyle
                                  : widget.labelUnselectedStyle),
                        ),
                      ),
                    ),
                    widget.divider ??
                        Divider(
                          color: Theme.of(context).colorScheme.secondary,
                          thickness: 1,
                        ),
                  ],
                ),
              )
              .toList() ??
          [],
    );
  }
}
