import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/history_voice_preview_store.dart';

import 'package:braintoss/routes.dart';

import 'package:braintoss/widgets/atoms/bubble_button.dart';
import 'package:braintoss/widgets/atoms/textual_multiple_choice.dart';
import 'package:braintoss/widgets/molecules/capture_list_item.dart';
import 'package:braintoss/widgets/molecules/history_preview_header.dart';
import 'package:braintoss/widgets/molecules/send_popup.dart';

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/capture_model.dart';

import 'package:seafarer/seafarer.dart';

import '../config/theme.dart';
import '../widgets/atoms/capture_status_banner.dart';

class HistoryVoicePreviewArgs extends BaseStoreArguments {
  final Capture captureModel;
  HistoryVoicePreviewArgs(this.captureModel);
}

class HistoryVoicePreviewPage extends StatefulPage<HistoryVoicePreviewStore> {
  const HistoryVoicePreviewPage({super.key});

  @override
  _HistoryVoicePreviewState createState() => _HistoryVoicePreviewState();
}

class _HistoryVoicePreviewState
    extends StatefulPageState<HistoryVoicePreviewStore> {
  @override
  void initState() {
    super.initState();
    store.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.setCaptureModel(
          Seafarer.args<HistoryVoicePreviewArgs>(context)!.captureModel);
    });
  }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HistoryPreviewHeader(
        action: store.onGoBack,
        headingText: AppLocalizations.of(context)!.history,
        deleteItem: store.deleteCapture,
      ),
      body: _buildPageContent(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _captureStatusBanner(),
        Expanded(
          child: Stack(
            children: [
              _captureListItem(),
              _playButton(),
              _successOverlay(),
              _longPressEmailListPopup(),
              _sendButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _captureStatusBanner() {
    return CaptureStatusBanner(
      capture: Seafarer.args<HistoryVoicePreviewArgs>(context)!.captureModel,
    );
  }

  Widget _captureListItem() {
    return CaptureListItem(
      captureModel:
          Seafarer.args<HistoryVoicePreviewArgs>(context)!.captureModel,
      onPress: () => {},
      dividerType: DividerType.voicePreview,
    );
  }

  Widget _playButton() {
    return Center(
        child: GestureDetector(
            onTap: store.playVoiceMessage,
            child: Observer(builder: (_) {
              return Image.asset(
                store.isSoundPlaying ? HistoryIcons.pause : HistoryIcons.play,
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onSecondary,
              );
            })));
  }

  Widget _sendButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Observer(
          builder: (_) {
            return AnimatedOpacity(
              opacity: store.longPressSendListVisible ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: BubbleButton(
                imagePath: ButtonImages.send,
                diameter: 85,
                onLongPress: store.onLongPressSend,
                onTap: store.onSend,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _longPressEmailListPopup() {
    return Observer(
      builder: (_) {
        return AnimatedOpacity(
          opacity: store.longPressSendListVisible ? 1 : 0,
          duration: const Duration(milliseconds: 300),
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

  Widget _successOverlay() {
    return Observer(builder: (_) {
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
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.40),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: store.successIconVisible ? 1.0 : 0.0,
                          duration: mediumQuickTransition,
                          onEnd: store.onSuccessIconAnimationEnd,
                          child: Image.asset(
                            MiscImages.success,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
