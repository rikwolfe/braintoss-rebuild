import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/voice_store.dart';
import 'package:braintoss/widgets/atoms/bubble_button.dart';
import 'package:braintoss/widgets/atoms/textual_multiple_choice.dart';
import 'package:braintoss/widgets/molecules/actions_popup.dart';
import 'package:braintoss/widgets/molecules/main_header.dart';
import 'package:braintoss/widgets/molecules/send_popup.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/config/theme.dart';

class VoicePage extends StatefulPage<VoiceStore> {
  const VoicePage({super.key});

  @override
  _VoicePageState createState() => _VoicePageState();
}

class _VoicePageState extends StatefulPageState<VoiceStore>
    with TickerProviderStateMixin {
  late AnimationController progressBarController = AnimationController(
    animationBehavior: AnimationBehavior.preserve,
    duration: const Duration(
      seconds: Dimensions.voiceRecordTimeLimitInSeconds,
    ),
    vsync: this,
  )..addListener(
      () {
        setState(() {});
        if (progressBarController.isCompleted) {
          store.sendVoiceMessage();
        }
      },
    );

  @override
  initState() {
    store.initState(progressBarController);
    super.initState();
  }

  @override
  dispose() {
    if (progressBarController.isAnimating) {
      progressBarController.stop();
    }
    progressBarController.dispose();
    store.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => store.isProximityNear && store.isProximityOn
          ? Container()
          : ScaffoldMessenger(
              child: Scaffold(
                appBar: MainHeader(
                  action: store.onGoBack,
                  headingText: AppLocalizations.of(context)!.headerTextVoice,
                  actionIcon: ButtonImages.closeScreen,
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Builder(
                  builder: (BuildContext context) {
                    store.setContext(context);
                    return _buildPageContent();
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildPageContent() {
    return Observer(
      builder: (_) => store.isProximityNear && store.isProximityOn
          ? GestureDetector(
              child: Container(color: ThemeColors.black),
            )
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          _circularProgressBar(),
                          _microphone(),
                          _successWidget(),
                        ],
                      ),
                    ),
                    Expanded(flex: 1, child: _sendButton()),
                  ],
                ),
                _emailListPopup(),
                _showEmailsButton(),
                _longPressEmailListPopup(),
              ],
            ),
    );
  }

  Widget _microphone() {
    return SizedBox(
      width: Dimensions.voiceMicrophoneAndCircleSize,
      height: Dimensions.voiceMicrophoneAndCircleSize,
      child: GestureDetector(
        onTap: () => store.sendVoiceMessage(),
        child: Image.asset(MiscImages.microphone,
            color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }

  Widget _circularProgressBar() {
    return SizedBox(
      width: Dimensions.voiceMicrophoneAndCircleSize,
      height: Dimensions.voiceMicrophoneAndCircleSize,
      child: CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(
            ThemeColors.primaryYellowDarker),
        strokeWidth: 20.0,
        value: progressBarController.value,
      ),
    );
  }

  Widget _sendButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.emailsPopupVisible ? 0 : 1,
              duration: quickTransition,
              child: BubbleButton(
                imagePath:
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? ButtonImages.voiceSend
                        : ButtonImages.send,
                diameter: 85,
                onLongPress: store.onLongPressSend,
                onTap: () => store.sendVoiceMessage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _showEmailsButton() {
    return Visibility(
      visible: store.emails.length > 1,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
          child: SizedBox(
            width: 85,
            height: 85,
            child: Center(
              child: Observer(
                builder: (_) {
                  return AnimatedCrossFade(
                    crossFadeState: store.emailsPopupVisible
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: BubbleButton(
                      imagePath: ButtonImages.plus,
                      diameter: 40,
                      onTap: store.openEmailsPopup,
                    ),
                    secondChild: BubbleButton(
                      imagePath: ButtonImages.closePopup,
                      imageColor: Theme.of(context).colorScheme.brightness ==
                              Brightness.light
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onSecondary,
                      diameter: 40,
                      onTap: store.closeEmailsPopup,
                    ),
                    duration: quickTransition,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailListPopup() {
    return Observer(
      builder: (_) {
        return AnimatedOpacity(
          opacity: store.emailsPopupVisible ? 1 : 0,
          duration: quickTransition,
          onEnd: store.onActionPopupAnimationEnd,
          child: Visibility(
            visible: store.emailsPopupInteractable,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ActionsPopup(
                onOutsideTap: store.closeEmailsPopup,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? ThemeColors.white.withOpacity(.70)
                        : ThemeColors.grayDark.withOpacity(.85),
                child: _buildEmailList(store.onEmailSelectionChangeFromPopup),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _longPressEmailListPopup() {
    return Observer(
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
              ),
            ),
          ),
        );
      },
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

  Widget _successWidget() {
    return Observer(
      builder: (_) {
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
                  child: Container(
                    color: Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                        ? ThemeColors.primaryYellow.withOpacity(0.65)
                        : ThemeColors.black.withOpacity(0.65),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: store.successIconVisible ? 1.0 : 0.0,
                          duration: mediumQuickTransition,
                          onEnd: store.onSuccessIconAnimationEnd,
                          child: Image.asset(MiscImages.success,
                              color: Theme.of(context).colorScheme.brightness ==
                                      Brightness.light
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.onSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
