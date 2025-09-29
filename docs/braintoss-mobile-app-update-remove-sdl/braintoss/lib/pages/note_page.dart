import 'dart:ui';
import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/pages/capture_page.dart';
import 'package:braintoss/pages/stateless_page.dart';
import 'package:braintoss/stores/note_store.dart';
import 'package:braintoss/widgets/molecules/send_popup.dart';
import 'package:braintoss/widgets/atoms/textual_multiple_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:seafarer/seafarer.dart';
import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../widgets/atoms/bubble_button.dart';
import '../widgets/atoms/labeled_icon_button.dart';
import '../widgets/molecules/actions_popup.dart';
import '../widgets/molecules/main_header.dart';

class NotePage extends StatelessPage<NoteStore> {
  NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainHeader(
        action: store.onGoBack,
        headingText: AppLocalizations.of(context)!.headerTextNote,
        actionIcon: ButtonImages.closeScreen,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    store.setContext(context);
    final args = Seafarer.args<CapturePageArgs>(context);
    store.setSharedNote(args?.noteText ?? "");

    return Stack(
      children: [
        Column(
          children: [
            //Text field
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: store.textFieldController,
                  onChanged: (String text) {},
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ).merge(TextStyles.noteTextField),
                  maxLines: null,
                  decoration: null,
                  autofocus: true,
                ),
              ),
            ),
            //Send button
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                      child: Observer(
                        builder: (_) {
                          return AnimatedOpacity(
                            opacity: store.actionPopupVisible ? 0 : 1,
                            duration: quickTransition,
                            child: BubbleButton(
                              imagePath: ButtonImages.send,
                              diameter: 85,
                              onLongPress: store.onLongPressSend,
                              onTap: store.onTapSend,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //Actions popup
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.actionPopupVisible ? 1 : 0,
              duration: quickTransition,
              onEnd: store.onActionPopupAnimationEnd,
              child: Visibility(
                visible: store.actionPopupInteractable,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ActionsPopup(
                    onOutsideTap: store.closeActionPopup,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.40)
                            : ThemeColors.grayDark.withOpacity(.85),
                    child: _buildActionPopupContent(context),
                  ),
                ),
              ),
            );
          },
        ),
        //Long-press email popup
        Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.longPressSendListVisible ? 1 : 0,
              duration: quickTransition,
              onEnd: store.onLongPressSendAnimationEnd,
              child: Visibility(
                visible: store.longPressSendListInteractable,
                child: SendPopup(
                    onTapOutside: store.closeLongPressSendList,
                    child: _buildEmailList(
                      store.onEmailSelectionFromLongPressSend,
                    )),
              ),
            );
          },
        ),
        //Action button
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
            child: SizedBox(
              width: 85,
              height: 85,
              child: Center(
                child: Observer(builder: (_) {
                  return AnimatedCrossFade(
                    crossFadeState: store.actionPopupVisible
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: BubbleButton(
                      imagePath: ButtonImages.plus,
                      diameter: 40,
                      onTap: store.openActionPopup,
                    ),
                    secondChild: BubbleButton(
                      imagePath: ButtonImages.closePopup,
                      imageColor: Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSecondary,
                      diameter: 40,
                      onTap: store.closeActionPopup,
                    ),
                    duration: quickTransition,
                  );
                }),
              ),
            ),
          ),
        ),
        //Success overlay
        Observer(builder: (_) {
          return AnimatedOpacity(
            opacity: store.successOverlayVisible ? 1 : 0,
            duration: quickTransition,
            onEnd: store.showSuccessIcon,
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: store.successOverlayVisible,
                ),
                Visibility(
                  visible: store.successOverlayVisible,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: AnimatedOpacity(
                        opacity: store.successIconVisible ? 1.0 : 0.0,
                        duration: mediumQuickTransition,
                        onEnd: store.onSuccessIconAnimationEnd,
                        child: Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: AnimatedOpacity(
                                  opacity: store.successIconVisible ? 1.0 : 0.0,
                                  duration: mediumQuickTransition,
                                  onEnd: store.onSuccessIconAnimationEnd,
                                  child: Image.asset(
                                    MiscImages.success,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )),
                        )),
                  ),
                ),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _buildEmailList(void Function(dynamic) onSelection) {
    if (store.emails.length > 1) {
      return TextualMultipleChoice(
        initialSelectionValue: store.selectedEmail.getAliasOrEmail(),
        onValueChanged: onSelection,
        items: store.emails
            .map(
              (email) => TextualMultipleChoiceItem(
                labelText: email.getAliasOrEmail(),
                value: email,
              ),
            )
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildActionPopupContent(BuildContext context) {
    return Column(
      children: [
        _buildEmailList(store.onEmailSelectionChangeFromPopup),
        Row(
          children: [
            Expanded(
              child: LabeledIconButton(
                label: AppLocalizations.of(context)!.notePaste,
                icon: ButtonImages.paste,
                iconSize: 30,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
                onTap: store.onPaste,
              ),
            ),
            Expanded(
              child: LabeledIconButton(
                label: AppLocalizations.of(context)!.noteClear,
                icon: ButtonImages.clear,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                iconSize: 30,
                separation: 5,
                labelStyle: TextStyles.actionPopupButtonLabel.merge(
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
                onTap: store.onClearNote,
              ),
            )
          ],
        ),
      ],
    );
  }
}
