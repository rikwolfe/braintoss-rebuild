import 'dart:io';
import 'dart:ui';

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'package:braintoss/widgets/molecules/capture_list_item.dart';
import 'package:braintoss/widgets/molecules/history_preview_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:seafarer/seafarer.dart';

import '../config/theme.dart';
import '../stores/history_photo_store.dart';
import '../widgets/atoms/capture_status_banner.dart';
import '../widgets/atoms/textual_multiple_choice.dart';
import '../widgets/molecules/send_popup.dart';

class HistoryPhotoPreviewArgs extends BaseStoreArguments {
  final Capture captureModel;
  HistoryPhotoPreviewArgs(
    this.captureModel,
  );
}

class HistoryPhotoPage extends StatefulPage<HistoryPhotoStore> {
  const HistoryPhotoPage({super.key});

  @override
  _HistoryPhotoPageState createState() => _HistoryPhotoPageState();
}

class _HistoryPhotoPageState extends StatefulPageState<HistoryPhotoStore> {
  @override
  void initState() {
    super.initState();
    store.setContext(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.setCaptureModel(
          Seafarer.args<HistoryPhotoPreviewArgs>(context)!.captureModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildPageContent(context),
        appBar: HistoryPreviewHeader(
            deleteItem: store.deleteCapture,
            action: store.onGoBack,
            headingText: AppLocalizations.of(context)!.history),
        backgroundColor: Theme.of(context).colorScheme.surface);
  }

  Widget _buildPageContent(BuildContext context) {
    final args = Seafarer.args<HistoryPhotoPreviewArgs>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CaptureStatusBanner(
          capture: args!.captureModel,
        ),
        CaptureListItem(
            captureModel: args.captureModel, onPress: () => Container()),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              //Image
              InteractiveViewer(
                child: Image.file(
                  File(getFullFilePath(args.captureModel.filename)),
                ),
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
                          bottomOffset: 20,
                          onTapOutside: store.closeLongPressSendList,
                          child: _buildEmailList(
                            store.onEmailSelectionFromLongPressSend,
                          )),
                    ),
                  );
                },
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
                          child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.85),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: AnimatedOpacity(
                                    opacity:
                                        store.successIconVisible ? 1.0 : 0.0,
                                    duration: mediumQuickTransition,
                                    onEnd: store.onSuccessIconAnimationEnd,
                                    child: Image.asset(
                                      MiscImages.success,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: store.onSend,
              onLongPress: store.onLongPressSend,
              child: Image.asset(ButtonImages.send),
            ),
          ),
        )
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
}
